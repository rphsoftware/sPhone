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

header()

if fs.exists("/.sPhone/config/.sIDpw") then
	sPhone.winOk("Sertex ID", "Already Set!")
	return
end
while true do
	header()

	term.setCursorPos(1,4)
	print(" Set Sertex ID")
	write(" Username: ")
	local name = read()
	local nExists = http.post("http://sertex.esy.es/exists.php", "user="..name).readAll()
	--later
end
