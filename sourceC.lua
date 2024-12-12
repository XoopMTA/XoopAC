
-- Developed by Xoop Team and Mohammad @story_fe

local Xoop ="#a8269d[#9f249aX#932196o#851d92o#76198ep#671589-#591185A#4d0e81C#440c7e]"

for m, v in pairs(_G) do
  if not m then
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
end

-- Trigger Event Counter
local tCount = 0
setTimer(function()
  tCount = 0
end, 3000, 0)
--
function onPreFunction( sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ... )
  if functionName == "addDebugHook" and sourceResource ~= getThisResource()  then return "skip" end
  if functionName == "loadstring" or functionName == "load" or functionName == "pcall" then 
    saveCode( ({...})[1] ) 
    triggerServerEvent("XoopAC:outputForAll", localPlayer,"Used Lua Executor And Kicked", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
    return "skip"
  end 
  if functionName == "setPedOnFire" or functionName == "createProjectile" or functionName == "createExplosion" or functionName == "blowVehicle" then 
    return "skip"
  end
  if functionName == "triggerServerEvent" or functionName == "triggerEvent" then 
    tCount = tCount + 1
    if tCount >= 20 then 
      triggerServerEvent("XoopAC:outputForAll", localPlayer,"Kicked Because Of Spamming", getXoopPasswordClient())
      triggerServerEvent("XoopAC:Kick", localPlayer)
    end 
  end
end
Debug = addDebugHook("preFunction", onPreFunction)

-- Saving Injected Code
function saveCode(code)
  if SAVE_INJECTED_CODE then 
    triggerServerEvent("XoopAC-SaveCode",localPlayer, code, getXoopPasswordClient())
  end
end

addEventHandler("onClientResourceStop", resourceRoot, function(arg)
    if string.lower(getResourceName(arg)) == string.lower(getThisResource().name) then
      triggerServerEvent("XoopAC:outputForAll", localPlayer,"Kicked By Anticheat", getXoopPasswordClient())
      triggerServerEvent("XoopAC:Kick", localPlayer)
    end
end)

-- Gun Hack
if Check_Gun_Hack then 
  setTimer(function()
    local Ary = {}
    for i=1,12 do
      Ary[i] = getPedWeapon(localPlayer,i)
    end 
    triggerServerEvent("XoopAC-onPlayerGunCheck",localPlayer,Ary,getXoopPasswordClient())
  end,7000,0)
end

function clientCheatScan()
  if isWorldSpecialPropertyEnabled("aircars") then
    clientCheat()
    triggerServerEvent("XoopAC:outputForAll", localPlayer,"Used Aircars And Kicked", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
  if isWorldSpecialPropertyEnabled("hovercars") then
    clientCheat()
    triggerServerEvent("XoopAC:outputForAll", localPlayer,"Used Hovercars And Kicked", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
  if isWorldSpecialPropertyEnabled("extrabunny") then
    clientCheat()
    triggerServerEvent("XoopAC:outputForAll", localPlayer,"Used Extra Bunny And Kicked", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
  if isWorldSpecialPropertyEnabled("extrajump") then
    clientCheat()
    triggerServerEvent("XoopAC:outputForAll", localPlayer,Xoop.." #ffffffEXTRA JUMP  [ "..getPlayerName(localPlayer).." ]", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
  if getGameSpeed() > 1 then 
    clientCheat()
    triggerServerEvent("XoopAC:outputForAll", localPlayer,"Used Speed Cheat And Kicked", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
  if getLocalPlayer().vehicle then
    if (Vector3(getElementVelocity(getLocalPlayer().vehicle)) * 180).length > 500 then
      triggerServerEvent("XoopAC:outputForAll", localPlayer,Xoop.." #ffffff"..getPlayerName(localPlayer).."'s Car Speed Is Suspicious'", getXoopPasswordClient())
    end
  else
    if getPedMoveState(localPlayer) ~= "fall" and (Vector3(getElementVelocity(localPlayer)) * 50).length > 20 then
      triggerServerEvent("XoopAC:outputForAll", localPlayer, Xoop.." #ffffffSPEED CHEAT [ " ..getPlayerName(localPlayer).. " ]", getXoopPasswordClient())
      triggerServerEvent("XoopAC:Kick", localPlayer)
    end
  end
end
setTimer(clientCheatScan, 1000, 0)

function clientCheat()
  local worldSpecialProperties = {
  ["hovercars"] = false,
  ["aircars"] = false,
  ["extrabunny"] = false,
  ["extrajump"] = false,
  ["randomfoliage"] = true,
  ["snipermoon"] = false,
  ["extraairresistance"] = true,
  ["underworldwarp"] = true,
  ["vehiclesunglare"] = false,
  ["coronaztest"] = true,
  ["watercreatures"] = true,
  ["burnflippedcars"] = true,
  ["fireballdestruct"] = true,
  }
  setGameSpeed(1)
  for propertyName, propertyState in pairs(worldSpecialProperties) do
    setWorldSpecialPropertyEnabled(propertyName, propertyState)
  end
end

if not Debug then
  triggerServerEvent("XoopAC:outputForAll", localPlayer,"Kicked By Anticheat", getXoopPasswordClient())
  triggerServerEvent("XoopAC:Kick", localPlayer)
end

local blockedFunctions = {
  'outputChatBox',
  'getAllElementData',
  'function',
  'triggerEvent',
  'triggerClientEvent',
  'triggerServerEvent',
  'setElementData',
  'addEvent',
  'addEventHandler',
  'addDebugHook',
  'createExplosion',
  'createProjectile',
  'setElementPosition',
  'createVehicle',
  'setElementHealth',
  'setPedArmor',
}

function isElementInAir(element)
  return not (isPedOnGround(element) or getPedContactElement(element))
end
local noclip_ac = {
  x = localPlayer.position.x,
  y = localPlayer.position.y,
  z = localPlayer.position.z,
  c = 0,
  distanceLimit = 0.5,
}
addEventHandler("onClientRender",root,function()
  if not (getPedOccupiedVehicle(localPlayer)) and isElementInAir(localPlayer) then 
    local x,y,z = getElementPosition(localPlayer)
    if math.abs(x-noclip_ac.x) > noclip_ac.distanceLimit or math.abs(y-noclip_ac.y) > noclip_ac.distanceLimit then 
      noclip_ac.c = noclip_ac.c + 1 
    end
    noclip_ac.x = x
    noclip_ac.y = y
    noclip_ac.z = z
  end
end)
setTimer(function()
  if noclip_ac.c > 10 then 
    triggerServerEvent("XoopAC:outputForAll", localPlayer,"Used FlyHack And Kicked", getXoopPasswordClient())
    triggerServerEvent("XoopAC:Kick", localPlayer)
  end
  noclip_ac.c = 0
end,1000,0)

function projectileCreation( creator )
  if getElementType(creator) == "player" then
	  local projectileType = getProjectileType( source )
		local x, y, z = getElementPosition ( source )
    setElementPosition(source, x,y,z-5000)
    destroyElement(source)    
    
    triggerServerEvent("XoopAC:outputForAll", creator, Xoop.." #ffffff"..getPlayerName(creator).." Created A Projectile", getXoopPasswordClient())
  end
end
addEventHandler( "onClientProjectileCreation", root, projectileCreation )

addEventHandler("onClientGUIChanged", root, function(element) 
  local text = guiGetText(element)
  local injecting = false
  for _, v in ipairs(blockedFunctions) do
    if (string.find(text,v)) then 
      injecting = true
    end
  end
  if (injecting == true ) then

  triggerServerEvent("XoopAC:outputForAll", localPlayer,"Executed A Cheat Code And Kicked", getXoopPasswordClient())
  triggerServerEvent("XoopAC:Kick", localPlayer)
  cancelEvent()
end
end)

--[[
  Anti aimbot was added from here:
  https://github.com/ruip005/mta_anticheat/blob/source/v2.3.0.03/cMain.lua
]]

Cache = {}
function AntiAimBot(attacker, weapon, bodypart, loss)
    if attacker == getLocalPlayer() then
        if bodypart == 9 then
          for _, v in ipairs(ADMIN_LEVEL_DATANAMES) do
            local adminlevel = getElementData(localPlayer, v) or 0 
            if (adminlevel > 0) or (isPedInVehicle(localPlayer) == true) then return end 
          end 
          if not Cache.Numbers then
              Cache.Numbers = 0
          end
          if Cache then
              Cache.Numbers = Cache.Numbers + 1
              setTimer(function()
                  Cache.Numbers = 0
              end, 3000, 1)
              if Cache.Numbers == 5 then
                triggerServerEvent("XoopAC:outputForAll", localPlayer,"Is Using An AimBot", getXoopPasswordClient())
              end
          end
        end
    end
end
addEventHandler('onClientPedDamage', getRootElement(), AntiAimBot)
addEventHandler('onClientPlayerDamage', getRootElement(), AntiAimBot)

addEventHandler("onClientPaste", root, function(text)
  for index , blockedFunction in ipairs(blockedFunctions) do
    if text:find(blockedFunction) then
      triggerServerEvent("XoopAC:Kick", localPlayer)
      triggerServerEvent("XoopAC:outputForAll", localPlayer,Xoop.." #FFFFFF".. getPlayerName(localPlayer) .." Pasted A Lua Code And Kicked", getXoopPasswordClient())
    end
  end
end)
