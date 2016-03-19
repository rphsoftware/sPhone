local function kernel()
	_G.sPhone = {
		version = "Alpha 2.12.2 DEV",
		user = "Guest",
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
	
	if not fs.exists("/.sPhone/config/newPassword") and fs.exists("/.sPhone/.password") then
		fs.move("/.sPhone/.password","/.sPhone/config/.password")
		f = fs.open("/.sPhone/config/newPassword","w")
		f.write("Ignore Me. I just check if the password is moved to the config folder")
		f.close()
	end
	
	if not fs.exists("/.sPhone/apis") then
		fs.makeDir("/.sPhone/apis")
	end
	
	for k, v in pairs(fs.list("/.sPhone/apis")) do
		if not fs.isDir("/.sPhone/apis/"..v) then
			os.loadAPI("/.sPhone/apis/"..v)
		end
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
			if not safemode then
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
			else
				print("Script "..v.." not loaded because Safe Mode")
				sleep(0)
			end
		end
	end

	if safemode then
		_G.safemode = nil
	end
	
	if runningOnStartup then
		fs.open("/startup","r")
	end
	
	if fs.exists("/.sPhone/config/username") then
		local u = fs.open("/.sPhone/config/username","r")
		sPhone.user = u.readLine()
		u.close()
	end
	
	if not fs.exists("/.sPhone/config/sPhone") then
		config.write("/.sPhone/config/sPhone","devMode",false)
	end
	
	sPhone.devMode = config.read("/.sPhone/config/sPhone","devMode")
	
	if sPhone.devMode then
		sPhone.crash = crash
	end
	
	_G.crash = nil
	function os.version()
		return "sPhone "..sPhone.version
	end
	
	function sPhone.getSize()
		return term.getSize()
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
		sPhone.inHome = false
		os.pullEvent = os.pullEventRaw
		if sPhone.doneShutdown then
			clear()
			w, h = term.getSize()
			term.setCursorPos( (w/2)- 7, h/2)
			write("Shutdown Aborted.")
			sPhone.winOk("Error","Can not shutdown",colors.lightBlue,colors.red, colors.white, colors.lightBlue)
			return
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
		sPhone.inHome = false
		os.pullEvent = os.pullEventRaw
		if sPhone.doneShutdown then
			clear()
			w, h = term.getSize()
			term.setCursorPos( (w/2)- 7, h/2)
			write("Reboot Aborted.")
			sPhone.winOk("Error","Can not reboot",colors.lightBlue,colors.red, colors.white, colors.lightBlue)
			return
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
    local function upd()
			local w, h = term.getSize()

			paintutils.drawLine(1,1,w,1, colors.blue)
			term.setTextColor(colors.white)
			term.setCursorPos(1,1)
			write("  "..sPhone.user)
			term.setCursorPos(w,1)
			if butt then
				write(butt)
			end
			term.setBackgroundColor(colors.white)
			term.setTextColor(colors.black)
			term.setCursorPos(1,3)
		end
		
		upd()
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
			title = "  sPhone"
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
			if eventData[4] == 1 and eventData[3] == termWidth then
				return false, 0
			elseif eventData[4] > 3 then
				clear()
				selected = (eventData[4]-6+((page-1)*drawSize))+1
				if selected then
					return items[selected], selected
				end
			end
		end
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
		visum.align("center", "  "..title, false, 3)
		if desc then
			visum.align("center", "  "..desc,false,6)
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
		if sPhone.inHome then
			local sPhoneWasInHome = true
			sPhone.inHome = false
		end
		os.pullEvent = os.oldPullEvent
		local ok, err = pcall(function() setfenv(loadstring(script),getfenv())() end)
		if not ok then
			os.pullEvent = os.pullEventRaw
			term.setBackgroundColor(colors.white)
			term.setTextColor(colors.black)
			term.clear()
			term.setCursorPos(1,2)
			visum.align("center","  "..fs.getName(_rApp).." crashed",false,2)
			term.setCursorPos(1,4)
			print(err)
			print("")
			visum.align("center","  Press Any Key")
			os.pullEvent("key")
		end
		os.pullEvent = os.pullEventRaw
		if sPhoneWasInHome then
			sPhone.inHome = true
		end
	end
	
	local function lChat()
		clear()
		local w, h = term.getSize()
		paintutils.drawLine(1,1,w,1,colors.blue)
		term.setCursorBlink(false)
		term.setTextColor(colors.white)
		visum.align("center","  Chat",false,1)
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
	
	local function installedApps()
		sPhone.winOk("Work In","Progress")
		local dir = "/.sPhone/apps/storeApps/"
		if not fs.exists(dir) then
			fs.makeDir(dir)
		end
		
		local apps = {}
		local appsName = {}
		
		for k, v in pairs(fs.list(dir)) do
			if fs.isDir(dir..v) then
				if fs.exists(dir..v.."/sPhone-Main.lua") then
					local nDir = dir..v.."/sPhone-Main.lua"
					
					pDir = dir..v
					local run = config.read(nDir, "run")
					local name = config.read(nDir, "name")
					local author = config.read(nDir, "author")
					local version = config.read(nDir, "version")
					
					appsName[name] = run
				end
			end
		end
		
		for k, v in pairs(appsName) do
			table.insert(apps, v)
		end
		local function drawHome()
			clear()
			local w, h = term.getSize()
			paintutils.drawLine(1,1,w,1, colors.blue)
			term.setTextColor(colors.white)
			visum.align("right","X",false,1)
			visum.align("center", "  Apps",false,1)
			term.setTextColor(colors.black)
			term.setBackgroundColor(colors.white)
			term.setCursorPos(1,3)
			for k, v in pairs(appsName) do
				print(k)
			end
		end	
		
		drawHome()
		
		local w, h = term.getSize()
		
		while true do
			drawHome()
			local _,_,x,y = os.pullEvent("mouse_click")
			if x == w and y == 1 then
				break
			elseif y >= 2 then
				if apps[y-2] then
					sPhone.run("/.sPhone/apps/storeApps/"..pDir.."/"..apps[y-2])
				end
			end
		end
	end
	
	local function home()
	
		sPhone.inHome = true
	
		local buttonsInHome = {
			{"sPhone.header",23,1,25,1,colors.blue,colors.white,"vvv"},
			{"sPhone.appsButton",12,20,14,20,colors.white,colors.blue,"==="},
			{"sPhone.shell",2,3,8,5,colors.black,colors.yellow," Shell",2},
			{"sPhone.sID",11,3,15,5,colors.red,colors.white," sID",2},
			{"sPhone.lock",19,3,24,5,colors.lightGray,colors.black," Lock",2},
			{"sPhone.buddies",2,7,10,9,colors.brown,colors.white," Buddies",2},
			{"sPhone.chat",12,7,17,9,colors.black,colors.white," Chat",2},
			{"sPhone.SMS",19,7,23,9,colors.green,colors.white," SMS",2},
			{"sPhone.kst",3,11,7,13,colors.green,colors.lime," KST",2},
			{"sPhone.gps",10,11,14,13,colors.red,colors.black," GPS",2},
			{"sPhone.info",18,11,23,13,colors.lightGray,colors.black," Info",2},
			{"sPhone.store",2,15,8,17,colors.orange,colors.white," Store",2},
		}
		
		
		local appsOnHome = {
			["sPhone.shell"] = "/.sPhone/apps/shell",
			["sPhone.sID"] = "/.sPhone/apps/system/sID",
			["sPhone.buddies"] = "/.sPhone/apps/buddies",
			["sPhone.SMS"] = "/.sPhone/apps/sms",
			["sPhone.gps"] = "/.sPhone/apps/gps",
			["sPhone.kst"] = "/.sPhone/apps/kstwallet",
			["sPhone.info"] = "/.sPhone/apps/system/info",
			["sPhone.store"] = "/.sPhone/apps/store",
		}
    		
    		if not sPhone.locked then
    			sPhone.lock()
    		end
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
			
			
			visum.buttons(buttonsInHome,true)
			
			local w, h = term.getSize()
			paintutils.drawLine(1,1,w,1, colors.blue)
			term.setTextColor(colors.white)
			visum.align("right","vvv ",false,1)
		end
		local function footerMenu()
			sPhone.isFooterMenuOpen = true
			function redraw()
				drawHome()
				local w, h = term.getSize()
				graphics.box(1,2,w,4,colors.blue)
				term.setTextColor(colors.white)
				term.setBackgroundColor(colors.blue)
				visum.align("right","^^^ ",false,1)
				visum.align("right", "Reboot ",false,3)
				term.setCursorPos(11,3)
				write("Settings")
				term.setCursorPos(2,3)
				write("Shutdown")
			end
			while true do
				term.redirect(sPhone.mainTerm)
				drawHome()
				redraw()
				local _,_,x,y = os.pullEvent("mouse_click")
				if y == 3 then
					if x > 1 and x < 10 then
						os.shutdown()
					elseif x > 19 and x < 26 then
						os.reboot()
					elseif x > 10 and x < 19 then
						sPhone.inHome = false
						sPhone.run("/.sPhone/apps/system/settings")
						sPhone.inHome = true
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
		local function buttonHomeLoop()
			while true do
				drawHome()
				term.setCursorBlink(false)
				local autoLockTimer = os.startTimer(10)
				local id = visum.buttons(buttonsInHome)
				
				if id == "sPhone.header" then
					footerMenu()
				elseif id == "sPhone.appsButton" then
					sPhone.inHome = false
					installedApps()
					sPhone.inHome = true
				elseif id == "sPhone.lock" then
					sPhone.inHome = false
					login()
					sPhone.inHome = true
				elseif id == "sPhone.chat" then
					sPhone.inHome = false
					lChat()
					sPhone.inHome = true
				elseif appsOnHome[id] then
					sPhone.inHome = false
					sPhone.run(appsOnHome[id])
					sPhone.inHome = true
				end
			end
		
			sPhone.inHome = false
		
		end
		
		local function updateClock()
			while true do
				if sPhone.inHome then
					term.setCursorPos(1,1)
					term.setBackgroundColor(colors.blue)
					term.setTextColor(colors.white)
					write("     ")
					term.setCursorPos(1,1)
					write(" "..textutils.formatTime(os.time(),true))
				end
				sleep(0)
			end
		end
		
		parallel.waitForAll(buttonHomeLoop, updateClock)
		
		sPhone.inHome = false
		
	end
	
	function login()
		sPhone.locked = true
		if fs.exists("/.sPhone/config/.password") then
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
					visum.align("center","  Wrong Password",false,13)
				end
				term.setTextColor(colors.black)
				term.setBackgroundColor(colors.white)
				visum.align("center","  Insert Password",false,7)
        local loginTerm = window.create(term.native(), 8,10,12,1, true)
        term.redirect(loginTerm)
        term.setBackgroundColor(colors.white)
        term.clear()
        term.setCursorPos(1,1)
        term.setTextColor(colors.black)
				local passwordLogin = read("*")
        term.redirect(sPhone.mainTerm)
				local fpw = fs.open("/.sPhone/config/.password","r")
				if sha256.sha256(passwordLogin) == fpw.readLine() then
					sPhone.wrongPassword = false
					return
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
					visum.align("center","  Wrong Password",false,13)
				end
				term.setTextColor(colors.black)
				term.setBackgroundColor(colors.white)
				visum.align("center","  Setup",false,3)
				visum.align("center","  Insert Password",false,5)
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
				visum.align("center","  Setup",false,3)
				visum.align("center","  Repeat",false,7)
				local loginTerm = window.create(term.native(), 8,10,12,1, true)
				term.redirect(loginTerm)
				term.setBackgroundColor(colors.white)
				term.clear()
				term.setCursorPos(1,1)
				term.setTextColor(colors.black)
				local password2 = read("*")
				term.redirect(sPhone.mainTerm)
				if password1 == password2 then
					local f = fs.open("/.sPhone/config/.password", "w")
					f.write(sha256.sha256(password1))
					f.close()
					term.setTextColor(colors.lime)
					visum.align("center","  Password set!",false,13)
					sleep(2)
					break
				else
					sPhone.wrongPassword = true
				end
			end
			
			sPhone.run("/.sPhone/apps/system/sID")
			
			local name
			
			if fs.exists("/.sPhone/config/username") then
				local f = fs.open("/.sPhone/config/username","r")
				name = f.readLine()
				f.close()
			else
				name = "Guest"
			end
			term.setBackgroundColor(colors.white)
			term.clear()
			term.setCursorPos(1,1)
			term.setTextColor(colors.black)
			_G.sPhone.user = name
			os.setComputerLabel(sPhone.user.."'s sPhone")
			term.setCursorPos(1,13)
			term.clearLine()
			visum.align("center","  All Set!",false,13)
			term.setCursorPos(1,14)
			term.clearLine()
			visum.align("center","  Have fun with sPhone",false,14)
			sleep(2)
			sPhone.locked = false
			return
		end
	end

	sPhone.lock = login
	sPhone.login = login

	local newVersion = http.get("https://raw.githubusercontent.com/Sertex-Team/sPhone/master/src/version").readLine()
	
	if newVersion ~= sPhone.version then
		sPhone.newUpdate = true
	else
		sPhone.newUpdate = false
	end
	
	home()

end
if not sPhone then
	kernel(...)
else
	print("sPhone already started")
end
