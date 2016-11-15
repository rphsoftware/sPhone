local spkList = "/.sPhone/config/spklist"
local dir = "/.sPhone/apps/spk/"
if not fs.exists(spkList) then
	config.list("/.sPhone/config/spklist")
end
		
		local apps = {}
		
		for k,v in pairs(config.list(spkList)) do
			table.insert(apps,{
				id = k,
				name = v,
			})
		end
		
		for k,v in ipairs(apps) do
			local hid = config.read(dir..v.id.."/.spk","hidden")
			if hid then
				table.remove(apps,k)
			end
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
