Config = {}

Config.BenchModel = 'prop_tool_bench02_ld' -- Bench model.

Config.isDisc = false -- if you use disc set true

Config.Crafts = {
    ['Craft1'] = { 
        coords = vector3(461.08, -981.27, 29.69), -- Posistion of crafting.
        heading = 30, -- Heading of bench.
        msg = 'Press [E] for crafting', -- Text of 3DDrawText.
    },
}

Config.CraftItems = {
    ['Telefon'] = { 
        item = {name = "WEAPON_PISTOL", count = 5}, -- Crafted Item
        minRep = 100, -- Minumum rep for crafting item
        giveRep = 50, -- That number will gived to you craft when you craft (Respect)
        dependencies = {
        [1] = {item = "water", count = 1}, -- Slot 1, item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [2] = nil, -- Slot 2 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [3] = nil, -- Slot 3 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [4] = nil, -- Slot 4 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [5] = nil, -- Slot 5 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [6] = nil, -- Slot 6 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [7] = nil, -- Slot 7, item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [8] = nil, -- Slot 8 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        [9] = {item = "disc_ammo_pistol", count = 1}, -- Slot 9 item is name of your item, count is your count of your item (if is nil slot will be accepted empty).
        },
    },
}
