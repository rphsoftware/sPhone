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

function login(username, password, isHashed)
  local login = http.post(SERVER.."login.php", "user="..username.."&password="..password if isHashed then .."hashed=true" end).readAll()
  if login == "true" then
    return true
  else
    return false
  end
end

function register(username, password, isHashed)
  local register = http.post(SERVER.."register.php", "user="..username.."&password="..password if isHashed then .."hashed=true" end).readAll()
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

function sendSMS(username, password, to, msg, isHashed)
  local send = http.post(SERVER.."send.php","user="..username.."&password="..password.."&to="..to.."&message="..message if isHashed then .."hashed=true" end).readAll()
  if send == "true" then
    return true
  else
    return false,send
  end
end

function updateSMS(username, password, all, from, isHashed)
  local update = http.post(SERVER.."update.php","user="..username.."&password="..password if isHashed then .."hashed=true" end).readAll()
  if update then
    return true, update
  else
    return false
  end
end
