local spkList = "/.sPhone/config/spklist"
local dir = "/.sPhone/spk/"
if not fs.exists(spkList) then
	config.list("/.sPhone/config/spklist")
end
		
		local list = config.list("/.sPhone/config/spklist")
		
		local apps = {}
		
		for k, v in pairs(list) do
			if fs.isDir("/.sPhone/spk/"..k) then
				if fs.exists(dir..k.."/.spk") then
					local nDir = dir..k.."/.spk"
					pDir = dir..k.."/.spk"
					local name = config.read(pDir,"name")
					local author = config.read(pDir,"author")
					local version = config.read(pDir,"version")
					local id = k
				end
			end
		end
		
		for k,v in pairs(config.list(spkList)) do
			table.insert(apps,{
				id = k,
				name = v,
			})
		end
		
		local function drawHome()
			term.setBackgroundColor(sPhone.theme["backgroundColor"])
			term.clear()
			term.setTextColor(sPhone.theme["text"])
			sPhone.header("Apps","X")
			term.setBackgroundColor(sPhone.theme["backgroundColor"])
			term.setTextColor(sPhone.theme["text"])
			
			term.setCursorPos(1,3)
			for k, v in pairs(apps) do
				print(v.name)
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
					sPhone.launch(apps[y-2].id)
					return
				end
			end
		end
