
ESX = nil
local craftItems = {
	[1] = nil,
	[2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil,
    [9] = nil,
    [10] = nil,
    
}

local dependencies = {}

local inCraft = false
local lastCraft = {}
local tables = {}
 
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

function isWeapon(item)
		if string.match(item, 'WEAPON_')then
			return true
		end
	return false
end

RegisterCommand('craftfix', function()
    closeCrafting()
end)

function closeCrafting()
    SendNUIMessage({
        action = "hide"
    })
    SetNuiFocus(false, false)
    inCraft = false
    craftItems = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
        
    }
    items = {}
end

RegisterNUICallback("closeCrafting", function()
    closeCrafting()
end)

Citizen.CreateThread( function()
    Citizen.Wait(2000)
    while true do
    wait = 2000
            local playerPed = PlayerPedId()
            local pcoords = GetEntityCoords(playerPed)
            for k, v in pairs(Config.Crafts) do
                local distance = GetDistanceBetweenCoords(pcoords.x, pcoords.y, pcoords.z, v.coords.x, v.coords.y, v.coords.z, true)
                    if distance < 15.0 then
                        wait = 0
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 100, false, true, 2, true, false, false, false)
                        if distance < 1.5 then
                            DrawText3D(v.coords.x, v.coords.y, v.coords.z +1.2 + 0.3, 0.35, v.msg)
                            if IsControlJustPressed(0, 38) and not inCraft then
                                OpenCraft()
                            end
                        end                   
                    end
                end
            Citizen.Wait(wait)
        end
end)

Citizen.CreateThread( function()
     for k, v in pairs(Config.Crafts) do
            local hash = GetHashKey(Config.BenchModel)
            RequestModel(hash)

            while not HasModelLoaded(hash) do 
            RequestModel(hash)
            Citizen.Wait(0)
            end  

            local Bench = CreateObject(hash, v.coords.x, v.coords.y, v.coords.z, false,false,false)
            SetEntityHeading(Bench, v.heading)
            SetEntityAsMissionEntity(Bench, true, true)
            FreezeEntityPosition(Bench, true)
            table.insert(tables, Bench)
            SetModelAsNoLongerNeeded(hash)
     end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(tables) do
            DeleteObject(v)
            DeleteEntity(v)
        end
	end
end)

RegisterNUICallback("refreshCraft", function(data, cb)
    craftItems = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
        
    }
    inCraft = false
    OpenCraft()
    cb("ok")
end)


RegisterNUICallback("TakeFromCrafted", function(data, cb)
    craftItems = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
        [4] = nil,
        [5] = nil,
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
    }
    inCraft = false
    items = {}
    TriggerServerEvent('luck-crafting:server:CraftItem', lastCraft)
    OpenCraft()
    cb("ok")
end)

RegisterNetEvent('luck-crafting:client:openCraft')
AddEventHandler('luck-crafting:client:openCraft', function()
    OpenCraft()
end)

CheckCraft = function(name)
    for k, v in pairs(Config.CraftItems) do
        if equal(v.dependencies) then
            ESX.TriggerServerCallback("luck-crafting:server:getReputation", function(rep)
                if rep >= v.minRep then
                   ESX.TriggerServerCallback("luck-crafting:server:getItemLabel", function(name)
                    v.text = name
                     SendNUIMessage({
                         action = "setCraftItem",
                         item = v,
                     })
                     lastCraft = v
                   end, v.item.name)
                end
            end)
        end
    end
end


equal = function(table)
    for i = 1,9 do
        if table[i] == nil and craftItems[i] ~= nil then
            return false
        elseif table[i] ~= nil and craftItems[i] == nil then   
            return false
        elseif table[i] ~= nil then
            if table[i].item ~= craftItems[i].name then
              return false
            elseif table[i].count ~= craftItems[i].count then
              return false
            end
        end
    end
    return true
end


OpenCraft = function(name)
    if inCraft then
        SendNUIMessage({
            action = "setItems",
            itemList = items,
            craftItems = craftItems,
        })
        CheckCraft()
        inCraft = true
    else
        ESX.TriggerServerCallback("luck-crafting:server:GetPlayerInventory", function(data)
            ESX.TriggerServerCallback("luck-crafting:server:getCharacterName", function(charname)
                ESX.TriggerServerCallback("luck-crafting:server:getReputation", function(rep)
                   inventory = data
                   inCraft = true
                   items = {}
                   SetNuiFocus(true, true)
                   SendNUIMessage({
                       action = "display",
                       text = charname .. ' [' .. GetPlayerServerId(PlayerId()) .. '] Beceri: ' .. rep
                   })
                   
                   for i=1, #inventory, 1 do
                       if inventory[i].count > 0 and not isWeapon(inventory[i].name) then
                           table.insert(items, inventory[i])
                       end
                   end
                   
                   SendNUIMessage({
                       action = "setItems",
                       itemList = items,
                       craftItems = craftItems,
                   })
               end)
           end)
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if inCraft then
            DisableAllControlActions(0)
            EnableControlAction(0, 47, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
        end
    end
end)


RegisterNUICallback("PutIntoCraft", function(data, cb)
    local maxAmount
    local doThing = true

    if data.number ~= nil then
       if data.number == 0 then
         data.number = data.item.count
       elseif data.number > data.item.count then
         data.number = data.item.count
       else
         data.number = data.number
       end
    end

    if craftItems[data.slot] ~= nil then
        if data.item.name == craftItems[data.slot].name then
            data.number = craftItems[data.slot].count + data.number
        else
             doThing = false
        end
    end

    if data.item.slot ~= nil then
        if data.item.name == craftItems[data.item.slot].name then
            if craftItems[data.item.slot].count - data.number <= 0 then
              craftItems[data.item.slot] = nil  
            else
              craftItems[data.item.slot].count = craftItems[data.item.slot].count - data.number
            end
        else
            doThing = false
        end
    end
    
   for i=1, #items, 1 do
        if data.item.slot == nil then
            if items[i] ~= nil then
               if data.item.name == items[i].name then
                 if doThing then
                    items[i].count = items[i].count - data.number
                    if items[i].count <= 0 then
                      items[i] = nil
                    end
                 end
              end
           end 
        end
    end

    if craftItems[data.item.slot] ~= nil then
        if data.number > craftItems[data.item.slot].count then
           data.number = craftItems[data.item.slot].count
        end
    end

    if doThing then
       data.item.count = data.number 
       craftItems[data.slot] = data.item
       craftItems[data.slot].slot = data.slot
    end


    OpenCraft()
    cb("ok")
end)

DrawText3D = function(x, y, z, scale, text)
	local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(8)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropshadow(0)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 195
	end
end
    









