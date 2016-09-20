os.pullEvent = os.pullEventRaw

if not pocket or not term.isColor() then
  print("sPhone is only for Advanced Pocket Computers!")
  return
end

if fs.exists("/startup") then
	fs.delete("/startup")
end

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
	
	["src/bin/wget.lua"] = "/bin/wget",
	["src/bin/halt.lua"] = "/bin/halt",
	["src/bin/echo.lua"] = "/bin/echo",
	
	["src/apps/system/settings.lua"] = "/.sPhone/apps/system/settings",
	["src/apps/system/info.lua"] = "/.sPhone/apps/system/info",
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
local githubBranch  = "dev"


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

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)

print("sPhone Developing Installer")
for k, v in pairs(files) do
	print(v)
	local ok = k:sub(1, 4) == "ext:" and httpGet(k:sub(5), v) or getFile(k, v)
	if not ok then
		if term.isColor() then
			term.setTextColor(colors.red)
		end
		print("Error getting file:")
		print(k)
		term.setTextColor(colors.white)
		sleep(1.5)
	end
end

if not fs.exists("/startup") then
	fs.copy("/.sPhone/startup","/startup")
end
print("sPhone installed!")
print("Reboot needed")
