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

local function kernel()
  _G.sPhone = {
    version = "1.0",
    eApp = false,
  }
  
  if not fs.exists("/.sPhone/apis") then
    fs.makeDir("/.sPhone/apis")
  end
  
  for k, v in ipairs(fs.list("/.sPhone/apis")) do
    os.loadAPI("/.sPhone/apis/"..v)
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
  
  os.forceShutdown = os.shutdown
  os.forceReboot = os.reboot
  
  function os.shutdown()
    clear()
    print("Goodbye")
    sleep(1)
    os.forceShutdown()
  end
  
  function os.reboot()
    clear()
    print("See you!")
    sleep(1)
    os.forceReboot()
  end
end

local ok, err = pcall(kernel)

if not ok then
  sPhone.crash(err)
end
