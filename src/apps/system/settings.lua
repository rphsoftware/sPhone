local menu = {
	"Update",
	"Change username",
	"Change password",
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
	paintutils.drawLine(1,1,w,1, colors.gray)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	term.setCursorPos(1,2)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
end

local function changeUsername()
	 header()
	 term.setCursorPos(2,3)
	 write("New Username: ")
	 local newUsername = read()
	 local f = fs.open("/.sPhone/config/username","w")
	 f.write(newUsername)
	 f.close()
	 sPhone.user = newUsername
	 print(" All Set!")
end

local function changePassword()
	while true do
	term.clear()
	term.setCursorPos(1,1)
	paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.gray)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	if sPhone.wrongPassword then
		term.setTextColor(colors.red)
		term.setBackgroundColor(colors.white)
		sertextext.center(13,"  Wrong Password")
	end
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	sertextext.center(7,"  Current Password")
	term.setTextColor(colors.black)
	term.setCursorBlink(true)
	term.setCursorPos(9,10)
	local _, k1 = os.pullEvent("char")
	write("*")
	term.setCursorPos(12,10)
	local _, k2 = os.pullEvent("char")
	write("*")
	term.setCursorPos(15,10)
	local _, k3 = os.pullEvent("char")
	write("*")
	term.setCursorPos(18,10)
	local _, k4 = os.pullEvent("char")
	write("*")
	term.setCursorBlink(false)
	local password = k1..k2..k3..k4
	local fpw = fs.open("/.sPhone/.password","r")
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
	term.setBackgroundColor(colors.gray)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	if sPhone.wrongPassword then
		term.setTextColor(colors.red)
		term.setBackgroundColor(colors.white)
		sertextext.center(13,"  Wrong Password")
	end
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	sertextext.center(7,"  New Password")
	term.setTextColor(colors.black)
	term.setCursorBlink(true)
	term.setCursorPos(9,10)
	local _, k1 = os.pullEvent("char")
	write("*")
	term.setCursorPos(12,10)
	local _, k2 = os.pullEvent("char")
	write("*")
	term.setCursorPos(15,10)
	local _, k3 = os.pullEvent("char")
	write("*")
	term.setCursorPos(18,10)
	local _, k4 = os.pullEvent("char")
	write("*")
	term.setCursorBlink(false)
	local pwChange = k1..k2..k3..k4

	term.clear()
	term.setCursorPos(1,1)
	paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.gray)
	term.setCursorPos(1,1)
	write(" "..sPhone.user)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	sertextext.center(7,"  Repeat Password")
	term.setTextColor(colors.black)
	term.setCursorBlink(true)
	term.setCursorPos(9,10)
	local _, r1 = os.pullEvent("char")
	write("*")
	term.setCursorPos(12,10)
	local _, r2 = os.pullEvent("char")
	write("*")
	term.setCursorPos(15,10)
	local _, r3 = os.pullEvent("char")
	write("*")
	term.setCursorPos(18,10)
	local _, r4 = os.pullEvent("char")
	write("*")
	term.setCursorBlink(false)
	pwChangeRep = r1..r2..r3..r4
	if sha256.sha256(pwChange) ~= sha256.sha256(pwChangeRep) then
		sPhone.wrongPassword = true
		
	else
		sPhone.wrongPassword = false
		break
	end
	end
	if not sPhone.wrongPassword then
		local f = fs.open("/.sPhone/.password","w")
		f.write(sha256.sha256(pwChangeRep))
		f.close()
	end
	header()
	term.setCursorPos(2,3)
	print("All Set!")
	sleep(2)
	return
end

local w, h = term.getSize()

local function redraw()
	clear()
	local w, h = term.getSize()
			paintutils.drawLine(1,1,w,1, colors.gray)
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
			local name, id = ui.menu(menu, "Settings",true)
			if id == 0 then
				return
			elseif id == 1 then
				setfenv(loadstring(http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/installer.lua").readAll()),getfenv())()
			elseif id == 2 then
				changeUsername()
			elseif id == 3 then
				changePassword()
			end
		end
