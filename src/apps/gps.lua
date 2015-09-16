local x, y, z = gps.locate(0)
if not x then
  x, y, z = "?", "?", "?"
end
sPhone.winOk("X Y Z", math.ceil(x).." "..math.ceil(y).." "..math.ceil(z))
