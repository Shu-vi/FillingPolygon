uses graphABC;
CONST
PI=arctan(1)*4;
MAX_SIZE=31500;
type
pPoint=^tPoint;
tStack = array[1..MAX_SIZE] of pPoint;
tPoint=record
  x:integer;
  y:integer;
end;


//проверка стека на пустоту
function isEmpty(stack:tStack):boolean;
begin
  result:= stack[1]=nil;
end;

//ункция, возвращая элемент стека и + удаляет последний элемент из стека
function pop(var stack:tStack):pPoint;
begin
  if (not isEmpty(stack)) then
  begin
    var i:integer;
    i:=1;
    while stack[i]<> nil do
    begin
      inc(i);
    end;
    result:=stack[i-1];
    stack[i-1]:=nil;
  end;
end;

//процедура,создающая псевдослучайный многоугольник
procedure createRandomPolygon(O:pPoint);
var n:integer;//Rоличество вершин многоугольника
var angle:real;//Углы
var XY:array[0..20] of pPoint;// храним пары точек
var r:integer;//радиус
var i:integer;
begin
  r:=random(60, 130);
  n:=random(3,20);
  angle:=0;
  i:=0;
  while (angle<2*PI) and (i<n) do//полный круг
  begin
    new(xy[i]);
    xy[i]^.x:=o^.x+round(r*cos(angle));
    xy[i]^.y:=o^.y+round(r*sin(angle));
    inc(i);
    angle:=angle+ ((2*PI)/n)*random(0.75, 1.0);
  end;
  i:=0;
  while i<n do
  begin
    line(xy[i]^.x, xy[i]^.y, xy[(i+1) mod n]^.x, xy[(i+1) mod n]^.y);
    inc(i);
  end;
end;

//процедура на добавление элемента в стек
procedure push(O:pPoint; var stack:tStack);
begin
  var i:integer;
  var b:boolean;
  i:=1;
  b:=false;
  while (i<=MAX_SIZE) and (not b) do
  begin
    if (stack[i]=nil) then
    begin
      stack[i]:=O;
      b:=true;
    end
    else
      inc(i);
  end;
end;

//функция на проверку, что пиксель в координате (x, y) имеет белый цвет(цвет области, которую мы закрашиваем)
function isNotExistColor(x:integer; y:integer):boolean;
begin
  var c:=getPixel(x, y);
  if (getRed(c)=255) and (getGreen(c)=255) and (getBlue(c)=255) then
    result:=true
  else
    result:=false;
end;

//функция на проверку, не добавли ли мы уже точку в стек
function isNotExistPoint(x:integer; y:integer; stack:tStack):boolean;
begin
  if isEmpty(stack) then
  begin
    result:=true;
  end
  else
  begin
    var i:integer;
    var b:boolean;
    b:=false;
    i:=1;
    while (stack[i] <>nil) and not b do
    begin
      if (stack[i]^.x = x) and (stack[i]^.y = y) then
      begin
        b:=true;
        result:=false;
      end
      else
      begin
        inc(i);
        result:=true;
      end;
    end;
  end;
end;

//закрашивание многоугольника
procedure paintingOver(O:pPoint);
var point:pPoint;
var stack:tStack;
var p:pPoint;
begin
  new(point);
  push(O, stack);
  while (not isEmpty(stack)) do
  begin
    point:=pop(stack);
    setPixel(point^.x, point^.y, clGreen);
    if isNotExistColor(point^.x-1, point^.y) and isNotExistPoint(point^.x-1, point^.y, stack) then
    begin
      new(p);
      p^.x:=point^.x-1;
      p^.y:=point^.y;
      push(p, stack);
    end;
    if isNotExistColor(point^.x, point^.y-1) and isNotExistPoint(point^.x, point^.y-1, stack) then
    begin
      new(p);
      p^.x:=point^.x;
      p^.y:=point^.y-1;
      push(p, stack);
    end;
    if isNotExistColor(point^.x+1, point^.y) and isNotExistPoint(point^.x+1, point^.y, stack) then
    begin
      new(p);
      p^.x:=point^.x+1;
      p^.y:=point^.y;
      push(p, stack);
    end;
    if isNotExistColor(point^.x, point^.y+1) and isNotExistPoint(point^.x, point^.y+1, stack) then
    begin
      new(p);
      p^.x:=point^.x;
      p^.y:=point^.y+1;
      push(p, stack);
    end;
    
    if isNotExistColor(point^.x+1, point^.y+1) and isNotExistPoint(point^.x+1, point^.y+1, stack) then
    begin
      new(p);
      p^.x:=point^.x+1;
      p^.y:=point^.y+1;
      push(p, stack);
    end;
    if isNotExistColor(point^.x-1, point^.y+1) and isNotExistPoint(point^.x-1, point^.y+1, stack) then
    begin
      new(p);
      p^.x:=point^.x-1;
      p^.y:=point^.y+1;
      push(p, stack);
    end;
    if isNotExistColor(point^.x-1, point^.y-1) and isNotExistPoint(point^.x-1, point^.y-1, stack) then
    begin
      new(p);
      p^.x:=point^.x-1;
      p^.y:=point^.y-1;
      push(p, stack);
    end;
    if isNotExistColor(point^.x+1, point^.y-1) and isNotExistPoint(point^.x+1, point^.y-1, stack) then
    begin
      new(p);
      p^.x:=point^.x+1;
      p^.y:=point^.y-1;
      push(p, stack);
    end;
  end;
end;

var O:pPoint;//Центр окружности
begin
new(O);
O^.x:=random(130,450);
O^.y:=random(130, 200);
createRandomPolygon(O);
paintingOver(O);
end.