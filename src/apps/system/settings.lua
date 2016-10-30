local pwChange
local pwChangeRep

local menu = {
	"Update",
	"Edit Theme",
	"Change Username",
	"Change Password",
	"Set Label",
	"Clear Label",
	"Default Apps",
}

local function clear()
	term.setBackgroundColor(sPhone.theme["backgroundColor"])
	term.setTextColor(sPhone.theme["text"])
	term.clear()
	term.setCursorPos(1,1)
end

local function changeUsername()
	term.setBackgroundColor(sPhone.theme["backgroundColor"])
	term.clear()
	term.setCursorPos(1,1)
	sPhone.header(sPhone.user)
	term.setTextColor(sPhone.theme["text"])
	visum.align("center","  New Username",false,3)
	term.setCursorPos(2,5)
	write("Username: ")
	local newUsername = read()
	sPhone.user = newUsername
	f = fs.open("/.sPhone/config/username","w")
	f.write(sPhone.user)
	f.close()
	sPhone.winOk("Username","Changed")
end

local function changePassword()
	while true do
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.clear()
		term.setCursorPos(1,1)
		sPhone.header(sPhone.user)
		paintutils.drawBox(7,9,20,11,sPhone.theme["window.background"])
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		if sPhone.wrongPassword then
			term.setTextColor(colors.red)
			term.setBackgroundColor(sPhone.theme["backgroundColor"])
			visum.align("center","  Wrong Password",false,13)
		end
		term.setTextColor(sPhone.theme["text"])
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		visum.align("center","  Current Password",false,7)
		local loginTerm = window.create(term.native(), 8,10,12,1, true)
		term.redirect(loginTerm)
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(sPhone.theme["text"])
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
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.clear()
		term.setCursorPos(1,1)
		sPhone.header(sPhone.user)
		paintutils.drawBox(7,9,20,11,sPhone.theme["window.background"])
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		if sPhone.wrongPassword then
			term.setTextColor(colors.red)
			term.setBackgroundColor(sPhone.theme["backgroundColor"])
			visum.align("center","  Wrong Password",false,13)
		end
		term.setTextColor(sPhone.theme["text"])
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		visum.align("center","  New Password",false,7)
		local loginTerm = window.create(term.native(), 8,10,12,1, true)
		term.redirect(loginTerm)
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(sPhone.theme["text"])
		pwChange = read("*")
		term.redirect(sPhone.mainTerm)

		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.clear()
		term.setCursorPos(1,1)
		sPhone.header(sPhone.user)
		paintutils.drawBox(7,9,20,11,sPhone.theme["window.background"])
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.setTextColor(sPhone.theme["text"])
		visum.align("center","  Repeat Password",false,7)
		local loginTerm = window.create(term.native(), 8,10,12,1, true)
		term.redirect(loginTerm)
		term.setBackgroundColor(sPhone.theme["backgroundColor"])
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(sPhone.theme["text"])
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
	sPhone.header(sPhone.user)
	visum.align("center", "All Set!", false, 3)
	sleep(2)
	return
end

local function changeLabel()
	sPhone.header(sPhone.user)
	visum.align("center", "  Set Label",false,3)
	term.setCursorPos(2,5)
	local newLabel = read()
	newLabel = newLabel:gsub("&", string.char(0xc2)..string.char(0xa7)) --yay colors
	os.setComputerLabel(newLabel)
	sPhone.winOk("Computer Label set")
end

local function clearLabel()
	os.setComputerLabel(nil)
	sPhone.winOk("Computer Label cleared")
end

local function editTheme()
	local themeOptions = {
		"Header Color",
		"Header Text Color",
		"Text Color",
		"Background Color",
		"Window Options",
		"Save",
		"Load",
		"Reset",
	}
	local themeOptionsWindow = {
		"Background",
		"Side",
		"Button",
		"Text",
	}
	while true do
		local _, id = sPhone.menu(themeOptions,"Theme","X")
		if id == 0 then
			return
		elseif id == 1 then
			sPhone.applyTheme("header", sPhone.colorPicker("Header",sPhone.getTheme("header")))
		elseif id == 2 then
			sPhone.applyTheme("headerText", sPhone.colorPicker("Header Text",sPhone.getTheme("headerText")))
		elseif id == 3 then
			sPhone.applyTheme("text", sPhone.colorPicker("Text",sPhone.getTheme("text")))
		elseif id == 4 then
			sPhone.applyTheme("backgroundColor", sPhone.colorPicker("Background Color",sPhone.getTheme("backgroundColor")))
		elseif id == 5 then
			while true do
				local _, id = sPhone.menu(themeOptionsWindow,"Window Theme","X")
				if id == 0 then
					return
				elseif id == 1 then
					sPhone.applyTheme("window.background", sPhone.colorPicker("Background",sPhone.getTheme("window.background")))
				elseif id == 2 then
					sPhone.applyTheme("window.side", sPhone.colorPicker("Side",sPhone.getTheme("window.side")))
				elseif id == 3 then
					sPhone.applyTheme("window.button", sPhone.colorPicker("Button",sPhone.getTheme("window.button")))
				elseif id == 4 then
					sPhone.applyTheme("window.text", sPhone.colorPicker("Text",sPhone.getTheme("window.text")))
				end
			end
		elseif id == 6 then
			sPhone.header()
			visum.align("center", "Save Theme",false,3)
			term.setCursorPos(2,5)
			local saveTheme = read()
			if fs.exists(saveTheme) then
				fs.delete(saveTheme)
			end
			fs.copy("/.sPhone/config/theme", saveTheme)
			sPhone.winOk("Theme saved!")
		elseif id == 7 then
			local loadTheme = sPhone.list()
			if loadTheme then
				if fs.exists(loadTheme) and not fs.isDir(loadTheme) then
					for k, v in pairs(sPhone.theme) do -- Load theme
						sPhone.theme[k] = config.read(loadTheme, k)
					end
					for k, v in pairs(sPhone.theme) do -- Overwrite theme config
						config.write("/.sPhone/config/theme", k, v)
					end
					sPhone.winOk("Theme loaded!")
				else
					sPhone.winOk("Theme not found!")
				end
			end
		elseif id == 8 then
			fs.delete("/.sPhone/config/theme")
			sPhone.theme = sPhone.defaultTheme
			sPhone.winOk("Removed Theme")
		end
	end
end

local function defaultApps()
	local defaultMenu = {
		"Home",
	}
	local name, id = sPhone.menu(defaultMenu,"Default Apps","X")
	
	if id == 0 then
		return
	elseif id == 1 then
		
		while true do
			local defaultHome = sPhone.list()
			
			if not defaultHome then
				sPhone.setDefaultApp("home","/.sPhone/apps/home")
				sPhone.winOk("Done!","Reboot to apply")
				break
			else
				if fs.exists("/"..defaultHome) and not fs.isDir("/"..defaultHome) then
					sPhone.setDefaultApp("home","/"..defaultHome)
					sPhone.winOk("Done!","Reboot to apply")
					break
				else
					sPhone.winOk("App not found")
				end
			end
		end
	end
end

while true do
	clear()
	sPhone.header("","X")
	local name, id = sPhone.menu(menu, "Settings","X")
	if id == 0 then
		return
	elseif id == 1 then
		setfenv(loadstring(http.get("https://raw.githubusercontent.com/BeaconNet/sPhone/master/src/installer.lua").readAll()),getfenv())()
	elseif id == 2 then
		editTheme()
	elseif id == 3 then
		changeUsername()
	elseif id == 4 then
		changePassword()
	elseif id == 5 then
		changeLabel()
	elseif id == 6 then
		clearLabel()
	elseif id == 7 then
		defaultApps()
	end
end
