local isDown
local menu
local id
local user
local pw
local pwr

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
	paintutils.drawLine(1,1,w,1, colors.blue)
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

local function login()
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	local w, h = term.getSize()
	paintutils.drawLine(1,1,w,1,colors.blue)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	sertextext.center(3,"  Setup Sertex ID")
	sertextext.center(7,"  Your Username")
	term.setCursorPos(3,8)
	name = read()
	sertextext.center(9, "  Your Password")
	term.setCursorPos(3,10)
	term.clearLine()
	pw = read("*")
	sertextext.center(11, "  Checking...")
	rServer = http.post("http://sertex.esy.es/login.php", "user="..name.."&password="..pw).readAll()
	if rServer ~= "true" then
		print("   Wrong Username/Password")
		sleep(2)
	else
		f = fs.open("/.sPhone/config/username", "w")
		f.write(name)
		f.close()
		f = fs.open("/.sPhone/config/.sIDpw", "w")
		f.write(base64.encode(pw))
		f.close()
		sPhone.name = name
	end
end

local function register()
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	local w, h = term.getSize()
	paintutils.drawLine(1,1,w,1,colors.blue)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	sertextext.center(3,"  Setup Sertex ID")
	sertextext.center(7,"  Your Username")
	term.setCursorPos(3,8)
	name = read()
	while true do
		sertextext.center(9, "  Your Password")
		term.setCursorPos(3,10)
		term.clearLine()
		pw = read("*")
		sertextext.center(11, "  Repeat")
		term.setCursorPos(3,12)
		term.clearLine()
		pwr = read("*")
		if pw == pwr then
			break
		else
			print("   Wrong Password")
			sleep(1)
			term.clearLine()
		end
	end
	local rServer = http.post("http://sertex.esy.es/register.php", "user="..name.."&password="..pw).readAll()
	if rServer ~= "Success!" then
		print("Username already exists")
		sleep(2)	
	else
		local f = fs.open("/.sPhone/config/username","w")
		f.write(name)
		f.close()
		local pwf = fs.open("/.sPhone/config/.sIDPw", "w")
		pwf.write(base64.encode(pw))
		pwf.close()
		sPhone.name = name
	end
end

while true do
	if fs.exists("/.sPhone/config/.sIDpw") then
		menu = {
			"Logout",
		}
		 _, id = sPhone.menu(menu, "Sertex ID", true)
		if id == 1 then
		 	fs.delete("/.sPhone/config/.sIDpw")
		elseif id == 0 then
			return
		end
	else
		menu = {
			"Login",
			"Register",
		}
		_, id = sPhone.menu(menu, "Sertex ID", true)
		if id == 1 then
			login()
		elseif id == 2 then
			register()
		elseif id == 0 then
			return
		end
	end
end

header()
