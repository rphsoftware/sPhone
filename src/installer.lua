

if not pocket or not term.isColor() then
  print("sPhone is only for Advanced Pocket Computers!")
  return
end

local old = os.pullEvent
os.pullEvent = os.pullEventRaw

if fs.exists("/startup") then
	fs.delete("/startup")
end

local license = [[
The MIT License (MIT)
Copyright (c) 2016 BeaconNet

Read full license here:
https://raw.github.com/BeaconNet/sPhone/master/LICENSE]]

local files = {
	["src/init.lua"] = "/.sPhone/init",
	["src/sPhone.lua"] = "/.sPhone/sPhone",
	
	["install"] = "/.sPhone/update",
	
	["LICENSE"] = "/.sPhone/LICENSE",
	
	["src/apis/sha256.lua"] = "/.sPhone/apis/sha256",
	["src/apis/visum.lua"] = "/.sPhone/apis/visum",
	["src/apis/graphics.lua"] = "/.sPhone/apis/graphics",
	["src/apis/ui.lua"] = "/.sPhone/apis/ui",
	["src/apis/base64.lua"] = "/.sPhone/apis/base64",
	["src/apis/config.lua"] = "/.sPhone/apis/config",
	["src/apis/shttp.lua"] = "/.sPhone/apis/shttp",
	["src/apis/compress.lua"] = "/.sPhone/apis/compress",
	["src/apis/task.lua"] = "/.sPhone/apis/task",
	["src/apis/proc.lua"] = "/.sPhone/apis/proc",
	
	["src/bin/wget.lua"] = "/bin/wget",
	["src/bin/halt.lua"] = "/bin/halt",
	["src/bin/echo.lua"] = "/bin/echo",
	
	["src/apps/system/settings.lua"] = "/.sPhone/apps/system/settings",
	["src/apps/system/info.lua"] = "/.sPhone/apps/system/info",
	["src/apps/themes.lua"] = "/.sPhone/apps/themes",
	["src/apps/kstwallet.lua"] = "/.sPhone/apps/kstwallet",
	["src/apps/store.lua"] = "/.sPhone/apps/store",
	["src/apps/shell.lua"] = "/.sPhone/apps/shell",
	["src/apps/appList.lua"] = "/.sPhone/apps/appList",
	["src/apps/home.lua"] = "/.sPhone/apps/home",
	["src/apps/chat.lua"] = "/.sPhone/apps/chat",
	
	["src/apps/gps.lua"] = "/.sPhone/apps/gps",
	
	["src/interfaces/login"] = "/.sPhone/interfaces/login",
	["src/interfaces/bootImage"] = "/.sPhone/interfaces/bootImage",
	
	["src/startup"] = "/startup",
	["src/startup"] = "/.sPhone/startup",
}

local githubUser    = "BeaconNet"
local githubRepo    = "sPhone"
local githubBranch  = "master"

local w, h = term.getSize()


local function clear()
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1, 1)
  term.setTextColor(colors.black)
end

local function gui()
	clear()
	paintutils.drawLine(1,1,w,1,colors.blue)
	term.setTextColor(colors.white)
	term.setCursorPos(2,1)
	print("sPhone Installer")
	term.setCursorPos(1,2)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
end

local function center(text, y)
  local w, h = term.getSize()
  if not y then
  	local x, y = term.getCursorPos()
  end
  term.setCursorPos(math.ceil(w/2)-math.ceil(#text/2), y)
  write(text)
end

local function httpGet(url, save)
	if not url then
		error("not enough arguments, expected 1 or 2", 2)
	end
	local remote = http.get(url)
	if not remote then
		return false
	end
	local text = remote.readAll()
	remote.close()
	if save then
		local file = fs.open(save, "w")
		file.write(text)
		file.close()
		return true
	end
	return text
end

local function get(user, repo, bran, path, save)
	if not user or not repo or not bran or not path then
		error("not enough arguments, expected 4 or 5", 2)
	end
    local url = "https://raw.github.com/"..user.."/"..repo.."/"..bran.."/"..path
	local remote = http.get(url)
	if not remote then
		return false
	end
	local text = remote.readAll()
	remote.close()
	if save then
		local file = fs.open(save, "w")
		file.write(text)
		file.close()
		return true
	end
	return text
end

local function getFile(file, target)
	return get(githubUser, githubRepo, githubBranch, file, target)
end

shell.setDir("")

gui()

local fileCount = 0
for _ in pairs(files) do
	fileCount = fileCount + 1
end
local filesDownloaded = 0

local w, h = term.getSize()

term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
term.clear()
term.setCursorPos(1,1)
gui()
term.setCursorPos(2,3)
print("License\n")
printError("You must accept the license to install sPhone\n")
print(license)

paintutils.drawFilledBox(2,17,9,19,colors.lime)
term.setCursorPos(3,18)
term.setTextColor(colors.white)
print("Accept")

paintutils.drawFilledBox(18,17,25,19,colors.red)
term.setCursorPos(20,18)
term.setTextColor(colors.white)
print("Deny")

while true do
	local e = {os.pullEvent()}
	if e[1] == "mouse_click" then
		local x,y = e[3],e[4]
		if (x >= 2 and y >= 17 ) and (x <= 9 and y <= 19 ) then
			break
		elseif (x >= 18 and y >= 17) and (x <= 25 and y <= 19) then
			os.pullEvent = old
			return
		end
	elseif e[1] == "terminate" then
		os.pullEvent = old
		print("Terminated")
		return
	end
end

for k, v in pairs(files) do
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	gui()
	center("  Downloading files",6)
	term.setCursorPos(1,12)
	term.clearLine()
	center("  "..filesDownloaded.."/"..fileCount, 12)
	local ok = k:sub(1, 4) == "ext:" and httpGet(k:sub(5), v) or getFile(k, v)
	if not ok then
		if term.isColor() then
			term.setTextColor(colors.red)
		end
		term.setCursorPos(2, 16)
		print("Error getting file:")
		term.setCursorPos(2, 17)
		print(k)
		sleep(1.5)
	end
	filesDownloaded = filesDownloaded + 1
end
term.setCursorPos(1,12)
term.clearLine()
center("  "..filesDownloaded.."/"..fileCount, 12)

if not fs.exists("/startup") then
	fs.copy("/.sPhone/startup","/startup")
end
center("  sPhone installed!",h-2)
center("  Rebooting...",h-1)
sleep(2)
os.reboot()
