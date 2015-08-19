os.loadAPI("/.sPhone/apps/cst/api")
--[[

 CrystalCoin Wallet (KST)
 
--]]
local function drawCryst(x,y)
  term.setCursorPos(x,y)
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.lightBlue)
  write("/")
  term.setCursorPos(x + 1,y)
  term.setBackgroundColor(colors.lightBlue)
  term.setTextColor(colors.blue)
  write("\\")
  term.setCursorPos(x,y + 1)
  write("\\")
  term.setCursorPos(x + 1,y + 1)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.lightBlue)
  write("/")
end

local function center(str,yLvl)
  x, y = term.getSize()
  x = x / 2
  x = x - ( #str / 2 )
  term.setCursorPos(x,yLvl)
  write(str)
end

hash = sha256.sha256

term.setBackgroundColor(colors.white)
term.clear()
drawCryst(2,2)
term.setCursorPos(2,5)
term.setBackgroundColor(colors.white)
term.setTextColor(colors.blue)
write("Username: ")
term.setTextColor(colors.lightBlue)
username = read()
term.setCursorPos(2,6)
term.setTextColor(colors.blue)
write("Password: ")
term.setTextColor(colors.lightBlue)
password = hash(read("*"))
term.setBackgroundColor(colors.white)
term.clear()
x, y = term.getSize()
drawCryst(x / 2,y / 2)
sleep(0.8)
term.setCursorPos(2,2)
term.setBackgroundColor(colors.lightGray)
x, y = term.getSize()
x = x - 2
for i=1,x do
  write(" ")
end
if api.login(username,password) then
  term.setTextColor(colors.lime)
  center("Logged In Successfully.",2)
else
  createUser = api.create(username,password)
  if createUser == true then
    term.setTextColor(colors.lime)
    center("Created User",2)
  else
    term.setTextColor(colors.red)
    center("Already Taken / Wrong Password",2)
    sleep(2)
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    password = nil
    return
  end
end
sleep(2)
while true do
  term.setBackgroundColor(colors.white)
  term.clear()
  x, y = term.getSize()
  x = x - 2
  drawCryst(x,2)
  term.setCursorPos(2,2)
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.blue)
  write("Balance: ")
  term.setTextColor(colors.lightBlue)
  bal = api.getBalance(username)
  write(bal.."CST")
  term.setCursorPos(2,4)
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.gray)
  write("  Exit  ")
  term.setCursorPos(2,6)
  write("Transfer")
  term.setCursorPos(2,8)
  write(" Lookup ")
  term.setCursorPos(2,10)
  write("Password")
  term.setCursorPos(2,12)
  term.setBackgroundColor(colors.red)
  write(" Delete ")
  e, c, x, y = os.pullEvent("mouse_click")
  if x > 1 and x < 10 and y == 4 then
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    password = nil
    return
  end
  if x > 1 and x < 10 and y == 6 then
    term.setBackgroundColor(colors.white)
    term.clear()
    x, y = term.getSize()
    x = x - 2
    drawCryst(x,2)
    term.setCursorPos(2,2)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.blue)
    write("Send To: ")
    term.setTextColor(colors.lightBlue)
    toUser = read()
    term.setCursorPos(2,3)
    term.setTextColor(colors.blue)
    write("Ammount: ")
    term.setTextColor(colors.lightBlue)
    ammount = tonumber(read())
    if ammount == nil then
      term.setCursorPos(2,5)
      term.setTextColor(colors.orange)
      write("Ammount not a number")
    else
      trans = api.transaction(username,password,toUser,ammount)
      if trans == "User doesn't exists!" then
        term.setTextColor(colors.red)
        term.setCursorPos(2,5)
        write("Username doesn't exist!")
      elseif trans == "Not enough CST" then
        term.setTextColor(colors.red)
        term.setCursorPos(2,5)
        write("Insufficent Funds")
      elseif trans == "Negative amount" then
        term.setTextColor(colors.red)
        term.setCursorPos(2,5)
        write("Negative Ammount!!!!")
      elseif username == toUser then
        term.setCursorPos(2,5)
        term.setTextColor(colors.red)
        write("Cannot give yourself money")
      else
        term.setTextColor(colors.lime)
        term.setCursorPos(2,5)
        write("Transfer Successful!")
      end
    end
    sleep(1.5)
  end
  if x > 1 and x < 10 and y == 8 then
    term.setBackgroundColor(colors.white)
    term.clear()
    x,y = term.getSize()
    x = x - 2
    drawCryst(x,2)
    term.setCursorPos(2,2)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.blue)
    write("Account: ")
    term.setTextColor(colors.lightBlue)
    acc = read()
    bal = api.getBalance(acc)
    if bal == "User doesn't exists!" then
      term.setCursorPos(2,4)
      term.setTextColor(colors.red)
      write("No such user")
      sleep(2)
    else
      term.setCursorPos(2,4)
      term.setTextColor(colors.blue)
      write(acc.." Has ")
      term.setTextColor(colors.lightBlue)
      write(bal.."CST")
      os.pullEvent("key")
    end
  end
  if x > 1 and x < 10 and y == 10 then
    term.setBackgroundColor(colors.white)
    term.clear()
    x, y = term.getSize()
    x = x - 2
    drawCryst(x,2)
    term.setCursorPos(2,2)
    term.setTextColor(colors.blue)
    term.setBackgroundColor(colors.white)
    write("Change Password")
    term.setCursorPos(2,4)
    write("Old Password: ")
    oldPW = hash(read("*"))
    if api.login(username,oldPW) then
      term.setCursorPos(2,5)
      term.setTextColor(colors.blue)
      write("New Password: ")
      newPW = hash(read("*"))
      api.newpass(username,password,newPW)
      term.setCursorPos(2,7)
      term.setTextColor(colors.lime)
      write("Changed Password.")
      sleep(2)
    else
      term.setCursorPos(2,6)
      term.setTextColor(colors.red)
      write("Incorrect Password")
      sleep(2)
    end
  end
  if x > 1 and x < 10 and y == 12 then
    term.setBackgroundColor(colors.white)
    term.clear()
    x, y = term.getSize()
    x = x - 2
    drawCryst(x,2)
    term.setCursorPos(2,2)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.red)
    write("Account Deletion")
    term.setCursorPos(2,4)
    term.setTextColor(colors.blue)
    write("Press [1] To Delete")
    term.setCursorPos(2,5)
    write("Press [2] To Go Back")
    e, k = os.pullEvent("key")
    sleep(0.5)
    if k == 2 then
      term.setCursorPos(2,6)
      write("Username: ")
      term.setTextColor(colors.lightBlue)
      delUser = read()
      term.setTextColor(colors.blue)
      term.setCursorPos(2,7)
      write("Password: ")
      term.setTextColor(colors.lightBlue)
      delPass = hash(read("*"))
      if api.login(username,delPass) then
        api.delete(username,delPass)
        term.setBackgroundColor(colors.black)
        term.clear()
        term.setCursorPos(1,1)
        return
      else
        term.setTextColor(colors.red)
        term.setCursorPos(2,9)
        write("Incorrect Password")
      end
    end
  end
end