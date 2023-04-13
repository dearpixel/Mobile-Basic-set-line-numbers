type
  Point = record
    a,b: integer;
  end;
var
  source: array of string;
  ///Метка
  ///Первая цифра - строка, вторая цифра - номер метки
  Points: array of Point;
  ///Ссылка на метку
  ///Первая цифра - строка, вторая цифра - номер метки
  Links: array of Point;
function GetPoint(str: string; line: integer): string;
var pos := 0;
    GPres: string;
begin
  while not GPres.Contains('Point') do
  begin
    pos := str.IndexOf('P',pos);
    if str[pos+5] = 't' then
    begin
      GPres := 'Point';
      pos += 6;
      while (str[pos].IsDigit) and (pos < str.Length) do
      begin
        GPres += str[pos];
        pos += 1;
      end;
    end;
    pos += 1;
  end;
  Result := str;
  if str = GPres+':' then
  begin
    SetLength(Points,Points.Length+1);
    Points[Points.Length-1].a := line;
    Points[Points.Length-1].b := GPres.Remove(0,5).ToInteger();
    Result := '';
  end
  else
  begin
    SetLength(Links,Links.Length+1);
    Links[Links.Length-1].a := line;
  end;
end;
function ReplacePoint(str: string; line: integer): string;
var Point := GetPoint(str,line);
begin
  Result := Point;
end;
begin
  SetLength(Points,0);
  SetLength(Links,0);
  source := ReadAllLines('orig.txt');
  for i: integer := 0 to source.Length-1 do
  begin
    if source[i].Contains('Point') then
      source[i] := GetPoint(source[i],i+1);
    source[i] := (i+1).ToString()+' '+source[i];
  end;
  println('Points:');
  foreach pn: Point in Points do
    println(pn.a+' , '+pn.b);
  println('links:');
  foreach pn: Point in Links do
  begin
    println(pn.a+' , '+pn.b);
    for i: integer := 0 to Points.Length-1 do
    begin
      if source[pn.a-1].Contains('Point'+Points[i].b.ToString()) then
        source[pn.a-1] := source[pn.a-1].Replace('Point'+Points[i].b.ToString(),(Points[i].a+1).ToString());
    end;
  end;
  println('РЕЗУЛЬТАТ:');
  foreach line_: Point in Links do
    println(source[line_.a-1]);
  WriteAllLines('res.txt',source);
end.