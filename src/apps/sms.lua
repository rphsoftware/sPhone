local tArgs = {...}
local loading = {"|","/","-","\\","|","/","-","\\"}
local server = "http://sertex.esy.es/"
local sendTo

--check if the server is down
local isServerUp = http.get(server.."/status.php").readAll()
if isServerUp ~= "true" then
	sPhone.winOk("The service is","currently down!", colors.lime, colors.green, colors.white, colors.lime)
	return
end
term.setBackgroundColor(colors.white)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.black)
print("sPhone SMS")
if not fs.exists("/.sPhone/config/.sIDpw") then
	sPhone.winOk("Sertex ID not set!","Run sID!", colors.lime, colors.green, colors.white, colors.lime)
	return
end
f = fs.open("/.sPhone/config/username", "r")
local user = f.readLine()
f.close()
f = fs.open("/.sPhone/config/.sIDpw", "r")
local pass = f.readLine()
f.close()
local head = "user="..user.."&password="..pass
http.request(server.."login.php",head)
local update = os.startTimer(0.15)
local pos = 1
while true do
  local _,y = term.getCursorPos()
  term.clearLine()
  term.setCursorPos(1,y)
  term.write("Loading "..loading[pos])
  local e = {os.pullEvent()}
  if e[1] == "timer" and e[2] == update then
    pos = pos + 1
    if pos > #loading then pos = 1 end
    update = os.startTimer(0.15)
  elseif e[1] == "http_success" then
    if e[3].readAll() == "true" then
			if not tArgs[1] then
				term.clearLine()
				term.setCursorPos(1,y)
				write("Send To: ")
				sendTo = read()
			else
				sendTo = tArgs[1]
			end
			local doesUserExist = http.post(server.."exists.php", "user="..sendTo).readAll()
			if doesUserExist ~= "true" then
				sPhone.winOk(sendTo.." does","not exist!", colors.lime, colors.green, colors.white, colors.lime)
				return
			end
      break
    else
      sPhone.winOk("Wrong Username","or Password", colors.lime, colors.green, colors.white, colors.lime)
      return
    end
  elseif e[1] == "http_failure" then
    term.clearLine()
    term.setCursorPos(1,y)
    sPhone.winOk("Connection lost!","Check internet!", colors.lime, colors.green, colors.white, colors.lime)
    return
  end
end
term.clear()
local x,y = term.getSize()
local mainTerm = term.current()
local displayWin = window.create(term.native(),1,1,x,y-1,true)
local readWin = window.create(term.native(),1,y,x,y,true)
local ntv = term.redirect(mainTerm)
local x,y = 1,1
local mx,my = displayWin.getSize()
local function readMsg()
	term.redirect(readWin)
  while true do
		term.setCursorBlink(true)
		term.setBackgroundColor(colors.green)
		term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1,1)
    term.write("Send: ")
    local msg = read()
    term.clear()
		if msg == "/logout" then
			term.redirect(mainTerm)
			return
		end
		if msg ~= "" then
			local pos = 1
			local update = os.startTimer(0.15)
			http.request(server.."send.php","user="..user.."&password="..pass.."&message="..msg.."&to="..sendTo)
			while true do
				term.clear()
				term.setCursorPos(1,1)
				term.write("Sending "..loading[pos])
				e = {os.pullEvent()}
				if e[1] == "timer" and e[2] == update then
					update = os.startTimer(0.15)
					pos = pos + 1
					if pos > #loading then pos = 1 end
				elseif e[1] == "http_success" then
					displayWin.setCursorPos(1,y)
					displayWin.write("<You> "..msg)
					if y == my then displayWin.scroll(1) else y = y +1 end
					break
				elseif e[1] == "http_failure" then
					term.redirect(ntv)
					term.clear()
					term.setCursorPos(1,1)
					sPhone.winOk("Disconnected",nil, colors.lime, colors.green, colors.white, colors.lime)
					return
				end
			end
    end
  end
end
local function recMsg()
	displayWin.setBackgroundColor(colors.white)
	displayWin.setTextColor(colors.black)
  displayWin.clear()
  local function printMsg(msg)
		displayWin.setCursorBlink(false)
    displayWin.setCursorPos(1,y)
    displayWin.write(msg)
    if y == my then displayWin.scroll(1) else y = y + 1 end
  end
	printMsg("Type /logout to exit")
  while true do
    stream = http.post(server.."update.php",head)
    newMessages = {}
    line = stream.readLine()
    repeat
      table.insert(newMessages,line)
      line = stream.readLine()
    until not line
    for i,v in pairs(newMessages) do
      t = textutils.unserialize(v)
      if t then
        date = t["date"]
        mesg = "<"..t["from"].."> "..t["message"]
        printMsg(mesg)
      end
    end
  end
end
parallel.waitForAny(readMsg,recMsg)
