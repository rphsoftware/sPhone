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

function register(username, password)
  local register = http.post(SERVER.."register.php", "user="..username.."&password="..password).readAll()
  if register == "Success!" then
    return true
  else
    return false, register
  end
end

function checkUser(username)
  local check = http.post(SERVER.."check.php", "user="..username).readAll()
  if check == "true" then
    return true
  else
    return false
  end
end

function sendSMS(username, password, to, msg)

end

function updateSMS(username, password, all, from)
  
end
