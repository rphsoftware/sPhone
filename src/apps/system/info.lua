local function clear()
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
end
clear()
sPhone.header("Info", "X")
print("")
print("ID: "..os.getComputerID())
print("User: "..sPhone.user)
if os.getComputerLabel() then
	print("Label: "..os.getComputerLabel())
end
print("sPhone "..sPhone.version.." by BeaconNet")
print("KST by 3d6")
print("UI by LMNetOS")
print("SHA256 by GravityScore")
print("And thanks to dan200 for this mod!")

while true do
  local w, h = term.getSize()
  local _, _, x, y = os.pullEvent("mouse_click")
  if y == 1 and x == w then
    return
  end
  sleep(0)
end
