program task;
{$mode objfpc}

uses
 SysUtils, Math;
 
procedure f_invert(var c:char);
begin
  case c of
   '<': c := '>';
   '>': c := '<';
  end;
end;

procedure f_move(var s:string; var r:word);
var
 c:cardinal;
begin
 c := 1;
 while c<Length(s) do
  begin
    if (s[c] = '>') and (s[c+1] = '<') then
     begin
      f_invert(s[c]);
      f_invert(s[c+1]);
      inc(r);
      inc(c);
     end;
    inc(c); 
  end;
end;

function f_check(s:string):boolean;
var
 c:cardinal;
begin
 Result := True;
 if length(s)>1 then
  for c:=1 to Length(s)-1 do
   if (s[c] = '>') and (s[c+1] = '<') then
    begin
      Result := False;
      break;
    end;
end;

var 
 f:textfile;
 s:string;
 c,r:word;
 i:cardinal;
begin
 assignfile(f,ExtractFilePath(ParamStr(0))+'input.txt');
 reset(f);
 readln(f,c);
 readln(f,s);
 closefile(f);
 r := 0;
 for i:=0 to c*c do
  begin
    if f_check(s) then
     break;
    f_move(s,r);
  end;
 assignfile(f,ExtractFilePath(ParamStr(0))+'output.txt');
 rewrite(f);
 if f_check(s) then
  write(f,r)
 else
  write(f,'NO');
 closefile(f);
end.
