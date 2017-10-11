program task;
{$mode objfpc}

uses
 SysUtils;

type
 TLeather = array of word;
 PLeather = ^TLeather;

function f_min(a,b:cardinal):cardinal;
begin
 if a<b then
  Result := a
 else
  Result := b;
end;

function jump(from:word; leather:PLeather):cardinal;
begin
 if from > Length(Leather^) then
  Result := 0
 else
  begin
    if from > 0 then
     Result := leather^[from-1]
    else
     Result := 0;
    Result := Result + f_min( jump(from+1, leather),
                              jump(from+2, leather) );
  end;
end;

var 
 f:textfile;
 c:cardinal;
 s:string;
 leather:TLeather;
begin
 assignfile(f,ExtractFilePath(ParamStr(0))+'input.txt');
 reset(f);
 readln(f,c);
 readln(f,s);
 closefile(f);
 while length(Trim(s))>0 do
  begin
   s := Trim(s);
   SetLength(Leather, Length(Leather)+1);
   if pos(' ',s)>0 then
    begin
      Leather[Length(Leather)-1] := StrToInt(Copy(s,1,pos(' ',s)-1));
      Delete(s,1,pos(' ',s));
    end
   else
    begin
      Leather[Length(Leather)-1] := StrToInt(s);
      s := '';
    end;
  end;
 assignfile(f,ExtractFilePath(ParamStr(0))+'output.txt');
 rewrite(f);
 write(f,jump(0,@leather));
 closefile(f);
end.
