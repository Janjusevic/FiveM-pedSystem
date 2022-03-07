ESX = nil

Citizen.CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end end)
spawnovan = false

RegisterNetEvent('janjusevic_pedsystem:setujPeda')
AddEventHandler('janjusevic_pedsystem:setujPeda', function(modelpeda)
--print('hash je '.. modelpeda)
local model = modelpeda
if IsModelInCdimage(model) and IsModelValid(model) then
  RequestModel(model)
  while not HasModelLoaded(model) do
    Citizen.Wait(0)
  end
  SetPlayerModel(PlayerId(), model)
  SetModelAsNoLongerNeeded(model)
end   
end)

RegisterNetEvent("janjusevic_pedsystem:loadujSkin")
AddEventHandler("janjusevic_pedsystem:loadujSkin", function()
  TriggerEvent('skinchanger:loadDefaultModel', 0, function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
        TriggerEvent('esx:restoreLoadout')
    end)
  end)
end)

AddEventHandler('esx:onPlayerSpawn', function()
	spawnovan = true 
	if spawnovan then 
    Citizen.Wait(5000)
		TriggerServerEvent("janjusevic_pedsystem:proveriPeda", PlayerPedId()) 
	else
		--print('a')
	end
end)
