local FoltoneClothesShop = {
    Timout = false,
    PlayerClothes = {},
    OptionsList = { _U("put_on"), _U("rename"), _U("delete") }, OptionsIndex = 1,
    Tshirt1List = {}, Tshirt1Index = 1, Tshirt2List = {}, Tshirt2Index = 1, LastTshirt1Index = 1,
    Torso1List = {}, Torso1Index = 1, Torso2List = {}, Torso2Index = 1, LastTorso1Index = 1,
    Decals1List = {}, Decals1Index = 1, Decals2List = {}, Decals2Index = 1, LastDecals1Index = 1,
    Bproof1List = {}, Bproof1Index = 1, Bproof2List = {}, Bproof2Index = 1, LastBproof1Index = 1,
    Bags1List = {}, Bags1Index = 1, Bags2List = {}, Bags2Index = 1, LastBags1Index = 1,
    Chain1List = {}, Chain1Index = 1, Chain2List = {}, Chain2Index = 1, LastChain1Index = 1,
    Arms1List = {}, Arms1Index = 1, Arms2List = {}, Arms2Index = 1, LastArms1Index = 1,
    Pants1List = {}, Pants1Index = 1, Pants2List = {}, Pants2Index = 1, LastPants1Index = 1,
    Shoes1List = {}, Shoes1Index = 1, Shoes2List = {}, Shoes2Index = 1, LastShoes1Index = 1,
    Bracelets1List = {}, Bracelets1Index = 1, Bracelets2List = {}, Bracelets2Index = 1, LastBracelets1Index = 1,
    Watches1List = {}, Watches1Index = 1, Watches2List = {}, Watches2Index = 1, LastWatches1Index = 1,
    Helmet1List = {}, Helmet1Index = 1, Helmet2List = {}, Helmet2Index = 1, LastHelmet1Index = 1,
    Glasses1List = {}, Glasses1Index = 1, Glasses2List = {}, Glasses2Index = 1, LastGlasses1Index = 1,
    Ears1List = {}, Ears1Index = 1, Ears2List = {}, Ears2Index = 1, LastEars1Index = 1,
    Mask1List = {}, Mask1Index = 1, Mask2List = {}, Mask2Index = 1, LastMask1Index = 1
}

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end
local function setTimout(time)
    FoltoneClothesShop.Timout = true
    Citizen.SetTimeout(time, function()
        FoltoneClothesShop.Timout = false
    end)
end

ESX = exports["es_extended"]:getSharedObject()

local function loadSkin()
    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)
end
local function generateList(startIndex, endIndex, targetTable)
    if endIndex == 0 or endIndex == nil then
        endIndex = 1
    end
    for i = startIndex, endIndex - 1 do
        table.insert(targetTable, i)
    end
end
local function getLists()
    local playerPed = PlayerPedId()
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 8), FoltoneClothesShop.Tshirt1List) -- Tshirt1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 8, FoltoneClothesShop.Tshirt1Index - 1), FoltoneClothesShop.Tshirt2List) -- Tshirt2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 11), FoltoneClothesShop.Torso1List) -- Torso1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 11, FoltoneClothesShop.Torso1Index - 1), FoltoneClothesShop.Torso2List) -- Torso2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 10), FoltoneClothesShop.Decals1List) -- Decals1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 10, FoltoneClothesShop.Decals1Index - 1), FoltoneClothesShop.Decals2List) -- Decals2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 9), FoltoneClothesShop.Bproof1List) -- Bproof1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 9, FoltoneClothesShop.Bproof1Index - 1), FoltoneClothesShop.Bproof2List) -- Bproof2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 5), FoltoneClothesShop.Bags1List) -- Bags1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 5, FoltoneClothesShop.Bags1Index - 1), FoltoneClothesShop.Bags2List) -- Bags2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 7), FoltoneClothesShop.Chain1List) -- Chain1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 7, FoltoneClothesShop.Chain1Index - 1), FoltoneClothesShop.Chain2List) -- Chain2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 3), FoltoneClothesShop.Arms1List) -- Arms1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 3, FoltoneClothesShop.Arms1Index - 1), FoltoneClothesShop.Arms2List) -- Arms2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 4), FoltoneClothesShop.Pants1List) -- Pants1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 4, FoltoneClothesShop.Pants1Index - 1), FoltoneClothesShop.Pants2List) -- Pants2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 6), FoltoneClothesShop.Shoes1List) -- Shoes1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 6, FoltoneClothesShop.Shoes1Index - 1), FoltoneClothesShop.Shoes2List) -- Shoes2
    generateList(0, GetNumberOfPedDrawableVariations(playerPed, 1), FoltoneClothesShop.Mask1List) -- Mask1
    generateList(0, GetNumberOfPedTextureVariations(playerPed, 1, FoltoneClothesShop.Mask1Index - 1), FoltoneClothesShop.Mask2List) -- Mask2
    generateList(-1, GetNumberOfPedPropDrawableVariations(playerPed, 7), FoltoneClothesShop.Bracelets1List) -- Bracelets1
    generateList(0, GetNumberOfPedPropTextureVariations(playerPed, 7, FoltoneClothesShop.Bracelets1Index - 1), FoltoneClothesShop.Bracelets2List) -- Bracelets2
    generateList(-1, GetNumberOfPedPropDrawableVariations(playerPed, 6), FoltoneClothesShop.Watches1List) -- Watches1
    generateList(0, GetNumberOfPedPropTextureVariations(playerPed, 6, FoltoneClothesShop.Watches1Index - 1), FoltoneClothesShop.Watches2List) -- Watches2
    generateList(-1, GetNumberOfPedPropDrawableVariations(playerPed, 1), FoltoneClothesShop.Glasses1List) -- Glasses1
    generateList(0, GetNumberOfPedPropTextureVariations(playerPed, 1, FoltoneClothesShop.Glasses1Index - 1), FoltoneClothesShop.Glasses2List) -- Glasses2
    generateList(-1, GetNumberOfPedPropDrawableVariations(playerPed, 0), FoltoneClothesShop.Helmet1List) -- Helmet1
    generateList(0, GetNumberOfPedPropTextureVariations(playerPed, 0, FoltoneClothesShop.Helmet1Index - 1), FoltoneClothesShop.Helmet2List) -- Helmet2
    generateList(-1, GetNumberOfPedPropDrawableVariations(playerPed, 2), FoltoneClothesShop.Ears1List) -- Ears1
    generateList(0, GetNumberOfPedPropTextureVariations(playerPed, 2, FoltoneClothesShop.Ears1Index - 1), FoltoneClothesShop.Ears2List) -- Ears2
end
local function getPlayerClothe()
    local playerPed = PlayerPedId()
    local clothe = {
        ["tshirt_1"] = GetPedDrawableVariation(playerPed, 8),
        ["tshirt_2"] = GetPedTextureVariation(playerPed, 8),
        ["torso_1"] = GetPedDrawableVariation(playerPed, 11),
        ["torso_2"] = GetPedTextureVariation(playerPed, 11),
        ["decals_1"] = GetPedDrawableVariation(playerPed, 10),
        ["decals_2"] = GetPedTextureVariation(playerPed, 10),
        ["bproof_1"] = GetPedDrawableVariation(playerPed, 9),
        ["bproof_2"] = GetPedTextureVariation(playerPed, 9),
        ["bags_1"] = GetPedDrawableVariation(playerPed, 5),
        ["bags_2"] = GetPedTextureVariation(playerPed, 5),
        ["chain_1"] = GetPedDrawableVariation(playerPed, 7),
        ["chain_2"] = GetPedTextureVariation(playerPed, 7),
        ["arms"] = GetPedDrawableVariation(playerPed, 3),
        ["arms_2"] = GetPedTextureVariation(playerPed, 3),
        ["pants_1"] = GetPedDrawableVariation(playerPed, 4),
        ["pants_2"] = GetPedTextureVariation(playerPed, 4),
        ["shoes_1"] = GetPedDrawableVariation(playerPed, 6),
        ["shoes_2"] = GetPedTextureVariation(playerPed, 6),
        ["mask_1"] = GetPedDrawableVariation(playerPed, 1),
        ["mask_2"] = GetPedTextureVariation(playerPed, 1),
        ["ears_1"] = GetPedPropIndex(playerPed, 2),
        ["ears_2"] = GetPedPropTextureIndex(playerPed, 2),
        ["glasses_1"] = GetPedPropIndex(playerPed, 1),
        ["glasses_2"] = GetPedPropTextureIndex(playerPed, 1),
        ["helmet_1"] = GetPedPropIndex(playerPed, 0),
        ["helmet_2"] = GetPedPropTextureIndex(playerPed, 0),
        ["watches_1"] = GetPedPropIndex(playerPed, 6),
        ["watches_2"] = GetPedPropTextureIndex(playerPed, 6),
        ["bracelets_1"] = GetPedPropIndex(playerPed, 7),
        ["bracelets_2"] = GetPedPropTextureIndex(playerPed, 7)
    }
    return clothe
end
local function setClothe(clothe)
    local playerPed = PlayerPedId()
    for k, v in pairs(clothe) do
        TriggerEvent("skinchanger:change", k, v)
    end
    TriggerEvent("skinchanger:getSkin", function(skin)
        TriggerServerEvent("esx_skin:save", skin)
    end)
end

local function closeMenu()
    FoltoneClothesShop.OptionsIndex = 1
    RageUI.GoBack()
    RageUI.CloseAll()
    loadSkin()
end
local menuClothesShop = RageUI.CreateMenu("", _U("menu_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local menuCreateClothes = RageUI.CreateSubMenu(menuClothesShop, "", _U("create_clothes_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local saveClothes = RageUI.CreateSubMenu(menuClothesShop, "", _U("save_clothes_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local openClothesShop = false
local menuHelmet = RageUI.CreateMenu("", _U("menu_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local openHelmet = false
local menuGlasses = RageUI.CreateMenu("", _U("menu_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local openGlasses = false
local menuEars = RageUI.CreateMenu("", _U("menu_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local openEars = false
local menuMask = RageUI.CreateMenu("", _U("menu_subtitle"), nil, nil, Config.BannerDictionary, Config.BannerName);
local openMask = false
function RageUI.PoolMenus:FoltoneClothesShop()
    function menuClothesShop.Closed()
        openClothesShop = false
        closeMenu()
    end
    function menuHelmet.Closed()
        openHelmet = false
        closeMenu()
    end
    function menuGlasses.Closed()
        openGlasses = false
        closeMenu()
    end
    function menuEars.Closed()
        openEars = false
        closeMenu()
    end
    function menuMask.Closed()
        openMask = false
        closeMenu()
    end

    menuClothesShop:IsVisible(function(Items)
        Items:AddButton(_U("create_clothes_subtitle"), nil, { RightLabel = ">", IsDisabled = FoltoneClothesShop.Timout }, function(onSelected)
            if (onSelected) then
                RageUI.NextMenu = menuCreateClothes
            end
        end)
        Items:AddButton(_U("save_clothes_subtitle"), nil, { RightLabel = ">", IsDisabled = FoltoneClothesShop.Timout }, function(onSelected)
            if (onSelected) then
                RageUI.NextMenu = saveClothes
            end
        end)
    end, function(Panels)
    end)
    menuCreateClothes:IsVisible(function(Items)
        Items:AddList(_U("tshirt_1"), FoltoneClothesShop.Tshirt1List, string.format("#%s", FoltoneClothesShop.Tshirt1List), FoltoneClothesShop.Tshirt1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Tshirt1Index = Index
                FoltoneClothesShop.Tshirt2Index = 1
                SetPedComponentVariation(PlayerPedId(), 8, FoltoneClothesShop.Tshirt1Index - 1, FoltoneClothesShop.Tshirt2Index - 1, 0)
            end
        end)
        Items:AddList(_U("tshirt_2"), FoltoneClothesShop.Tshirt2List, string.format("#%s", FoltoneClothesShop.Tshirt2List), FoltoneClothesShop.Tshirt2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastTshirt1Index ~= FoltoneClothesShop.Tshirt1Index then
                FoltoneClothesShop.LastTshirt1Index = FoltoneClothesShop.Tshirt1Index
                local Tshirt2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 8, FoltoneClothesShop.Tshirt1Index - 1) - 1
                FoltoneClothesShop.Tshirt2List = {}
                generateList(0, Tshirt2Count, FoltoneClothesShop.Tshirt2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Tshirt2Index = Index
                SetPedComponentVariation(PlayerPedId(), 8, FoltoneClothesShop.Tshirt1Index - 1, FoltoneClothesShop.Tshirt2Index - 1, 0)
            end
        end)
        Items:AddList(_U("torso_1"), FoltoneClothesShop.Torso1List, string.format("#%s", FoltoneClothesShop.Torso1List), FoltoneClothesShop.Torso1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Torso1Index = Index
                FoltoneClothesShop.Torso2Index = 1
                SetPedComponentVariation(PlayerPedId(), 11, FoltoneClothesShop.Torso1Index - 1, FoltoneClothesShop.Torso2Index - 1, 0)
            end
        end)
        Items:AddList(_U("torso_2"), FoltoneClothesShop.Torso2List, string.format("#%s", FoltoneClothesShop.Torso2List), FoltoneClothesShop.Torso2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastTorso1Index ~= FoltoneClothesShop.Torso1Index then
                FoltoneClothesShop.LastTorso1Index = FoltoneClothesShop.Torso1Index
                local Torso2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 11, FoltoneClothesShop.Torso1Index - 1) - 1
                FoltoneClothesShop.Torso2List = {}
                generateList(0, Torso2Count, FoltoneClothesShop.Torso2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Torso2Index = Index
                SetPedComponentVariation(PlayerPedId(), 11, FoltoneClothesShop.Torso1Index - 1, FoltoneClothesShop.Torso2Index - 1, 0)
            end
        end)
        Items:AddList(_U("decals_1"), FoltoneClothesShop.Decals1List, string.format("#%s", FoltoneClothesShop.Decals1List), FoltoneClothesShop.Decals1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Decals1Index = Index
                FoltoneClothesShop.Decals2Index = 1
                SetPedComponentVariation(PlayerPedId(), 10, FoltoneClothesShop.Decals1Index - 1, FoltoneClothesShop.Decals2Index - 1, 0)
            end
        end)
        Items:AddList(_U("decals_2"), FoltoneClothesShop.Decals2List, string.format("#%s", FoltoneClothesShop.Decals2List), FoltoneClothesShop.Decals2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastDecals1Index ~= FoltoneClothesShop.Decals1Index then
                FoltoneClothesShop.LastDecals1Index = FoltoneClothesShop.Decals1Index
                local Decals2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 10, FoltoneClothesShop.Decals1Index - 1) - 1
                FoltoneClothesShop.Decals2List = {}
                generateList(0, Decals2Count, FoltoneClothesShop.Decals2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Decals2Index = Index
                SetPedComponentVariation(PlayerPedId(), 10, FoltoneClothesShop.Decals1Index - 1, FoltoneClothesShop.Decals2Index - 1, 0)
            end
        end)
        Items:AddList(_U("bproof_1"), FoltoneClothesShop.Bproof1List, string.format("#%s", FoltoneClothesShop.Bproof1List), FoltoneClothesShop.Bproof1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Bproof1Index = Index
                FoltoneClothesShop.Bproof2Index = 1
                SetPedComponentVariation(PlayerPedId(), 9, FoltoneClothesShop.Bproof1Index - 1, FoltoneClothesShop.Bproof2Index - 1, 0)
            end
        end)
        Items:AddList(_U("bproof_2"), FoltoneClothesShop.Bproof2List, string.format("#%s", FoltoneClothesShop.Bproof2List), FoltoneClothesShop.Bproof2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastBproof1Index ~= FoltoneClothesShop.Bproof1Index then
                FoltoneClothesShop.LastBproof1Index = FoltoneClothesShop.Bproof1Index
                local Bproof2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 9, FoltoneClothesShop.Bproof1Index - 1) - 1
                FoltoneClothesShop.Bproof2List = {}
                generateList(0, Bproof2Count, FoltoneClothesShop.Bproof2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Bproof2Index = Index
                SetPedComponentVariation(PlayerPedId(), 9, FoltoneClothesShop.Bproof1Index - 1, FoltoneClothesShop.Bproof2Index - 1, 0)
            end
        end)
        Items:AddList(_U("bags_1"), FoltoneClothesShop.Bags1List, string.format("#%s", FoltoneClothesShop.Bags1List), FoltoneClothesShop.Bags1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Bags1Index = Index
                FoltoneClothesShop.Bags2Index = 1
                SetPedComponentVariation(PlayerPedId(), 5, FoltoneClothesShop.Bags1Index - 1, FoltoneClothesShop.Bags2Index - 1, 0)
            end
        end)
        Items:AddList(_U("bags_2"), FoltoneClothesShop.Bags2List, string.format("#%s", FoltoneClothesShop.Bags2List), FoltoneClothesShop.Bags2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastBags1Index ~= FoltoneClothesShop.Bags1Index then
                FoltoneClothesShop.LastBags1Index = FoltoneClothesShop.Bags1Index
                local Bags2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 5, FoltoneClothesShop.Bags1Index - 1) - 1
                FoltoneClothesShop.Bags2List = {}
                generateList(0, Bags2Count, FoltoneClothesShop.Bags2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Bags2Index = Index
                SetPedComponentVariation(PlayerPedId(), 5, FoltoneClothesShop.Bags1Index - 1, FoltoneClothesShop.Bags2Index - 1, 0)
            end
        end)
        Items:AddList(_U("chain_1"), FoltoneClothesShop.Chain1List, string.format("#%s", FoltoneClothesShop.Chain1List), FoltoneClothesShop.Chain1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Chain1Index = Index
                FoltoneClothesShop.Chain2Index = 1
                SetPedComponentVariation(PlayerPedId(), 7, FoltoneClothesShop.Chain1Index - 1, FoltoneClothesShop.Chain2Index - 1, 0)
            end
        end)
        Items:AddList(_U("chain_2"), FoltoneClothesShop.Chain2List, string.format("#%s", FoltoneClothesShop.Chain2List), FoltoneClothesShop.Chain2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastChain1Index ~= FoltoneClothesShop.Chain1Index then
                FoltoneClothesShop.LastChain1Index = FoltoneClothesShop.Chain1Index
                local Chain2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 7, FoltoneClothesShop.Chain1Index - 1) - 1
                FoltoneClothesShop.Chain2List = {}
                generateList(0, Chain2Count, FoltoneClothesShop.Chain2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Chain2Index = Index
                SetPedComponentVariation(PlayerPedId(), 7, FoltoneClothesShop.Chain1Index - 1, FoltoneClothesShop.Chain2Index - 1, 0)
            end
        end)
        Items:AddList(_U("arms"), FoltoneClothesShop.Arms1List, string.format("#%s", FoltoneClothesShop.Arms1List), FoltoneClothesShop.Arms1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Arms1Index = Index
                FoltoneClothesShop.Arms2Index = 1
                SetPedComponentVariation(PlayerPedId(), 3, FoltoneClothesShop.Arms1Index - 1, FoltoneClothesShop.Arms2Index - 1, 0)
            end
        end)
        Items:AddList(_U("arms_2"), FoltoneClothesShop.Arms2List, string.format("#%s", FoltoneClothesShop.Arms2List), FoltoneClothesShop.Arms2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastArms1Index ~= FoltoneClothesShop.Arms1Index then
                FoltoneClothesShop.LastArms1Index = FoltoneClothesShop.Arms1Index
                local Arms2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 3, FoltoneClothesShop.Arms1Index - 1) - 1
                FoltoneClothesShop.Arms2List = {}
                generateList(0, Arms2Count, FoltoneClothesShop.Arms2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Arms2Index = Index
                SetPedComponentVariation(PlayerPedId(), 3, FoltoneClothesShop.Arms1Index - 1, FoltoneClothesShop.Arms2Index - 1, 0)
            end
        end)
        Items:AddList(_U("pants_1"), FoltoneClothesShop.Pants1List, string.format("#%s", FoltoneClothesShop.Pants1List), FoltoneClothesShop.Pants1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Pants1Index = Index
                FoltoneClothesShop.Pants2Index = 1
                SetPedComponentVariation(PlayerPedId(), 4, FoltoneClothesShop.Pants1Index - 1, FoltoneClothesShop.Pants2Index - 1, 0)
            end
        end)
        Items:AddList(_U("pants_2"), FoltoneClothesShop.Pants2List, string.format("#%s", FoltoneClothesShop.Pants2List), FoltoneClothesShop.Pants2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastPants1Index ~= FoltoneClothesShop.Pants1Index then
                FoltoneClothesShop.LastPants1Index = FoltoneClothesShop.Pants1Index
                local Pants2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 4, FoltoneClothesShop.Pants1Index - 1) - 1
                FoltoneClothesShop.Pants2List = {}
                generateList(0, Pants2Count, FoltoneClothesShop.Pants2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Pants2Index = Index
                SetPedComponentVariation(PlayerPedId(), 4, FoltoneClothesShop.Pants1Index - 1, FoltoneClothesShop.Pants2Index - 1, 0)
            end
        end)
        Items:AddList(_U("shoes_1"), FoltoneClothesShop.Shoes1List, string.format("#%s", FoltoneClothesShop.Shoes1List), FoltoneClothesShop.Shoes1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Shoes1Index = Index
                FoltoneClothesShop.Shoes2Index = 1
                SetPedComponentVariation(PlayerPedId(), 6, FoltoneClothesShop.Shoes1Index - 1, FoltoneClothesShop.Shoes2Index - 1, 0)
            end
        end)
        Items:AddList(_U("shoes_2"), FoltoneClothesShop.Shoes2List, string.format("#%s", FoltoneClothesShop.Shoes2List), FoltoneClothesShop.Shoes2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastShoes1Index ~= FoltoneClothesShop.Shoes1Index then
                FoltoneClothesShop.LastShoes1Index = FoltoneClothesShop.Shoes1Index
                local Shoes2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 6, FoltoneClothesShop.Shoes1Index - 1) - 1
                FoltoneClothesShop.Shoes2List = {}
                generateList(0, Shoes2Count, FoltoneClothesShop.Shoes2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Shoes2Index = Index
                SetPedComponentVariation(PlayerPedId(), 6, FoltoneClothesShop.Shoes1Index - 1, FoltoneClothesShop.Shoes2Index - 1, 0)
            end
        end)
        Items:AddList(_U("bracelets_1"), FoltoneClothesShop.Bracelets1List, string.format("#%s", FoltoneClothesShop.Bracelets1List), FoltoneClothesShop.Bracelets1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Bracelets1Index = Index
                FoltoneClothesShop.Bracelets2Index = 1
                if FoltoneClothesShop.Bracelets1List[FoltoneClothesShop.Bracelets1Index] == -1 then
                    ClearPedProp(PlayerPedId(), 7)
                    FoltoneClothesShop.Bracelets2List = { 0 }
                else
                    SetPedPropIndex(PlayerPedId(), 7, FoltoneClothesShop.Bracelets1List[FoltoneClothesShop.Bracelets1Index], FoltoneClothesShop.Bracelets2List[FoltoneClothesShop.Bracelets2Index], true)
                end
            end
        end)
        Items:AddList(_U("bracelets_2"), FoltoneClothesShop.Bracelets2List, string.format("#%s", FoltoneClothesShop.Bracelets2List), FoltoneClothesShop.Bracelets2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastBracelets1Index ~= FoltoneClothesShop.Bracelets1Index then
                FoltoneClothesShop.LastBracelets1Index = FoltoneClothesShop.Bracelets1Index
                local Bracelets2Count = GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, FoltoneClothesShop.Bracelets1List[FoltoneClothesShop.Bracelets1Index]) - 1
                FoltoneClothesShop.Bracelets2List = {}
                generateList(0, Bracelets2Count, FoltoneClothesShop.Bracelets2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Bracelets2Index = Index
                if FoltoneClothesShop.Bracelets1List[FoltoneClothesShop.Bracelets1Index] > -1 then
                    SetPedPropIndex(PlayerPedId(), 7, FoltoneClothesShop.Bracelets1List[FoltoneClothesShop.Bracelets1Index], FoltoneClothesShop.Bracelets2List[FoltoneClothesShop.Bracelets2Index], true)
                else
                    FoltoneClothesShop.Bracelets2List = { 0 }
                end
            end
        end)
        Items:AddList(_U("watches_1"), FoltoneClothesShop.Watches1List, string.format("#%s", FoltoneClothesShop.Watches1List), FoltoneClothesShop.Watches1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Watches1Index = Index
                FoltoneClothesShop.Watches2Index = 1
                if FoltoneClothesShop.Watches1List[FoltoneClothesShop.Watches1Index] == -1 then
                    ClearPedProp(PlayerPedId(), 6)
                    FoltoneClothesShop.Watches2List = { 0 }
                else
                    SetPedPropIndex(PlayerPedId(), 6, FoltoneClothesShop.Watches1List[FoltoneClothesShop.Watches1Index], FoltoneClothesShop.Watches2List[FoltoneClothesShop.Watches2Index], true)
                end
            end
        end)
        Items:AddList(_U("watches_2"), FoltoneClothesShop.Watches2List, string.format("#%s", FoltoneClothesShop.Watches2List), FoltoneClothesShop.Watches2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastWatches1Index ~= FoltoneClothesShop.Watches1Index then
                FoltoneClothesShop.LastWatches1Index = FoltoneClothesShop.Watches1Index
                local Watches2Count = GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, FoltoneClothesShop.Watches1List[FoltoneClothesShop.Watches1Index]) - 1
                FoltoneClothesShop.Watches2List = {}
                generateList(0, Watches2Count, FoltoneClothesShop.Watches2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Watches2Index = Index
                if FoltoneClothesShop.Watches1List[FoltoneClothesShop.Watches1Index] > -1 then
                    SetPedPropIndex(PlayerPedId(), 6, FoltoneClothesShop.Watches1List[FoltoneClothesShop.Watches1Index], FoltoneClothesShop.Watches2List[FoltoneClothesShop.Watches2Index], true)
                else
                    FoltoneClothesShop.Watches2List = { 0 }
                end
            end
        end)
        Items:AddButton(_U("pay"), nil, { RightLabel = string.format("~g~%s$", Config.PriceSaveClothes), IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local clothesLabel = KeyboardInput(_U("name_clothes"), "", 20)
                if clothesLabel then
                    ESX.TriggerServerCallback("foltone_clotheshop:pay", function(paid, notification)
                        if paid then
                            setClothe(getPlayerClothe())
                            setTimout(50)
                            Wait(50)
                            openClothesShop = false
                            closeMenu()
                        end
                        Config.Notification(notification)
                    end, clothesLabel, getPlayerClothe())
                else
                    Config.Notification(_U("not_enough_money"))
                end
            end
        end)
    end, function(Panels)
    end)
    saveClothes:IsVisible(function(Items)
        if FoltoneClothesShop.PlayerClothes then
            for i = 1, #FoltoneClothesShop.PlayerClothes, 1 do
                if FoltoneClothesShop.PlayerClothes[i] then
                    Items:AddList(FoltoneClothesShop.PlayerClothes[i].name, FoltoneClothesShop.OptionsList, FoltoneClothesShop.OptionsList[FoltoneClothesShop.OptionsIndex], FoltoneClothesShop.OptionsIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
                        if (onListChange) then
                            FoltoneClothesShop.OptionsIndex = Index
                        end
                        if (onSelected) then
                            if FoltoneClothesShop.OptionsIndex == 1 then
                                setClothe(FoltoneClothesShop.PlayerClothes[i].clothes)
                            elseif FoltoneClothesShop.OptionsIndex == 2 then
                                local clothesLabel = KeyboardInput(_U("name_clothes"), FoltoneClothesShop.PlayerClothes[i].name, 20)
                                if clothesLabel then
                                    ESX.TriggerServerCallback("foltone_clotheshop:rename", function(notification)
                                        Config.Notification(notification)
                                        FoltoneClothesShop.PlayerClothes[i].name = clothesLabel
                                    end, FoltoneClothesShop.PlayerClothes[i].id, FoltoneClothesShop.PlayerClothes[i].name, clothesLabel)
                                end
                            elseif FoltoneClothesShop.OptionsIndex == 3 then
                                ESX.TriggerServerCallback("foltone_clotheshop:delete", function(notification)
                                    Config.Notification(notification)
                                    RageUI.GoBack()
                                    setTimout(50)
                                    Wait(50)
                                    FoltoneClothesShop.PlayerClothes[i] = nil
                                end, FoltoneClothesShop.PlayerClothes[i].id)
                            end
                        end
                    end)
                end
            end
        end
    end, function(Panels)
    end)

    menuHelmet:IsVisible(function(Items)
        Items:AddList(_U("helmet_1"), FoltoneClothesShop.Helmet1List, string.format("#%s", FoltoneClothesShop.Helmet1List), FoltoneClothesShop.Helmet1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Helmet1Index = Index
                FoltoneClothesShop.Helmet2Index = 1
                if FoltoneClothesShop.Helmet1List[FoltoneClothesShop.Helmet1Index] == -1 then
                    ClearPedProp(PlayerPedId(), 0)
                    FoltoneClothesShop.Helmet2List = { 0 }
                else
                    SetPedPropIndex(PlayerPedId(), 0, FoltoneClothesShop.Helmet1List[FoltoneClothesShop.Helmet1Index], FoltoneClothesShop.Helmet2List[FoltoneClothesShop.Helmet2Index], true)
                end
            end
        end)
        Items:AddList(_U("helmet_2"), FoltoneClothesShop.Helmet2List, string.format("#%s", FoltoneClothesShop.Helmet2List), FoltoneClothesShop.Helmet2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastHelmet1Index ~= FoltoneClothesShop.Helmet1Index then
                FoltoneClothesShop.LastHelmet1Index = FoltoneClothesShop.Helmet1Index
                local Helmet2Count = GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, FoltoneClothesShop.Helmet1List[FoltoneClothesShop.Helmet1Index]) - 1
                FoltoneClothesShop.Helmet2List = {}
                generateList(0, Helmet2Count, FoltoneClothesShop.Helmet2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Helmet2Index = Index
                if FoltoneClothesShop.Helmet1List[FoltoneClothesShop.Helmet1Index] > -1 then
                    SetPedPropIndex(PlayerPedId(), 0, FoltoneClothesShop.Helmet1List[FoltoneClothesShop.Helmet1Index], FoltoneClothesShop.Helmet2List[FoltoneClothesShop.Helmet2Index], true)
                else
                    FoltoneClothesShop.Helmet2List = { 0 }
                end
            end
        end)
        Items:AddButton(_U("pay"), nil, { RightLabel = string.format("~g~%s$", Config.PriceBuyHelmet), IsDisabled = false }, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("foltone_clotheshop:haveAmount", function(paid, notification)
                    if paid then
                        setClothe(getPlayerClothe())
                        Wait(250)
                        openHelmet = false
                        closeMenu()
                    end
                    Config.Notification(notification)
                end, Config.PriceBuyHelmet)
            end
        end)
    end, function(Panels)
    end)

    menuGlasses:IsVisible(function(Items)
        Items:AddList(_U("glasses_1"), FoltoneClothesShop.Glasses1List, string.format("#%s", FoltoneClothesShop.Glasses1List), FoltoneClothesShop.Glasses1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Glasses1Index = Index
                FoltoneClothesShop.Glasses2Index = 1
                if FoltoneClothesShop.Glasses1List[FoltoneClothesShop.Glasses1Index] == -1 then
                    ClearPedProp(PlayerPedId(), 1)
                    FoltoneClothesShop.Glasses2List = { 0 }
                else
                    SetPedPropIndex(PlayerPedId(), 1, FoltoneClothesShop.Glasses1List[FoltoneClothesShop.Glasses1Index], FoltoneClothesShop.Glasses2List[FoltoneClothesShop.Glasses2Index], true)
                end
            end
        end)
        Items:AddList(_U("glasses_2"), FoltoneClothesShop.Glasses2List, string.format("#%s", FoltoneClothesShop.Glasses2List), FoltoneClothesShop.Glasses2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastGlasses1Index ~= FoltoneClothesShop.Glasses1Index then
                FoltoneClothesShop.LastGlasses1Index = FoltoneClothesShop.Glasses1Index
                local Glasses2Count = GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, FoltoneClothesShop.Glasses1List[FoltoneClothesShop.Glasses1Index]) - 1
                FoltoneClothesShop.Glasses2List = {}
                generateList(0, Glasses2Count, FoltoneClothesShop.Glasses2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Glasses2Index = Index
                if FoltoneClothesShop.Glasses1List[FoltoneClothesShop.Glasses1Index] > -1 then
                    SetPedPropIndex(PlayerPedId(), 1, FoltoneClothesShop.Glasses1List[FoltoneClothesShop.Glasses1Index], FoltoneClothesShop.Glasses2List[FoltoneClothesShop.Glasses2Index], true)
                else
                    FoltoneClothesShop.Glasses2List = { 0 }
                end
            end
        end)
        Items:AddButton(_U("pay"), nil, { RightLabel = string.format("~g~%s$", Config.PriceBuyGlasses), IsDisabled = false }, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("foltone_clotheshop:haveAmount", function(paid, notification)
                    if paid then
                        setClothe(getPlayerClothe())
                        Wait(250)
                        openGlasses = false
                        closeMenu()
                    end
                    Config.Notification(notification)
                end, Config.PriceBuyGlasses)
            end
        end)
    end, function(Panels)
    end)

    menuEars:IsVisible(function(Items)
        Items:AddList(_U("ears_1"), FoltoneClothesShop.Ears1List, string.format("#%s", FoltoneClothesShop.Ears1List), FoltoneClothesShop.Ears1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Ears1Index = Index
                FoltoneClothesShop.Ears2Index = 1
                if FoltoneClothesShop.Ears1List[FoltoneClothesShop.Ears1Index] == -1 then
                    ClearPedProp(PlayerPedId(), 2)
                    FoltoneClothesShop.Ears2List = { 0 }
                else
                    SetPedPropIndex(PlayerPedId(), 2, FoltoneClothesShop.Ears1List[FoltoneClothesShop.Ears1Index], FoltoneClothesShop.Ears2List[FoltoneClothesShop.Ears2Index], true)
                end
            end
        end)
        Items:AddList(_U("ears_2"), FoltoneClothesShop.Ears2List, string.format("#%s", FoltoneClothesShop.Ears2List), FoltoneClothesShop.Ears2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if FoltoneClothesShop.LastEars1Index ~= FoltoneClothesShop.Ears1Index then
                FoltoneClothesShop.LastEars1Index = FoltoneClothesShop.Ears1Index
                local Ears2Count = GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, FoltoneClothesShop.Ears1List[FoltoneClothesShop.Ears1Index]) - 1
                FoltoneClothesShop.Ears2List = {}
                generateList(0, Ears2Count, FoltoneClothesShop.Ears2List)
            end
            if (onListChange) then
                FoltoneClothesShop.Ears2Index = Index
                if FoltoneClothesShop.Ears1List[FoltoneClothesShop.Ears1Index] > -1 then
                    SetPedPropIndex(PlayerPedId(), 2, FoltoneClothesShop.Ears1List[FoltoneClothesShop.Ears1Index], FoltoneClothesShop.Ears2List[FoltoneClothesShop.Ears2Index], true)
                else
                    FoltoneClothesShop.Ears2List = { 0 }
                end
            end
        end)
        Items:AddButton(_U("pay"), nil, { RightLabel = string.format("~g~%s$", Config.PriceBuyEars), IsDisabled = false }, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("foltone_clotheshop:haveAmount", function(paid, notification)
                    if paid then
                        setClothe(getPlayerClothe())
                        Wait(250)
                        openEars = false
                        closeMenu()
                    end
                    Config.Notification(notification)
                end, Config.PriceBuyEars)
            end
        end)
    end, function(Panels)
    end)

    menuMask:IsVisible(function(Items)
        Items:AddList(_U("mask_1"), FoltoneClothesShop.Mask1List, string.format("#%s", FoltoneClothesShop.Mask1List), FoltoneClothesShop.Mask1Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                if FoltoneClothesShop.LastMask1Index ~= FoltoneClothesShop.Mask1Index then
                    FoltoneClothesShop.LastMask1Index = FoltoneClothesShop.Mask1Index
                    local Mask2Count = GetNumberOfPedTextureVariations(PlayerPedId(), 1, FoltoneClothesShop.Mask1Index - 1) - 1
                    FoltoneClothesShop.Mask2List = {}
                    generateList(0, Mask2Count, FoltoneClothesShop.Mask2List)
                end
                FoltoneClothesShop.Mask1Index = Index
                FoltoneClothesShop.Mask2Index = 1
                SetPedComponentVariation(PlayerPedId(), 1, FoltoneClothesShop.Mask1Index - 1, FoltoneClothesShop.Mask2Index - 1, 0)
            end
        end)
        Items:AddList(_U("mask_2"), FoltoneClothesShop.Mask2List, string.format("#%s", FoltoneClothesShop.Mask2List), FoltoneClothesShop.Mask2Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                FoltoneClothesShop.Mask2Index = Index
                SetPedComponentVariation(PlayerPedId(), 1, FoltoneClothesShop.Mask1Index - 1, FoltoneClothesShop.Mask2Index - 1, 0)
            end
        end)   
        Items:AddButton(_U("pay"), nil, { RightLabel = string.format("~g~%s$", Config.PriceBuyMask), IsDisabled = false }, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("foltone_clotheshop:haveAmount", function(paid, notification)
                    if paid then
                        setClothe(getPlayerClothe())
                        Wait(250)
                        openMask = false
                        closeMenu()
                    end
                    Config.Notification(notification)
                end, Config.PriceBuyMask)
            end
        end)
    end, function(Panels)
    end)
end
CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(500)
    end
    for k, v in pairs(Config.ClothesShopPositions) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, Config.BlipClotheShop.Sprite)
        SetBlipColour(blip, Config.BlipClotheShop.Color)
        SetBlipScale(blip, Config.BlipClotheShop.Scale)
        SetBlipDisplay(blip, Config.BlipClotheShop.Display)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipClotheShop.Name)
        EndTextCommandSetBlipName(blip)
    end
    for k, v in pairs(Config.MaskPosition) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, Config.BlipMask.Sprite)
        SetBlipColour(blip, Config.BlipMask.Color)
        SetBlipScale(blip, Config.BlipMask.Scale)
        SetBlipDisplay(blip, Config.BlipMask.Display)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipMask.Name)
        EndTextCommandSetBlipName(blip)
    end
    while not (GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") or GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") or GetEntityModel(PlayerPedId()) == 1885233650 or GetEntityModel(PlayerPedId()) == -1667301416) do
        Wait(500)
    end
    Wait(1000)
    getLists()
    while true do
        local wait = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(Config.ClothesShopPositions) do
            local distance = #(playerCoords - v)
            if distance <= 10.0 then
                wait = 0
                Config.Marker(v, 2.0)
                if distance <= 2.0 and not openClothesShop then
                    Config.DisplayText(_U("open_menu"))
                    if IsControlJustPressed(0, 38) then
                        ESX.TriggerServerCallback("foltone_clotheshop:getClothes", function(clothes)
                            FoltoneClothesShop.PlayerClothes = clothes
                            openClothesShop = true
                            RageUI.Visible(menuClothesShop, not RageUI.Visible(menuClothesShop))
                        end)
                    end
                elseif distance > 2.0 and openClothesShop then
                    openClothesShop = false
                    closeMenu()
                end
            end
        end
        for k, v in pairs(Config.HelmetPositions) do
            local distance = #(playerCoords - v)
            if distance <= 10.0 then
                wait = 0
                Config.Marker(v, 0.8)
                if distance <= 0.8 and not openHelmet then
                    Config.DisplayText(_U("open_menu"))
                    if IsControlJustPressed(0, 38) then
                        openHelmet = true
                        RageUI.Visible(menuHelmet, not RageUI.Visible(menuHelmet))
                    end
                elseif distance > 0.8 and openHelmet then
                    openHelmet = false
                    closeMenu()
                end
            end
        end
        for k, v in pairs(Config.GlassesPositions) do
            local distance = #(playerCoords - v)
            if distance <= 10.0 then
                wait = 0
                Config.Marker(v, 0.8)
                if distance <= 0.8 and not openGlasses then
                    Config.DisplayText(_U("open_menu"))
                    if IsControlJustPressed(0, 38) then
                        openGlasses = true
                        RageUI.Visible(menuGlasses, not RageUI.Visible(menuGlasses))
                    end
                elseif distance > 0.8 and openGlasses then
                    openGlasses = false
                    closeMenu()
                end
            end
        end
        for k, v in pairs(Config.EarsPositions) do
            local distance = #(playerCoords - v)
            if distance <= 10.0 then
                wait = 0
                Config.Marker(v, 0.8)
                if distance <= 0.8 and not openEars then
                    Config.DisplayText(_U("open_menu"))
                    if IsControlJustPressed(0, 38) then
                        openEars = true
                        RageUI.Visible(menuEars, not RageUI.Visible(menuEars))
                    end
                elseif distance > 0.8 and openEars then
                    openEars = false
                    closeMenu()
                end
            end
        end
        for k, v in pairs(Config.MaskPosition) do
            local distance = #(playerCoords - v)
            if distance <= 10.0 then
                wait = 0
                Config.Marker(v, 0.8)
                if distance <= 0.8 and not openMask then
                    Config.DisplayText(_U("open_menu"))
                    if IsControlJustPressed(0, 38) then
                        openMask = true
                        RageUI.Visible(menuMask, not RageUI.Visible(menuMask))
                    end
                elseif distance > 0.8 and openMask then
                    openMask = false
                    closeMenu()
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    ESX.PlayerLoaded = true
end)
