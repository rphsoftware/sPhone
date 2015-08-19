function login(name,pass)
  local stream = http.get("http://crystalcoins.site88.net/user.php?action=login&user="..name.."&pass="..pass)
  local erg = stream.readAll()
  stream.close()
  if erg == "true" then
    return true
  else
    return false
  end
end

function create(name,pass)
  local stream = http.get("http://crystalcoins.site88.net/user.php?action=create&user="..name.."&pass="..pass)
  local erg = stream.readAll()
  stream.close()
  if erg == "Success!" then
    return true
  else
    return false
  end
end

function newpass(name,oldpass,newpass)
  local stream = http.get("http://crystalcoins.site88.net/user.php?action=newpass&user="..name.."&oldpass="..oldpass.."&pass="..newpass)
  local erg = stream.readAll()
  stream.close()
  return erg
end

function delete(name,pass)
  local stream = http.get("http://crystalcoins.site88.net/user.php?action=delete&user="..name.."&pass="..pass)
  local erg = stream.readAll()
  stream.close()
  return erg
end

function getBalance(name)
  local stream = http.get("http://crystalcoins.site88.net/user.php?action=getBalance&user="..name)
  local erg = stream.readAll()
  stream.close()
  return erg
end

function transaction(user,pass,to,amt)
  local stream = http.get("http://crystalcoins.site88.net/user.php?action=transaction&user="..user.."&pass="..pass.."&to="..to.."&amt="..amt)
  local erg = stream.readAll()
  stream.close()
  return erg
end