os.forceShutdown = os.shutdown

local function crash(err)
	if not sPhone then
		sPhone = {
			devMode = false,
		}
	end
	term.setCursorBlink(false)
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.black)
	if not err then
		err = "Undefined Error"
	end
	
	print("sPhone got an error :(\n")
	term.setTextColor(colors.red)
	print(err)
	term.setTextColor(colors.black)
	print("")
	if sPhone.version then
		print("sPhone "..sPhone.version)
	end
	print("Computer ID: "..os.getComputerID())
	print("Contact sPhone devs: GitHub: Sertex-Team/sPhone")
	print("Thanks for using sPhone")
	print("Press any key")
	repeat
		sleep(0)
	until os.pullEvent("key")
	if not sPhone.devMode then
		_G.term = nil
	end
	term.setBackgroundColor(colors.black)
	term.clear()
	term.setCursorPos(1,1)
	sleep(0.1)
	shell.run("/rom/programs/shell")
end

local function recovery()
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
	term.clear()
	term.setCursorPos(1,1)
	print("sPhone Recovery")
	print("1: Hard Reset")
	print("2: Update sPhone")
	print("3: Continue Booting")
	while true do
		local _, k = os.pullEvent("key")
		if k == 2 then
			term.setBackgroundColor(colors.black)
			term.setTextColor(colors.white)
			for k, v in pairs(fs.list("/")) do
				if not fs.isReadOnly(v) then
					if fs.isDir(v) then
						shell.setDir(v)
						for k, v in pairs(fs.list("/"..v)) do
							fs.delete(v)
							print("Removed "..shell.dir().."/"..v)
						end
						shell.setDir(shell.resolve(".."))
					end
					fs.delete(v)
					print("Removed "..v)
				end
			end
			print("Installing sPhone...")
			sleep(0.5)
			setfenv(loadstring(http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/installer.lua").readAll()),getfenv())()
		elseif k == 3 then
			setfenv(loadstring(http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/installer.lua").readAll()),getfenv())()
		elseif k == 4 then
			break
		end
	end
end

local function kernel()
	term.setBackgroundColor(colors.white)
	term.setCursorPos(1,1)
	term.clear()
	term.setTextColor(colors.black)
	if fs.exists("/.sPhone/interfaces/bootImage") then
		local bootImage = paintutils.loadImage("/.sPhone/interfaces/bootImage")
		paintutils.drawImage(bootImage, 11,7)
	else
		print("Missing bootImage")
	end
	local w, h = term.getSize()
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
	term.setCursorPos(1,h)
	write("Press ALT to recovery mode")
	local bootTimer = os.startTimer(1)
	while true do
		local e,k = os.pullEvent()
		if e == "key" and k == 56 then
			recovery()
			break
		elseif e == "timer" then
			break
		end
	end
	_G.sPhone = {
		version = "Alpha 2.9",
		user = "Run sID",
		devMode = false,
		mainTerm = term.current()
	}
	
	
	
	if not fs.exists("/.sPhone/config/newIDSystem") then
		fs.delete("/.sPhone/config/username")
		fs.delete("/.sPhone/config/.sIDpw")
		f = fs.open("/.sPhone/config/newIDSystem","w")
		f.write("Ignore Me. I just check if you use the new Sertex ID system to fix password issues")
		f.close()
	end
	
	if not fs.exists("/.sPhone/autorun") then
		fs.makeDir("/.sPhone/autorun")
	end
	
	term.setBackgroundColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	
	for k, v in pairs(fs.list("/.sPhone/autorun")) do
		term.setTextColor(colors.black)
		if not fs.isDir("/.sPhone/autorun/"..v) then
			local f = fs.open("/.sPhone/autorun/"..v,"r")
			local script = f.readAll()
			f.close()
			print("Loading script "..v)
			sleep(0)
			local ok, err = pcall(function() setfenv(loadstring(script),getfenv())() end)
			if not ok then
				term.setTextColor(colors.red)
				print("Script error: "..v..": "..err)
				fs.move("/.sPhone/autorun/"..v, "/.sPhone/autorun/disabled/"..v)
				term.setTextColor(colors.blue)
				print(v.." disabled to prevent errors")
				sleep(0.5)
			end
			
			
		end
	end
	
	if runningOnStartup then
		fs.open("/startup","r")
	end
	
	if fs.exists("/.sPhone/config/username") then
		local u = fs.open("/.sPhone/config/username","r")
		sPhone.user = u.readLine()
		u.close()
	end
	
	if not fs.exists("/.sPhone/apis") then
		fs.makeDir("/.sPhone/apis")
	end
	
	for k, v in pairs(fs.list("/.sPhone/apis")) do
		if not fs.isDir("/.sPhone/apis/"..v) then
			os.loadAPI("/.sPhone/apis/"..v)
		end
	end
	
	if not fs.exists("/.sPhone/config/sPhone") then
		config.write("/.sPhone/config/sPhone","devMode",false)
	end
	
	sPhone.devMode = config.read("/.sPhone/config/sPhone","devMode")
	
	if sPhone.devMode then
		sPhone.crash = crash
	end
	
	function os.version()
		return "sPhone "..sPhone.version
	end
	
	local function clear()
		term.setBackgroundColor(colors.white)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.black)
	end
	
	sPhone.forceShutdown = os.shutdown
	sPhone.forceReboot = os.reboot
	
	function os.shutdown()
		os.pullEvent = os.pullEventRaw
		if sPhone.doneShutdown then
			clear()
			w, h = term.getSize()
			term.setCursorPos( (w/2)- 7, h/2)
			write("Press CTRL + S")
			while true do
				sleep(3600)
			end
		end
		sPhone.doneShutdown = true
		clear()
		w, h = term.getSize()
		term.setCursorPos( (w / 2) - 1, h / 2)
		for i = 1,3 do
			sleep(0.3)
			write(".")
		end
		sleep(0.2)
		sPhone.forceShutdown()
	end
	
	function os.reboot()
		os.pullEvent = os.pullEventRaw
		if sPhone.doneShutdown then
			clear()
			w, h = term.getSize()
			term.setCursorPos( (w/2)- 7, h/2)
			write("Press CTRL + R")
			while true do
				sleep(3600)
			end
		end
		sPhone.doneShutdown = true
		clear()
		w, h = term.getSize()
		term.setCursorPos( (w / 2) - 1, h / 2)
		for i = 1,3 do
			sleep(0.3)
			write(".")
		end
		sleep(0.2)
		sPhone.forceReboot()
	end
  
  function sPhone.header(butt)

    if not sPhone then
      sPhone = {
        user = "Unknown",
      }
    end
    
    local w, h = term.getSize()

    paintutils.drawLine(1,1,w,1, colors.blue)
    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
    write(" "..sPhone.user)
    term.setCursorPos(w,1)
    write("X")
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.setCursorPos(1,3)
  end
  
  function sPhone.menu(items, title, closeButton)
    local function cprint(text)
      if type(text) ~= 'table' then
        text = {text}
      end
	
      local w, h = term.getSize()
	
      for i=1,#text do
        local x, y = term.getCursorPos()
        term.setCursorPos(math.floor(w/2)-math.floor(text[i]:len()/2), y)
        print(text[i])
      end
    end
    local function clear()
      term.clear()
      term.setCursorPos(1, 1)
    end
	
    local termWidth, termHeight = term.getSize()
    local drawSize = termHeight - 6
	
    local function maxPages()
    local itemCount = #items
    local pageCount = 0
		while itemCount > 0 do
			itemCount = itemCount - drawSize
			pageCount = pageCount + 1
		end
		return pageCount
	end
	
	local function iif(cond, trueval, falseval)
		if cond then
			return trueval
		else
			return falseval
		end
	end
	
	local function pagedItems()
		local ret = {}
		for i = 1, maxPages() do
			local tmp = {}
			local nElements = 0
			for j = drawSize*(i-1)+1, iif(drawSize*(i+1) > #items, #items, drawSize*(i+1)) do
				if nElements < drawSize then
					table.insert(tmp, items[j])
					nElements = nElements + 1
				end
			end
			table.insert(ret, tmp)
		end
		return ret
	end
	
	local selected = 1
	if start then
		selected = start
	end
	local page = 1
	
	local function redraw()
		term.setBackgroundColor(colors.white)
		term.setTextColor(colors.black)
		term.clear()
    term.setCursorPos(1,1)
		sPhone.header(closeButton)
		term.setCursorPos(1,3)
		if not title then
			title = "sPhone"
		end
		cprint("  "..title)
		if moreTitle then
			head = moreTitle
		else
			head = {"\n",}
			if not allowNil or allowNil == true then
				--head[3] = 'Terminate to cancel.'
			end
		end
		for i=1,#head do
			print(head[i])
		end
		if maxPages() > 1 then
			pages = "<- (page "..page.." of "..maxPages()..") ->"
			print(pages)
		end
		for i = 1, #pagedItems()[page] do
			if selected == drawSize*(page-1)+i then
				term.setBackgroundColor(colors.white)
				term.setTextColor(colors.black)
			else
				term.setBackgroundColor(colors.white)
				term.setTextColor(colors.black)
			end
			term.clearLine()
			cprint(iif(selected == drawSize*(page-1)+i,"","").." "..pagedItems()[page][i])
			term.setBackgroundColor(colors.white)
			term.setTextColor(colors.black)
		end
	end

	local function changePage(pW)
		if pW == 1 and page < maxPages() then
			page = page + 1
			if selected + drawSize > #items then
				selected = #items
			else
				selected = selected + drawSize
			end
		elseif pW == -1 and page > 1 then
			page = page - 1
			if selected - drawSize < 1 then
				selected = 1
			else
				selected = selected - drawSize
			end
		end
	end
	
	while true do
		redraw()
		local eventData = {os.pullEventRaw()}
		if eventData[1] == 'mouse_click' then
			if eventData[4] == 1 and eventData[3] == 26 then
				return false, 0
			end
			if eventData[4] > 3 then
				clear()
				selected = (eventData[4]-6+((page-1)*drawSize))+1
				if selected then
					return items[selected], selected
				end
			end
		end
		sleep(0)
	end
end
	
	function sPhone.yesNo(title, desc, hideUser)
		term.setCursorBlink(false)
		term.setBackgroundColor(colors.white)
		term.clear()
		term.setCursorPos(1,1)
		term.setTextColor(colors.black)
		local w, h = term.getSize()
		paintutils.drawLine(1,1,w,1, colors.blue)
		term.setTextColor(colors.white)
		term.setCursorPos(1,1)
		if not hideUser then
			if not sPhone.user then
				write(" sPhone")
			else
				write(" "..sPhone.user)
			end
		end
		term.setCursorPos(1,3)
		term.setBackgroundColor(colors.white)
		term.setTextColor(colors.black)
		sertextext.center(3, "  "..title)
		if desc then
			sertextext.center(6, "  "..desc)
		end
		paintutils.drawFilledBox(3, 16, 9, 18, colors.green)
		paintutils.drawFilledBox(18, 16, 24, 18, colors.red)
		term.setTextColor(colors.white)
		term.setCursorPos(5,17)
		term.setBackgroundColor(colors.green)
		write("Yes")
		term.setCursorPos(20,17)
		term.setBackgroundColor(colors.red)
		write("No")
		while true do
			local _,_,x,y = os.pullEvent("mouse_click")
			if (x > 2 and y > 15) and (x < 10 and y < 19) then
				return true
			elseif (x > 17 and y > 15) and (x < 25 and y < 19) then
				return false
			end
		end
	end
	
	function sPhone.winOk(fmessage, smessage, bg, side, text, button)
		if not fmessage then
			fmessage = ""
		end
		if not smessage then
			smessage = ""
		end
		if not bg then
			bg = colors.lightBlue
		end
		if not text then
			text = colors.white
		end
		if not button then
			button = colors.lightBlue
		end
		if not side then
			side = colors.blue
		end
		term.setCursorBlink(false)
		if #fmessage >= #smessage then
			local w, h = term.getSize
			term.setBackgroundColor(side)
			paintutils.drawBox(12 - math.ceil(#fmessage / 2), 5, 15 + math.ceil(#fmessage / 2), 10, side)
			term.setBackgroundColor(bg)
			paintutils.drawFilledBox(13 - math.ceil(#fmessage / 2), 6, 14 + math.ceil(#fmessage / 2), 9, bg)
			term.setCursorPos(14 - math.ceil(#fmessage / 2), 7)
			term.setTextColor(text)
			write(fmessage)
			term.setCursorPos(14 - math.ceil(#smessage / 2), 8)
			write(smessage)
		else
			local w, h = term.getSize
			term.setBackgroundColor(side)
			paintutils.drawBox(12 - math.ceil(#smessage / 2), 5, 15 + math.ceil(#smessage / 2), 10, side)
			term.setBackgroundColor(bg)
			paintutils.drawFilledBox(13 - math.ceil(#smessage / 2), 6, 14 + math.ceil(#smessage / 2), 9, bg)
			term.setCursorPos(14 - math.ceil(#fmessage / 2), 7)
			term.setTextColor(text)
			write(fmessage)
			term.setCursorPos(14 - math.ceil(#smessage / 2), 8)
			write(smessage)
		end
		term.setCursorPos(13,10)
		term.setBackgroundColor(button)
		write("Ok")
		while true do
			local e, k, x,y = os.pullEvent()
			if e == "mouse_click" then
				if y == 10 then
					if x == 13 or x == 14 then
						return
					end
				end
			elseif e == "key" then
				if k == 28 then
					return
				end
			end
		end
	end

	function sPhone.run(_rApp)
		if not fs.exists(_rApp) or fs.isDir(_rApp) then
			sPhone.winOk("App not found")
			return
		end
		local f = fs.open(_rApp, "r")
		local script = f.readAll()
		f.close()
		os.pullEvent = os.oldPullEvent
		local ok, err = pcall(function() setfenv(loadstring(script),getfenv())() end)
		if not ok then
		os.pullEvent = os.pullEventRaw
			sPhone.winOk("Crash: "..fs.getName(_rApp), err)
			return false
		end
		os.pullEvent = os.pullEventRaw
		return true
	end
	
	local function lChat()
		clear()
		local w, h = term.getSize()
		paintutils.drawLine(1,1,w,1,colors.blue)
		term.setCursorBlink(false)
		term.setTextColor(colors.white)
		sertextext.center(1,"  Chat")
		term.setBackgroundColor(colors.white)
		term.setTextColor(colors.black)
		term.setCursorPos(2, 5)
		if not peripheral.isPresent("back") or not peripheral.getType("back") == "modem" then
			print("Modem not found")
			print(" Press any key")
			os.pullEvent("key")
			return
		end
		write("Host: ")
		local h = read()
		term.setCursorPos(2,6)
		shell.run("/rom/programs/rednet/chat", "join", h, sPhone.user)
		sleep(1)
	end
	
	local function home()
		--if not fs.exists("/.sPhone/config/resetDBNews") then
    			--sPhone.winOk("We wiped sID Database","for security issues")
    			--local f = fs.open("/.sPhone/config/resetDBNews","w")
    			--f.write("Ignore me")
    			--f.close()
    		--end
    		if fs.exists("/.sPhone/config/resetDBNews") then
    			fs.delete("/.sPhone/config/resetDBNews")
    		end
		local function drawHome()
			local function box(x,y,text,bg,colorText,page)
				graphics.box(x,y,x+1+#text,y+2,bg)
				term.setCursorPos(x+1,y+1)
				term.setTextColor(colorText)
				write(text)
			end
			clear()
			local w, h = term.getSize()
			paintutils.drawLine(1,1,w,1, colors.blue)
			term.setTextColor(colors.white)
			sertextext.right(1,"vvv")
			term.setCursorPos(1,1)
			if not sPhone.newUpdate then
				write(" "..sPhone.user)
			else
				write(" New Update!")
			end
			box(2,3,"Shell",colors.black,colors.yellow)
			box(19,3,"Lock",colors.lightGray,colors.black)
			box(11,3,"sID",colors.red,colors.white)
			box(2,7,"Buddies",colors.brown,colors.white)
			box(12,7,"Chat", colors.black,colors.white)
			box(19,7,"SMS",colors.green,colors.white)
			box(3, 11, "KST", colors.green, colors.lime)
			box(10, 11, "GPS", colors.red, colors.black)
			box(18, 11, "Info", colors.lightGray, colors.black)
		end
		local function footerMenu()
			sPhone.isFooterMenuOpen = true
			function redraw()
				local w, h = term.getSize()
				graphics.box(1,2,w,4,colors.blue)
				term.setTextColor(colors.white)
				term.setBackgroundColor(colors.blue)
				sertextext.right(1,"^^^")
				sertextext.right(3, "Reboot")
				term.setCursorPos(11,3)
				write("Settings")
				term.setCursorPos(2,3)
				write("Shutdown")
			end
			while true do
				term.redirect(sPhone.mainTerm)
				redraw()
				local _,_,x,y = os.pullEvent("mouse_click")
				if y == 3 then
					if x > 1 and x < 10 then
						os.shutdown()
					elseif x > 19 and x < 26 then
						os.reboot()
					elseif x > 10 and x < 19 then
						shell.run("/.sPhone/apps/system/settings")
						drawHome()
					end
				elseif y == 1 then
					if x < 26 and x > 22 then
						sPhone.isFooterMenuOpen = false
						return
					end
				end
			end
		end
		
		while true do
			drawHome()
			term.setCursorBlink(false)
			local autoLockTimer = os.startTimer(120)
			local e,m,x,y = os.pullEvent()
			if e == "mouse_click" then
				if y == 1 then
					if x < 26 and x > 22 then
						footerMenu()
					end
				else
					if (y > 2 and x > 1) and (y < 6 and x < 9) then
            os.pullEvent = os.oldPullEvent
						term.setBackgroundColor(colors.black)
						term.clear()
						term.setCursorPos(1,1)
						term.setTextColor(colors.white)
						print("Type \"exit\" to close the shell")
						sPhone.run("/rom/programs/shell")
					elseif (y > 2 and x > 10) and (y < 7 and x < 16) then
						sPhone.run("/.sPhone/apps/system/sID")
					elseif (y > 2 and x > 18) and (y < 6 and x < 25) then
						login()
					elseif (y > 6 and x > 1) and (y < 10 and x < 11) then
						sPhone.run("/.sPhone/apps/buddies")
					elseif (y > 6 and x > 11) and (y < 10 and x < 18) then
						lChat()
					elseif (y > 6 and x > 18) and (y < 10 and x < 24) then
						sPhone.run("/.sPhone/apps/sms")
					elseif (y > 10 and x > 2) and (y < 14 and x < 8) then
						sPhone.run("/.sPhone/apps/kstwallet")
					elseif (y > 10 and x > 9) and (y < 14 and x < 15) then
						sPhone.run("/.sPhone/apps/gps")
					elseif (y > 10 and x > 17) and (y < 14 and x < 24) then
						sPhone.run("/.sPhone/apps/system/info")
					end
				end
			elseif e == "timer" and m == autoLockTimer then
				login()
			end
		end
	end
	
	function login()
		if fs.exists("/.sPhone/.password") then
			while true do
				term.clear()
				term.setCursorPos(1,1)
				paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
				term.setTextColor(colors.white)
				term.setBackgroundColor(colors.blue)
				term.setCursorPos(1,1)
				write(" "..sPhone.user)
				if sPhone.wrongPassword then
					term.setTextColor(colors.red)
					term.setBackgroundColor(colors.white)
					sertextext.center(13,"  Wrong Password")
				end
				term.setTextColor(colors.black)
				term.setBackgroundColor(colors.white)
				sertextext.center(7,"  Insert Password")
        local loginTerm = window.create(term.native(), 8,10,12,1, true)
        term.redirect(loginTerm)
        term.setBackgroundColor(colors.white)
        term.clear()
        term.setCursorPos(1,1)
        term.setTextColor(colors.black)
				local passwordLogin = read("*")
        term.redirect(sPhone.mainTerm)
				local fpw = fs.open("/.sPhone/.password","r")
				if sha256.sha256(passwordLogin) == fpw.readLine() then
					sPhone.wrongPassword = false
					home()
				else
					sPhone.wrongPassword = true
				end
			end
		else
			local name
			local pw
			local pwr
			local rServer
			while true do
				term.clear()
				term.setCursorPos(1,1)
				paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
				if sPhone.wrongPassword then
					term.setTextColor(colors.red)
					sertextext.center(13,"  Wrong Password")
				end
				term.setTextColor(colors.black)
				term.setBackgroundColor(colors.white)
				sertextext.center(3,"  Setup")
				sertextext.center(7,"  Insert Password")
				local loginTerm = window.create(term.native(), 8,10,12,1, true)
				term.redirect(loginTerm)
				term.setBackgroundColor(colors.white)
				term.clear()
				term.setCursorPos(1,1)
				term.setTextColor(colors.black)
				local password1 = read("*")
				term.redirect(sPhone.mainTerm)
				term.clear()
				term.setCursorPos(1,1)
				paintutils.drawImage(paintutils.loadImage("/.sPhone/interfaces/login"),1,1)
				term.setTextColor(colors.black)
				term.setBackgroundColor(colors.white)
				sertextext.center(3,"  Setup")
				sertextext.center(7,"  Repeat")
				local loginTerm = window.create(term.native(), 8,10,12,1, true)
				term.redirect(loginTerm)
				term.setBackgroundColor(colors.white)
				term.clear()
				term.setCursorPos(1,1)
				term.setTextColor(colors.black)
				local password2 = read("*")
				term.redirect(sPhone.mainTerm)
				if password1 == password2 then
					local f = fs.open("/.sPhone/.password", "w")
					f.write(sha256.sha256(password1))
					f.close()
					term.setTextColor(colors.lime)
					sertextext.center(13,"  Password set!")
					sleep(2)
					break
				else
					sPhone.wrongPassword = true
				end
			end
			
			term.setBackgroundColor(colors.white)
			term.clear()
			term.setCursorPos(1,1)
			local w, h = term.getSize()
			paintutils.drawLine(1,1,w,1,colors.blue)
			term.setTextColor(colors.black)
			term.setBackgroundColor(colors.white)
			sertextext.center(3,"  Setup Sertex ID")
			local isDown = http.get("http://sertex.x10.bz/status.php").readAll()
			if isDown ~= "true" then
				sertextext.center(5, "  The server is down")
				sertextext.center(6, "  Run sID on the home")
				name = "Run sID"
				sleep(2)
			else
				
				local choose = sPhone.yesNo("Setup Sertex ID", "Do you have a Sertex ID?", true)
				if not choose then
					term.setBackgroundColor(colors.white)
					term.clear()
					term.setCursorPos(1,1)
					local w, h = term.getSize()
					paintutils.drawLine(1,1,w,1,colors.blue)
					term.setTextColor(colors.black)
					term.setBackgroundColor(colors.white)
					sertextext.center(3,"  Setup Sertex ID")
					sertextext.center(7,"  Your Username")
					term.setCursorPos(3,8)
					name = read()
					while true do
						sertextext.center(9, "  Your Password")
						term.setCursorPos(3,10)
						term.clearLine()
						pw = read("*")
						sertextext.center(11, "  Repeat")
						term.setCursorPos(3,12)
						term.clearLine()
						pwr = read("*")
						if pw == pwr then
							break
						else
							print("   Wrong Password")
							sleep(1)
						end
					end
					local rServer = http.post("http://sertex.x10.bz/register.php", "user="..name.."&password="..pw).readAll()
					if rServer ~= "Success!" then
						print("Username already exists")
						print("Retry later in the app sID")
						sleep(2)
					else
						local f = fs.open("/.sPhone/config/username","w")
						f.write(name)
						f.close()
						local pwf = fs.open("/.sPhone/config/.sIDPw", "w")
						pwf.write(sha256.sha256(pw))
						pwf.close()
					end
				else
					term.setBackgroundColor(colors.white)
					term.clear()
					term.setCursorPos(1,1)
					local w, h = term.getSize()
					paintutils.drawLine(1,1,w,1,colors.blue)
					term.setTextColor(colors.black)
					term.setBackgroundColor(colors.white)
					sertextext.center(3,"  Setup Sertex ID")
					sertextext.center(7,"  Your Username")
					term.setCursorPos(3,8)
					name = read()
					sertextext.center(9, "  Your Password")
					term.setCursorPos(3,10)
					term.clearLine()
					pw = read("*")
					sertextext.center(11, "  Checking...")
					rServer = http.post("http://sertex.x10.bz/login.php", "user="..name.."&password="..pw).readAll()
						if rServer ~= "true" then
						print("   Wrong Username/Password")
						print("   Run sID")
						sleep(2)
					else
						f = fs.open("/.sPhone/config/username", "w")
						f.write(name)
						f.close()
						f = fs.open("/.sPhone/config/.sIDpw", "w")
						f.write(sha256.sha256(pw))
						f.close()
					end
				end
			end
			sPhone.user = name
			os.setComputerLabel(sPhone.user.."'s sPhone")
			term.setCursorPos(1,13)
			term.clearLine()
			sertextext.center(13,"  All Set!")
			term.setCursorPos(1,14)
			term.clearLine()
			sertextext.center(14,"  Have fun with sPhone")
			sleep(2)
			home()
		end
	end
	
	local newVersion = http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/version").readLine()
	if newVersion ~= sPhone.version then
		sPhone.newUpdate = true
	else
		sPhone.newUpdate = false
	end
	
	login()

end

local runningOnStartup

term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)

if sPhone then
	printError("sPhone already started")
	return
end

if not pocket or not term.isColor() then
	printError("Computer not supported: use an Advanced Pocket Computer or an Advanced Wireless Pocket Computer")
	return
end

local tArgs = {...}

os.oldPullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw

local argData = {
	["-u"] = false,
	["-s"] = false,
}

if #tArgs > 0 then
  while #tArgs > 0 do
    local tArgs = table.remove(tArgs, 1)
    if argData[tArgs] ~= nil then
      argData[tArgs] = true
    end
  end
end

if argData["-u"] then
	print("Getting installer...")
	setfenv(loadstring(http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/installer.lua").readAll()),getfenv())()
end

if argData["-s"] then
	runningOnStartup = true
end

local ok, error = pcall(kernel)

if not ok then
	crash(error)
end

crash("Something went wrong...")
