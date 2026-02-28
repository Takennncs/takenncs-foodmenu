local TK = nil

CreateThread(function()
    while TK == nil do
        TK = exports['takenncs-lib']
        if TK then
        else
            Wait(100)
        end
    end
end)

CreateThread(function()
    for _, zone in pairs(Config.TargetZones) do
        exports.ox_target:addBoxZone({
            coords = zone.coords,
            size = vec3(zone.length, zone.width, 2),
            rotation = zone.heading,
            debug = false,
            options = {
                {
                    name = zone.options[1].name,
                    icon = zone.options[1].icon,
                    label = zone.options[1].label,
                    onSelect = function()
                        TriggerEvent('food_menu:openMenu')
                    end
                }
            }
        })
    end
end)

local function registerMenu(id, title, options)
    if not TK then return end
    TK:registerContext({
        id = id,
        title = title,
        position = 'top-right',
        canClose = true,
        options = options
    })
end

local function showMenu(id)
    if not TK then return end
    TK:showContext(id)
end

local function hideMenu(onExit)
    if not TK then return end
    TK:hideContext(onExit)
end

local function getItemImage(itemName)
    return Config.ImageSettings.basePath .. itemName .. Config.ImageSettings.extension
end

RegisterNetEvent('food_menu:openMenu', function()
    if not TK then
        return
    end

    local categories = {
        drinks = {
            title = "Joogid",
            items = {}
        },
        food = {
            title = "Söögid",
            items = {}
        }
    }

    for _, v in ipairs(Config.Items) do
        if v.category == "drinks" then
            table.insert(categories.drinks.items, v)
        elseif v.category == "food" then
            table.insert(categories.food.items, v)
        end
    end

    local mainMenuId = "food_main_menu"

    local mainOptions = {}

    if #categories.drinks.items > 0 then
        local drinksMenuId = "food_drinks_menu"

        local drinkOptions = {}
        for _, item in ipairs(categories.drinks.items) do
            table.insert(drinkOptions, {
                title = item.label,
                description = "Hind: $" .. item.price,
                image = getItemImage(item.item),
            })
        end

        registerMenu(drinksMenuId, "🥤 " .. categories.drinks.title, drinkOptions)

        table.insert(mainOptions, {
            title = "🥤 " .. categories.drinks.title,
            description = "Vali jook (" .. #categories.drinks.items .. ")",
            menu = drinksMenuId
        })
    end

    if #categories.food.items > 0 then
        local foodMenuId = "food_food_menu"

        local foodOptions = {}
        for _, item in ipairs(categories.food.items) do
            table.insert(foodOptions, {
                title = item.label,
                description = "Hind: $" .. item.price,
                image = getItemImage(item.item),
            })
        end

        registerMenu(foodMenuId, "🍔 " .. categories.food.title, foodOptions)

        table.insert(mainOptions, {
            title = "🍔 " .. categories.food.title,
            description = "Vali toit (" .. #categories.food.items .. ")",
            menu = foodMenuId
        })
    end

    registerMenu(mainMenuId, "🍽️ Toidumenüü", mainOptions)
    showMenu(mainMenuId)
end)