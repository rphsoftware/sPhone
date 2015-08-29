if not sPhone then
	print("This app is for sPhone")
	return
end

local function clear()
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
end

local function header()
	clear()
	local w, h = term.getSize()
	paintutils.drawLine(1,1,w,1, colors.gray)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	term.setCursorPos(w,1)
	write("X")
	term.setCursorPos(1,2)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
end

clear()
print("Checking Server...")
isDown = http.get("http://sertex.esy.es/status.php").readAll()
if isDown ~= "true" then
	sPhone.winOk("The server is down", "Retry later")
	return
end

header()
