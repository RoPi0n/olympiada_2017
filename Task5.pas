program task;
{$mode objfpc}

uses
 SysUtils;

type
 TNode = array of cardinal;
 PNode = ^TNode;
 TNodeContainer = array of PNode;
 PNodeContainer = ^TNodeContainer;
 
var
 nodec: PNodeContainer;

function NewNode(sz:cardinal):PNode;
begin
 new(Result);
 SetLength(Result^,sz);
end;

procedure FillNode(n:PNode; var v:cardinal);
var
 w:word;
begin
 for w:=0 to Length(n^)-1 do
  begin
   n^[w] := v;
   inc(v);
  end;
end;

procedure NC_AddNode(nc:PNodeContainer; n:PNode);
begin
 SetLength(nc^,Length(nc^)+1);
 nc^[Length(nc^)-1] := n;
end;
 
procedure FillMatrix(EndItem:cardinal);
var
 c,v:cardinal;
 n:PNode;
begin
 c := 1;
 v := 1;
 new(nodec);
 while v<EndItem do
  begin
   n := NewNode(c);
   c := c+2;
   FillNode(n,v);
   NC_AddNode(nodec,n);
  end;
end;

type
 TItemAddr = record
  NodeNum, ItemPos: integer;
 end;
 
 PItemAddr = ^TItemAddr;
 
function ItemInNode(n:PNode; v:cardinal):integer;
var
 c:cardinal;
begin
 Result := -1;
 for c:=0 to Length(n^)-1 do
  if n^[c] = v then
   begin
    Result := c;
   end;
end;

procedure FindItem(nc:PNodeContainer; v:cardinal; ia:PItemAddr);
var
 c:cardinal;
 ip:integer;
begin
 ia^.NodeNum := -1;
 ia^.ItemPos := -1;
 for c:=0 to Length(nc^)-1 do
  begin
    ip := ItemInNode(nc^[c],v);
    if ip>0 then
     begin
      ia^.NodeNum := c;
      ia^.ItemPos := ip;
     end;
    if nc^[c]^[0] = v then
     begin
      ia^.NodeNum := c;
      ia^.ItemPos := 0;
     end;
    if nc^[c]^[length(nc^[c]^)-1] = v then
     begin
      ia^.NodeNum := c;
      ia^.ItemPos := length(nc^[c]^)-1;
     end;
  end;  
end;

function GetNears(v:cardinal):string;
var
 ia:TItemAddr;
begin
 Result := '';
 FindItem(nodec,v,@ia);
 if (ia.ItemPos <> -1) and (ia.NodeNum <> -1) then
  begin
    if ia.NodeNum>0 then
     begin
      if (ia.ItemPos > 1) and (ia.ItemPos-1 < (Length(nodec^[ia.NodeNum-1]^)-1)) then
       Result := IntToStr(nodec^[ia.NodeNum-1]^[ia.ItemPos-1]);
     end;
     
    if ia.ItemPos>0 then
     Result := Result + ' ' + IntToStr(nodec^[ia.NodeNum]^[ia.ItemPos-1]);
     
    if ia.ItemPos < Length(nodec^[ia.NodeNum]^)-1 then
     Result := Result + ' ' + IntToStr(nodec^[ia.NodeNum]^[ia.ItemPos+1]);
     
    if ia.NodeNum<Length(nodec^)-1 then
     Result := Result + ' ' + IntToStr(nodec^[ia.NodeNum+1]^[ia.ItemPos+1]);
     
    Result := Trim(Result);
  end;
end;

var 
 f:textfile;
 c:cardinal;
begin
 assignfile(f,ExtractFilePath(ParamStr(0))+'input.txt');
 reset(f);
 readln(f,c);
 closefile(f);
 FillMatrix(1024);
 assignfile(f,ExtractFilePath(ParamStr(0))+'output.txt');
 rewrite(f);
 write(f,GetNears(c));
 closefile(f);
end.
