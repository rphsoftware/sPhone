_G.sPhone = {}

local function crash(err)
  os.pullEvent = os.pullEventRaw
  if not err then
    err = "Unknown"
  end
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,2)
  term.setTextColor(colors.white)
  print(" ###")
  print(" #  ")
  print(" ###")
  print("   #")
  print(" ###")
  print("")
  print("sPhone crash: ")
  print(err)
  while true do
    sleep(3600)
  end
end

function kernel()
  
end

local ok, err = pcall(kernel)

if not ok then
  sPhone.crash(err)
end
