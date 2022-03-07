ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- KONFIGURISI SVOJE ADMIN GRUPE

local Permisije = {
    ["admin"] = false,
    ["superadmin"] = true,
    ["developer"] = true
}

RegisterCommand('dajpeda', function(source, args)
local args1 = tonumber(args[1])
local modelpeda = table.concat(args, " ", 2)
local xAdmin = ESX.GetPlayerFromId(source)
local grupa = xAdmin.getGroup()
local xIgrac = ESX.GetPlayerFromId(args1)
if Permisije[grupa] then
    if xIgrac then
        MySQL.Async.fetchScalar("SELECT * FROM ped_system WHERE identifier = @identifier",
        {["@identifier"] = xIgrac.identifier},
        function(result)
            if result == nil then
            MySQL.Async.fetchAll("INSERT INTO ped_system (identifier, IME, hash) VALUES (@identifier, @IME, @hash)",
            {["@identifier"] = xIgrac.identifier, ["@IME"] = GetPlayerName(args1), ["@hash"] = modelpeda},
            function(result)
                TriggerClientEvent('janjusevic_pedsystem:setujPeda', xIgrac.source, modelpeda)
                TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Uspesno sacuvano u data bazu!")
            end)   
            else
            TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Navedeni igrac vec poseduje peda u data bazi!")
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Navedeni igrac nije online!")
    end
else
    TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Nemas permisije za koriscenje ove komande!")
end
end)

RegisterCommand('obrisipeda', function(source, args)
local args1 = tonumber(args[1])
local xIgrac = ESX.GetPlayerFromId(args1)
local xAdmin = ESX.GetPlayerFromId(source)
local grupa = xAdmin.getGroup()
if Permisije[grupa] then
    if xIgrac then
        MySQL.Async.fetchScalar("SELECT * FROM ped_system WHERE identifier = @identifier",
        {["@identifier"] = xIgrac.identifier},
        function(result)
            if result == nil then
            TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Ovaj igrac ne poseduje peda u data bazi!")
            else
            MySQL.Async.fetchAll("DELETE FROM ped_system WHERE identifier = @identifier",
            {["@identifier"] = xIgrac.identifier},
            function(result)
               TriggerClientEvent('janjusevic_pedsystem:setujPeda', xIgrac.source, 'mp_m_freemode_01')
               TriggerClientEvent('janjusevic_pedsystem:loadujSkin', xIgrac.source)
                TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Uspesno uklonjeno iz data baze!")
            end)   
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Navedeni igrac nije online!")
    end
else
    TriggerClientEvent('chatMessage', source, "^1[SYSTEM] ^0Nemas permisije za koriscenje ove komande!")
end
end)

RegisterNetEvent('janjusevic_pedsystem:proveriPeda')
AddEventHandler('janjusevic_pedsystem:proveriPeda', function(igrac)
local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchScalar("SELECT * FROM ped_system WHERE identifier = @identifier",
    {["@identifier"] = xPlayer.identifier},
    function(result)
        if result == nil then
        print('[ janjusevic_pedsystem ] Igrac ne poseduje peda u data baazi') 
        else
        MySQL.Async.fetchAll("SELECT * FROM ped_system WHERE identifier = @identifier",
        {["@identifier"] = xPlayer.identifier},
        function(result)
            --print('provereno hash je ' .. result[1].hash)
            TriggerClientEvent('janjusevic_pedsystem:setujPeda', xPlayer.source, result[1].hash)
            print('[ janjusevic_pedsystem ] Uspesno je loadovan ped ' .. result[1].hash)
        end)
        end
    end)
end)
