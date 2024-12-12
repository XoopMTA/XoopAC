local Xoop ="#a8269d[#9f249aX#932196o#851d92o#76198ep#671589-#591185A#4d0e81C#440c7e]"

-- Check for VPN or proxy
local Ip = {}
addEventHandler("onPlayerJoin",root,function()
  local ip = getPlayerIP(source)
  fetchRemote("https://ipinfo.io/widget/demo/"..ip,function(e,re)
    if Ip[ip] then kickPlayer(client, "XoopAC", "\nKicked by XoopAC\nDisable your VPN\n") return end
    local data = fromJSON(re)
    if data["data"]["privacy"]["vpn"] == "true" or data["data"]["privacy"]["proxy"] == "true"  then
      Ip[ip] = true
      kickPlayer(client, "XoopAC", "\nKicked by XoopAC\nDisable your VPN\n")
    end 
  end, "", false)
end)

-- Send a text to every players
addEvent("XoopAC:outputForAll", true)
addEventHandler("XoopAC:outputForAll", root, function(text, pass)
  if pass ~= getXoopPassword() or client ~= source then return end
  outputChatBox(Xoop.." #ffffff"..getPlayerName(client) .. " " .. text, root, 255,0,0,true)
  SaveLog(text)
end )

-- kick
addEvent("XoopAC:Kick", true)
addEventHandler("XoopAC:Kick", root, function()
  if not client == source then return end
  setElementPosition(client, 2000, 2000, 2000)
  local x, y, z = getElementPosition(client)
  local nearbyPlayers = getElementsWithinRange(x, y, z, 30, "player")
  for i,v in ipairs(nearbyPlayers) do
    if v and isElement(v) then
      setElementPosition(v, -2402.00000, -599.00000, 132.6484)
    end
  end
  outputChatBox(Xoop.. " #ffffff"..getPlayerName(client).. " Kicked By XoopAC", root, 255,0,0,true)
  SaveLog(getPlayerName(client).. " Kicked By XoopAC")
  kickPlayer(client, "XoopAC", "\nKicked by XoopAC\n")
end)

-- weapons to block
local weaponsToBlock = {
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[16] = true,
	[17] = true,
	[18] = true,
  [39] = true,
}

function onPlayerWeaponSwitch(previousWeaponID, currentWeaponID)
	local blockFire = (not weaponsToBlock[currentWeaponID])
	toggleControl(source, "fire", blockFire)
  if blockFire == false then 
    takeWeapon(source, currentWeaponID)
  end 
end
addEventHandler("onPlayerWeaponSwitch", root, onPlayerWeaponSwitch)

setServerConfigSetting("max_player_triggered_events_per_interval",1000)
setServerConfigSetting("player_triggered_event_interval",34)

function processPlayerTriggerEventThreshold()
  outputChatBox("#a8269d[#9f249aX#932196o#851d92o#76198ep#671589-#591185A#4d0e81C#440c7e] #ffffff"..getPlayerName(source).." Kicked Because Of Event Spamming", root, 255,0,0,true)
  kickPlayer(source, "\nKicked By XoopAC\n")
  SaveLog(getPlayerName(source).." Kicked Because Of Event Spamming")
end
addEventHandler("onPlayerTriggerEventThreshold", root, processPlayerTriggerEventThreshold)

invalideventlist = {}
function onPlayerTriggerInvalidEvent(eventName, isAdded, isRemote)
	if invalideventlist == {} then 
    invalideventlist[getPlayerName(source)] = 1
  else 
    local p = invalideventlist[getPlayerName(source)] or 0
    if p >= 10 then 
      outputChatBox("#a8269d[#9f249aX#932196o#851d92o#76198ep#671589-#591185A#4d0e81C#440c7e] #ffffff"..getPlayerName(source).." Kicked Because Of Invalid Event Spamming", root, 255,0,0,true)
      kickPlayer(source, "\nKicked By XoopAC\n")
      SaveLog(getPlayerName(source).." Kicked Because Of Invalid Event Spamming")
    else 
      invalideventlist[getPlayerName(source)] = p + 1
    end 
  end 
end
addEventHandler("onPlayerTriggerInvalidEvent", root, onPlayerTriggerInvalidEvent)

outputServerLog("github.com/XoopMTA")

-- save executed code
addEvent("XoopAC-SaveCode",true)
addEventHandler("XoopAC-SaveCode",root,function(Code,Password)
  if source == client and Password == getXoopPassword() then
    for index=1,999 do 
      if not fileExists("Script/"..index.."_CheaterCode_.lua") then
        local File = fileCreate("Script/"..index.."_CheaterCode_.lua")
        fileWrite(File , Code)
        fileClose(File)
        break
      end
    end
  end
end)

-- anti gun hack
addEvent("XoopAC-onPlayerGunCheck",true)
addEventHandler("XoopAC-onPlayerGunCheck",root,function(Guns,Password)
  if source == client and Password == getXoopPassword() then
    for index=1,12 do
      if Guns[index] ~= getPedWeapon(source,index) then
        if isPedDead(source) then
          outputChatBox(Xoop.." #FFFFFF"..getPlayerName(source).." Used GunHack And Kicked", 255, 255, 255, true)
          kickPlayer(client, "XoopAC", "\nKicked by XoopAC\n")
          SaveLog(getPlayerName(source).." Used GunHack And Kicked")
        end
      end
    end
  end
end)

local list = {}

addEventHandler("onPlayerJoin",root,function()
  list[getPlayerSerial(source)] = not list[getPlayerSerial(source)] or false
  if list[getPlayerSerial(source)] then
    redirectPlayer(source,"",getServerPort())
  end
end)

function SaveLog(text)
  theFile = fileOpen("log/msCheater.txt")
  if not theFile then
    theFile = fileCreate("log/msCheater.txt")
  end 
  local time = getRealTime()
	local hours, minutes, seconds = time.hour, time.minute, time.second
  local monthday, month, year = time.monthday, time.month, time.year
  fileSetPos(theFile, fileGetSize(theFile))
  local Text = string.format("[%04d-%02d-%02d %02d:%02d:%02d] %s\n", year + 1900, month + 1, monthday, hours, minutes, seconds,text:gsub("#FFFFFF",""):gsub(Xoop,""):gsub("#ffffff",""))
  fileWrite(theFile, Text)
  fileClose(theFile)
end

addEventHandler("onPlayerJoin", root, function()
  resendPlayerACInfo(source)
end)

addEventHandler("onResourceStart",resourceRoot,function()
  for index, player in ipairs(getElementsByType("player")) do
    resendPlayerACInfo(player)
  end
end)

local reasonAc = {
[12] = "Custom D3D9.DLL not allowed", 
[14] = "Virtual machines not allowed",
[15] = "Driver signing must be enabled",
[16] = "Anti-cheat components issue",
[20] = "Non-standard GTA IMG not allowed",
[22] = "Resource download error (Lua)",
[23] = "Resource download error (Non-Lua)",
[28] = "Linux Wine not allowed", 
[33] = "Net limiter software not allowed",
}
addEventHandler("onPlayerACInfo", root, function( detectedACList, d3d9Size, d3d9MD5, d3d9SHA256 )
  for _, acCode in ipairs(detectedACList) do
    if reasonAc[acCode] then
      kickPlayer(source,"XoopAC",reasonAc[acCode])
    end 
  end
end)


-- Anti Godmode
addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart, loss)
  local currentHealth = getElementHealth(source)
  setTimer(function(player, prevHealth)
      if getElementHealth(player) == prevHealth then
        outputChatBox(Xoop.. " #ffffff"..getPlayerName(source).. " Is Using Godmode Hack", root, 255,0,0,true)
        SaveLog(getPlayerName(source).. " Is Using Godmode Hack")
      end
  end, 500, 1, source, currentHealth)
end)
