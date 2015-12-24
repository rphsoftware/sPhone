sPhone.winOk("Work In","Progress")

local host = "https://raw.githubusercontent.com/Sertex-Team/sPhone-Store/master/"
local index = host.."index.lua"
local apps = host.."apps/"
local save = "/.sPhone/apps/storeApps/"
local appsL = {}
local w, h = term.getSize()

term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)
paintutils.drawLine(1,1,w,1,colors.orange)
visum.align("right","X",false,1)
visum.align("center","  Store",false,1)
term.setTextColor(colors.black)
term.setBackgroundColor(colors.white)
term.setCursorPos(1,3)

local c = http.get(index).readAll()

local appsIndex = textutils.unserialize(c)

for k, v in pairs(appsIndex) do
	local aa = http.get(apps..v.."/sPhone-Main.lua").readAll()
	local a = textutils.unserialize(aa)
	table.insert(appsL,a)
end
for i = 1, #appsL do
	print(appsL[i].name)
end



while true do
	local _, _, x, y = os.pullEvent("mouse_click")
	if x == w and y == 1 then
		break
	end
	
end
