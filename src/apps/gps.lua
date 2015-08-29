local x, y, z = gps.locate(0)
if not x then
  x, y, z = "?", "?", "?"
end
sPhone.winOk("X Y Z", x.." "..y.." "..z)
