program task;
{$mode objfpc}

uses
 SysUtils;

function summ(a:cardinal):word;
begin
 Result := 0;
 while a>0 do
  begin
    inc(Result, a mod 10);
    a := a div 10;
  end;
end;

procedure check(var a,b:cardinal);
var
 c:cardinal;
begin
 if a>b then
  begin
    c := a;
    a := b;
    b := c;
  end;
end;

var 
 f:textfile;
 a,b:cardinal;
 j: word;
begin
 j := 0;
 assignfile(f,ExtractFilePath(ParamStr(0))+'input.txt');
 reset(f);
 read(f,a,b);
 closefile(f);
 check(a,b);
 while a <= b do
  begin
    if summ(a) mod 13 = 0 then
     inc(j);
    inc(a);
  end;
 assignfile(f,ExtractFilePath(ParamStr(0))+'output.txt');
 rewrite(f);
 write(f,j);
 closefile(f);
end.
