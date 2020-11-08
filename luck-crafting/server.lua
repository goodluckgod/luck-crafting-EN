ESX = nil
local craft = {}

local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/766746299025850428/eaz1zCkoiIL7yAo1y-082jS5_3QzVQrKOZAbRN37ncy48Vf6rTbzuR67SI75A4POUY2S"
local DISCORD_NAME = GetCurrentResourceName() 
local DISCORD_IMAGE = "https://i.hizliresim.com/uhJ4s3.gif"


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("luck-crafting:server:GetPlayerInventory",function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
	    cb(xPlayer.inventory)
	else
		cb(nil)
	end
end)

function isWeapon(item)
    if string.match(item, 'WEAPON_')then
        return true
    end
return false
end

ESX.RegisterServerCallback('luck-crafting:server:getCharacterName', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname

    cb(''.. firstname .. ' ' .. lastname ..'')
end)

ESX.RegisterServerCallback('luck-crafting:server:getReputation', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll("SELECT * FROM luck_crafting WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    })
    if result[1] then
    local rep = result[1].reputation
    cb(rep)
    else
        MySQL.Async.insert('INSERT INTO `luck_crafting` (`identifier`, `reputation`) VALUES (@identifier, @reputation)', {
            ['@identifier'] = xPlayer.identifier,
            ['@reputation'] = 0
        })
        rep = 0
        cb(rep)
    end
end)

ESX.RegisterServerCallback('luck-crafting:server:getItemLabel', function(source, cb, item)
    local itemname = ESX.GetItemLabel(item)
    if itemname == nil then
    cb("HATA")
    else
    cb(itemname)
    end
end)

function DiscordHook(name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
			  ["text"] = os.date('!%Y-%m-%d - %H:%M:%S') .. " / god of luck",
			  },
		  }
      }
	PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end


RegisterServerEvent('luck-crafting:server:CraftItem')
AddEventHandler('luck-crafting:server:CraftItem', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.isDisc == false then
    xPlayer.addInventoryItem(data.item.name, data.item.count) 
    else
    xPlayer.addInventoryItem(data.item.name, data.item.count)
    end
    local rep
    local result = MySQL.Sync.fetchAll("SELECT * FROM luck_crafting WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    })
    rep = result[1].reputation + data.giveRep
    MySQL.Async.execute('UPDATE `luck_crafting` SET `reputation` = @reputation WHERE `identifier` = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@reputation'] = rep
    })
    DiscordHook(xPlayer.name .. " " .. data.item.name .. " craftladı!", " **"..xPlayer.identifier.."**  **" .. xPlayer.name .. "** kişisi **"..data.item.count .."** adet **"..data.item.name.."** oluşturdu Yeni beceri: **"..rep.."**", 2003199)
	for i = 1,9 do
	    if data.dependencies[i] ~= nil then
	     xPlayer.removeInventoryItem( data.dependencies[i].item, data.dependencies[i].count)
	    end
    end
    TriggerClientEvent("luck-crafting:client:openCraft", source)
end)
