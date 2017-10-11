program task;
{$mode objfpc}

uses
 SysUtils,
 Classes;

type
 TRifmTypes = (rtNO, rtCCDD, rtCDCD, rtCDDC);
 
const
 VRifmTypes: array[rtNO..rtCDDC] of string = ('NO','CCDD','CDCD','CDDC');
 VAlphaChars: set of char = ['a','e','i','o','u','y'];

function RifmStructGetVal(rs:string; i:byte):string;
begin
 Result := 'FAILED';
 while i>1 do
  begin
   if Pos('-',rs) = 0 then
    exit;
   delete(rs,1,Pos('-',rs));
   dec(i);
  end;
 if Pos('-',rs) = 0 then
  Result := rs
 else
  Result :=copy(rs,1,Pos('-',rs)-1);
end;

function CheckRifm(a,b,c,d:byte; s,rstruct:string):boolean;
begin
 Result := (s[a] = s[b]) and (s[c] = s[d]) and
           (RifmStructGetVal(rstruct,a) = RifmStructGetVal(rstruct,b)) and
           (RifmStructGetVal(rstruct,c) = RifmStructGetVal(rstruct,d));
end;

function TransformRifmType(s,rstruct:string):string;
begin
 Result := VRifmTypes[rtNO];
 if Length(s)=4 then
  begin
    if CheckRifm(1,2,3,4,s,rstruct) then Result := VRifmTypes[rtCCDD];
    if CheckRifm(1,3,2,4,s,rstruct) then Result := VRifmTypes[rtCDCD];
    if CheckRifm(1,4,2,3,s,rstruct) then Result := VRifmTypes[rtCDDC];
  end;
end;

function GetLstChar(s:string):char;
begin
 if Length(s)>0 then
  Result := s[Length(s)]
 else
  Result := #0;
end;

function GetRifmType(sl:TStringList; rstruct:string):string;
var
 w:word;
 rifm:string;
begin
 w := 0;
 rifm := '';
 while w<sl.Count do
  begin
    rifm := rifm + GetLstChar(sl[w]);
    inc(w);
  end;
 Result := TransformRifmType(rifm,rstruct);
end;

function CountAlphaChars(s:string):word;
begin
 Result := 0;
 while Length(s)>0 do
  begin
    if s[1] in VAlphaChars then inc(Result);
    Delete(s,1,1);
  end;
end;

function GetRifmStruct(sl:TStringList):string;
var
 w:word;
begin
 w := 0;
 Result := '';
 while w<sl.Count do
  begin
    if Length(sl[w])>0 then
     begin
       if Result <> '' then
        Result := Result + '-';
       Result := Result + IntToStr(CountAlphaChars(LowerCase(sl[w])));
     end;
    inc(w);
  end;
end;

var 
 f:TextFile;
 sl:TStringList;
 rstruct:string;
begin
 sl := TStringList.Create;
 sl.LoadFromFile(ExtractFilePath(ParamStr(0))+'input.txt');
 AssignFile(f,ExtractFilePath(ParamStr(0))+'output.txt');
 Rewrite(f);
 rstruct := GetRifmStruct(sl);
 writeln(f, GetRifmType(sl,rstruct));
 writeln(f, rstruct);
 CloseFile(f);
 sl.Free;
end.
