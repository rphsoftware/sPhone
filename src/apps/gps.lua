term.setBackgroundColor(colors.white)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.black)
print("Loading...")
while true do
  term.clear()
  x, y, z = gps.locate(0)
  term.setCursorPos(1,3)
  if not x then
    x, y, z = "?", "?", "?"
  end
  print(" X: "..x)
  print(" Y: "..y)
  print(" Z: "..z)
  sleep(1)
end
