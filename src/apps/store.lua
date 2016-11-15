local host = "https://raw.github.com/Sertex-Team/sPhone-Store/master/"
local index = host.."index.lua"
local apps = host.."apps/"
local appsL = {}
local w, h = term.getSize()
local function redrawM()
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
	term.clear()
	term.setTextColor(colors.white)
	paintutils.drawLine(1,1,w,1,colors.green)
	term.setCursorPos(1,1)
	write(" Store")
	visum.align("right","X",false,1)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.white)
	term.setCursorPos(1,3)
end

local function install(ap)
	local data = http.get("https://raw.github.com/Sertex-Team/sPhone-Store/master/apps/"..ap.path).readAll()
	local f = fs.open("/tmp/sPhoneStore/"..ap.id..".spk","w")
	f.write(data)
	f.close()
	local status = sPhone.install("/tmp/sPhoneStore/"..ap.id..".spk")
	if status then
		sPhone.winOk("Installed")
	else
		sPhone.winOk("Error while installing")
	end
end

redrawM()

term.setCursorPos(1,2)
visum.align("center","  Loading",false,2)
term.setCursorPos(1,3)

local c = http.get(index).readAll()

local appsIndex = textutils.unserialize(c)

function redrawA()
	for k,v in pairs(appsIndex) do
		print(v)
		table.insert(appsL, {
			path = k,
			id = v,
		})
	end
end

local function redraw()
	redrawM()
	redrawA()
end
redrawA()
local mx,my = term.getCursorPos()
term.setCursorPos(1,2)
term.clearLine()
term.setCursorPos(mx,my)


while true do
	redraw()
	local _, _, x, y = os.pullEvent("mouse_click")
	if x == w and y == 1 then
		break
	end
	
	if appsL[y-2] then
		local data = http.get("https://raw.github.com/Sertex-Team/sPhone-Store/master/apps/"..appsL[y-2].path).readAll()
		data = textutils.unserialise(data)
		if data then
			local _conf = textutils.unserialise(data.config)
			redrawM()
			term.setCursorPos(2,3)
			print(_conf.name)
			term.setCursorPos(2,6)
			term.setTextColor(colors.black)
			print("Author:")
			term.setTextColor(colors.gray)
			term.setCursorPos(2,7)
			print(_conf.author)
			term.setCursorPos(2,9)
			term.setTextColor(colors.black)
			print("Type:")
			term.setTextColor(colors.gray)
			term.setCursorPos(2,10)
			print((_conf.type or "Normal"))
			term.setCursorPos(2,12)
			term.setTextColor(colors.black)
			print("Version:")
			term.setTextColor(colors.gray)
			term.setCursorPos(2,13)
			print(_conf.version)
			
			if config.read("/.sPhone/config/spklist",_conf.id) then
				paintutils.drawLine(19,4,25,4,colors.red)
				term.setTextColor(colors.white)
				term.setCursorPos(19,4)
				write("Delete")
			else
				paintutils.drawLine(19,4,25,4,colors.green)
				term.setTextColor(colors.white)
				term.setCursorPos(19,4)
				write("Install")
			end
			
			while true do
				local _,_,mx,my = os.pullEvent("mouse_click")
				if my == 1 and x == mw then
					break
				elseif (mx >= 19 and mx <= 25) and my == 4 then
					if config.read("/.sPhone/config/spklist",_conf.id) then
						if fs.exists("/.sPhone/apps/spk/".._conf.id) then
							fs.delete("/.sPhone/apps/spk/".._conf.id)
						end
						config.write("/.sPhone/config/spklist",_conf.id,nil)
					else
						install(appsL[y-2])
					end
					break
				end
			end
		else
			sPhone.winOk("Cannot install","file corrupted")
		end
		
		
		
	end
end
