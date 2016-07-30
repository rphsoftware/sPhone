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
					local f = fs.open(nDir,"r")
					local sPhone_Main = f.readAll()
					f.close()
					sPhone_Main = textutils.unserialize(sPhone_Main)
					pDir = dir..v
					local run = sPhone_Main.main
					local name = sPhone_Main.name
					local author = sPhone_Main.author
					local version = sPhone_Main.version
					
					appsName[name] = dir..v.."/"..run
				end
			end
		end
		
		for k, v in pairs(appsName) do
			table.insert(apps, v)
		end
		local function drawHome()
			term.setBackgroundColor(sPhone.theme["backgroundColor"])
			term.clear()
			term.setTextColor(sPhone.theme["text"])
			sPhone.header("Apps","X")
			term.setBackgroundColor(sPhone.theme["backgroundColor"])
			term.setTextColor(sPhone.theme["text"])
			
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
					sPhone.run("/.sPhone/apps/storeApps/"..apps[y-2])
				end
			end
		end
