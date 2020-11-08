Config = {}

Config.BenchModel = 'prop_tool_bench02_ld' -- Bench modeli.

Config.isDisc = false -- Disc kullanıyorsanız bunu true yapınız.

Config.Crafts = {
    ['Craft1'] = { 
        coords = vector3(461.08, -981.27, 29.69), -- Craft sisteminin yeri.
        heading = 30, -- Crafting Bench'in açısı.
        msg = 'Craftlamak için [E]', -- 3D text içerisinde çıkacak yazı.
    },
}

Config.CraftItems = {
    ['Telefon'] = { 
        item = {name = "WEAPON_PISTOL", count = 5}, -- Count eşyasa eşyanın sayısını silahsa mersini belirler. (Disc için her türlü eşya veya silahın sayısını belirler.)
        minRep = 100, -- Gereken beceriyi belirler.
        giveRep = 50, -- Eşya craftlandığında verilecek beceriyi belirler
        dependencies = {
        [1] = {item = "water", count = 1}, -- Slot 1, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [2] = nil, -- Slot 2, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [3] = nil, -- Slot 3, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [4] = nil, -- Slot 4, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [5] = nil, -- Slot 5, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [6] = nil, -- Slot 6, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [7] = nil, -- Slot 7, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [8] = nil, -- Slot 8, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        [9] = {item = "disc_ammo_pistol", count = 1}, -- Slot 9, item eşyanın ismi count ise kaç tane gerektiği (nil koyarsanız slotun boş olması gerektiğini tanımlatırsınız.).
        },
    },
}
