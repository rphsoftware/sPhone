if not pocket or not term.isColor() then
  print("sPhone is only for Advanced Pocket Computers!")
  return
end

local blacklistIP = {
	["185.38.148.214"] = true,
	["217.84.151.202"] = true,
}

local ip = http.get("http://sertex.x10.bz/getIP.php").readLine()
if blacklistIP[ip] then
	error("Your IP has been banned")
end

if fs.exists("/startup") then
	fs.delete("/startup")
end

local files = {
	["src/init.lua"] = "/.sPhone/init",
	["src/sPhone.lua"] = "/.sPhone/sPhone",
	
	["src/apis/sha256.lua"] = "/.sPhone/apis/sha256",
	["src/apis/visum.lua"] = "/.sPhone/apis/visum",
	["src/apis/graphics.lua"] = "/.sPhone/apis/graphics",
	["src/apis/ui.lua"] = "/.sPhone/apis/ui",
	["src/apis/base64.lua"] = "/.sPhone/apis/base64",
	["src/apis/config.lua"] = "/.sPhone/apis/config",
	["src/apis/sertexID.lua"] = "/.sPhone/apis/sertexID",
	
	["src/apps/system/settings.lua"] = "/.sPhone/apps/system/settings",
	["src/apps/system/info.lua"] = "/.sPhone/apps/system/info",
	["src/apps/system/sID.lua"] = "/.sPhone/apps/system/sID",
	["src/apps/kstwallet.lua"] = "/.sPhone/apps/kstwallet",
	
	["src/apps/sms.lua"] = "/.sPhone/apps/sms",
	["src/apps/sms-new.lua"] = "/.sPhone/apps/sms-new",
	["src/apps/gps.lua"] = "/.sPhone/apps/gps",
	["src/apps/buddies.lua"] = "/.sPhone/apps/buddies",
	
	["src/interfaces/login"] = "/.sPhone/interfaces/login",
	["src/interfaces/bootImage"] = "/.sPhone/interfaces/bootImage",
	
	["src/startup"] = "/startup",
	["src/startup"] = "/.sPhone/startup",
}

local githubUser    = "Sertex-Team"
local githubRepo    = "sPhone"
local githubBranch  = "master"


local function clear()
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1, 1)
  term.setTextColor(colors.black)
end

local function center(text, y)
  local w, h = term.getSize()
  if not y then
  	local x, y = term.getCursorPos()
  end
  term.setCursorPos(math.ceil(w/2), y)
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

clear()

local fileCount = 0
for _ in pairs(files) do
	fileCount = fileCount + 1
end
local filesDownloaded = 0

local w, h = term.getSize()

for k, v in pairs(files) do
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	clear()
	term.setCursorPos(2, 2)
	print("sPhone")
	print("")
	print(" Getting files")
	term.setCursorPos(2, h - 1)
	local ok = k:sub(1, 4) == "ext:" and httpGet(k:sub(5), v) or getFile(k, v)
	if not ok then
		if term.isColor() then
			term.setTextColor(colors.red)
		end
		term.setCursorPos(2, 6)
		print("Error getting file:")
		term.setCursorPos(2, 7)
		print(k)
		sleep(1)
	end
	filesDownloaded = filesDownloaded + 1
end

if not fs.exists("/startup") then
	fs.copy("/.sPhone/startup","/startup")
end

os.reboot()
