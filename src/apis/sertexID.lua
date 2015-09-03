--[[
  Sertex ID API - Made by Ale2610
  PHP by Luca_S
]]--

local SERVER = "http://sertex.esy.es/"

function status()
  local isUp = http.get(SERVER.."status.php").readAll()
  if isUp == "true" then
    return true
  else
    return false
  end
end

function login(username, password)
  local login = http.post(SERVER.."login.php", "user="..username.."&password="..password).readAll()
  if login == "true" then
    return true
  else
    return false
  end
end
