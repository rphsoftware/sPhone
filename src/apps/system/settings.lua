local pwChange
local pwChangeRep

local menu = {
	"Update",
	"Change Password",
	"Set Label",
	"Clear Label",
}

local function clear()
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
	term.clear()
	term.setCursorPos(1,1)
end

local function header()
	clear()
	local w, h = term.getSize()
	paintutils.drawLine(1,1,w,1, colors.blue)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	term.setCursorPos(1,2)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
end

local function changePassword()
	while true do
	term.clear()
	term.setCursorPos(1,1)
	paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.blue)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	if sPhone.wrongPassword then
		term.setTextColor(colors.red)
		term.setBackgroundColor(colors.white)
		visum.align("center","  Wrong Password",false,13)
	end
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	visum.align("center","  Current Password",false,7)
	local loginTerm = window.create(term.native(), 8,10,12,1, true)
  term.redirect(loginTerm)
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.black)
	local password = read("*")
  term.redirect(sPhone.mainTerm)
	local fpw = fs.open("/.sPhone/config/.password","r")
	if sha256.sha256(password) ~= fpw.readLine() then
		sPhone.wrongPassword = true
	else
		sPhone.wrongPassword = false
		fpw.close()
		break
	end
	end
	
	
	while true do
	term.clear()
	term.setCursorPos(1,1)
	paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.blue)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	if sPhone.wrongPassword then
		term.setTextColor(colors.red)
		term.setBackgroundColor(colors.white)
		visum.align("center","  Wrong Password",false,13)
	end
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	visum.align("center","  New Password",false,7)
	local loginTerm = window.create(term.native(), 8,10,12,1, true)
  term.redirect(loginTerm)
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.black)
	pwChange = read("*")
  term.redirect(sPhone.mainTerm)

	term.clear()
	term.setCursorPos(1,1)
	paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.blue)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	visum.align("center","  Repeat Password",false,7)
	local loginTerm = window.create(term.native(), 8,10,12,1, true)
  term.redirect(loginTerm)
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.black)
	pwChangeRep = read("*")
  term.redirect(sPhone.mainTerm)
	if sha256.sha256(pwChange) ~= sha256.sha256(pwChangeRep) then
		sPhone.wrongPassword = true
		
	else
		sPhone.wrongPassword = false
		break
	end
	end
	if not sPhone.wrongPassword then
		local f = fs.open("/.sPhone/config/.password","w")
		f.write(sha256.sha256(pwChangeRep))
		f.close()
	end
	header()
	term.setCursorPos(2,3)
	print("All Set!")
	sleep(2)
	return
end

local function changeLabel()
	header()
	visum.align("center", "Set Label",false,3)
	term.setCursorPos(2,5)
	local newLabel = read()
	os.setComputerLabel(newLabel)
	sPhone.winOk("Computer Label set")
end

local function clearLabel()
	os.setComputerLabel(nil)
	sPhone.winOk("Computer Label cleared")
end

local w, h = term.getSize()

local function redraw()
	clear()
	local w, h = term.getSize()
			paintutils.drawLine(1,1,w,1, colors.blue)
			term.setTextColor(colors.white)
			term.setCursorPos(2,1)
			write(sPhone.user)
			term.setCursorPos(w,1)
			write("X")
			term.setCursorPos(1,3)
			term.setBackgroundColor(colors.white)
			term.setTextColor(colors.black)
		end
		redraw()
		
		while true do
			redraw()
			local name, id = sPhone.menu(menu, "Settings",true)
			if id == 0 then
				return
			elseif id == 1 then
				setfenv(loadstring(http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/installer.lua").readAll()),getfenv())()
			elseif id == 2 then
				changePassword()
			elseif id == 3 then
				changeLabel()
			elseif id == 4 then
				clearLabel()
			end
		end
