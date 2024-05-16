local rgbColorList = {
    {28, 31, 33},
    {39, 42, 44},
    {49, 46, 44},
    {53, 38, 28},
    {75, 50, 31},
    {92, 59, 36},
    {109, 76, 53},
    {107, 80, 59},
    {118, 92, 69},
    {127, 104, 78},
    {153, 129, 93},
    {167, 147, 105},
    {175, 156, 112},
    {187, 160, 99},
    {214, 185, 123},
    {218, 195, 142},
    {159, 127, 89},
    {132, 80, 57},
    {104, 43, 31},
    {97, 18, 12},
    {100, 15, 10},
    {124, 20, 15},
    {160, 46, 25},
    {182, 75, 40},
    {162, 80, 47},
    {170, 78, 43},
    {98, 98, 98},
    {128, 128, 128},
    {170, 170, 170},
    {197, 197, 197},
    {70, 57, 85},
    {90, 63, 107},
    {118, 60, 118},
    {237, 116, 227},
    {235, 75, 147},
    {242, 153, 188},
    {4, 149, 158},
    {2, 95, 134},
    {2, 57, 116},
    {63, 161, 106},
    {33, 124, 97},
    {24, 92, 85},
    {182, 192, 52},
    {112, 169, 11},
    {67, 157, 19},
    {220, 184, 87},
    {229, 177, 3},
    {230, 145, 2},
    {242, 136, 49},
    {251, 128, 87},
    {226, 139, 88},
    {209, 89, 60},
    {206, 49, 32},
    {173, 9, 3},
    {136, 3, 2},
    {31, 24, 20},
    {41, 31, 25},
    {46, 34, 27},
    {55, 41, 30},
    {46, 34, 24},
    {35, 27, 21},
    {2, 2, 2},
    {112, 108, 102},
    {157, 122, 80},
}
-- I use the chair coordinates because some are not detectable with GetClosestObjectOfType
local chairPositionList = {
    vector4(139.3318939209, -1708.0994873047, 28.318195343018, 45.000034332275),
    vector4(138.36465454102, -1709.2521972656, 28.318195343018, 50.000022888184),
    vector4(137.39752197266, -1710.4047851563, 28.318195343018, 50.000022888184),
    vector4(-1281.283203125, -1119.0698242188, 6.0166993141174, 355.0),
    vector4(-1282.7879638672, -1119.0698242188, 6.0166993141174, 360.0),
    vector4(-1284.2926025391, -1119.0698242188, 6.0166993141174, 360.0),
    vector4(1932.5445556641, 3732.5104980469, 31.871026992798, 115.021484375),
    vector4(1933.2973632813, 3731.2075195313, 31.871026992798, 120.02146911621),
    vector4(1934.0501708984, 3729.9047851563, 31.871026992798, 120.02146911621),
    vector4(1213.3612060547, -474.95257568359, 65.23462677002, 339.99926757813),
    vector4(1211.9077148438, -474.56311035156, 65.23462677002, 344.99923706055),
    vector4(1210.4543457031, -474.17367553711, 65.23462677002, 344.99923706055),
    vector4(-35.245048522949, -153.19590759277, 56.103103637695, 245.00004577637),
    vector4(-34.730388641357, -151.78189086914, 56.103103637695, 250.00003051758),
    vector4(-34.215789794922, -150.36804199219, 56.103103637695, 250.00003051758),
    vector4(-278.4602355957, 6225.7895507813, 30.722108840942, 310.2463684082),
    vector4(-279.52883911133, 6226.8491210938, 30.722108840942, 315.2463684082),
    vector4(-280.59729003906, 6227.908203125, 30.722108840942, 315.2463684082),
    vector4(-812.75811767578, -180.97079467773, 36.569408416748, 209.99996948242),
    vector4(-814.49017333984, -181.97079467773, 36.569408416748, 209.99996948242),
    vector4(-816.22216796875, -182.97079467773, 36.569408416748, 209.99996948242),
    vector4(-817.95422363281, -183.97079467773, 36.569408416748, 209.99996948242)
}
local timout = false
local function setTimout(time)
    timout = true
    Citizen.SetTimeout(time, function()
        timout = false
    end)
end
local function helpNotification(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

ESX = exports["es_extended"]:getSharedObject()

local function loadSkin()
    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)
end
local function saveSkin()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end

local sit = false
local cam = nil
local ped = nil
local scissor = nil
local chairSelected = nil
local function requestModel(model)
    RequestModel(model)
    repeat Wait(0) until HasModelLoaded(model)
end
local function requestAnimDict(dict)
    RequestAnimDict(dict)
    repeat Wait(0) until HasAnimDictLoaded(dict)
end
local function getOffsetCoords(coords, heading, offset)
    local headingRadians = math.rad(heading)
    local offsetDistance = offset
    local directionVector = vector3(-math.sin(headingRadians) * offsetDistance, math.cos(headingRadians) * offsetDistance, 0.0)
    local offsetCoords = coords + directionVector
    return offsetCoords
end
local function CreateCamInFrontOfHeadPlayer(coords, heading)
    local camCoords = getOffsetCoords(coords, heading, -0.8)
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z + 1.1)
    SetCamRot(camera, 0.0, 0.0, heading, 2)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 1, true, true)
    return camera
end
local function spawnPedHairdresser(coords, heading)
    local pedCoords = getOffsetCoords(coords, heading, 0.8)
    local model = GetHashKey("s_f_y_hooker_01")
    requestModel(model)
    local pedHairdresser = CreatePed(4, model, pedCoords.x, pedCoords.y, pedCoords.z, heading - 180.0, false, true)
    SetBlockingOfNonTemporaryEvents(pedHairdresser, true)
    SetEntityInvincible(pedHairdresser, true)
    local dict, anim = "misshair_shop@barbers", "keeper_base"
    requestAnimDict(dict)
    TaskPlayAnim(pedHairdresser, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
    local scissorModel = GetHashKey("v_serv_bs_scissors")
    requestModel(scissorModel)
    scissor = CreateObject(scissorModel, 0.0, 0.0, 0.0, true, true, true)
    AttachEntityToEntity(scissor, pedHairdresser, GetPedBoneIndex(pedHairdresser, 57005), 0.2, 0.02, -0.02, 90.0, 90.0, 90.0, true, true, false, true, 1, true)
    return pedHairdresser
end
local function stopHairCut()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    DoScreenFadeOut(0)
    sit = false
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    RenderScriptCams(false, false, 1, true, true)
    DestroyCam(cam, true)
    DeleteEntity(ped)
    DeleteObject(scissor)
    local respawnCoords = getOffsetCoords(playerCoords, playerHeading, -1.0)
    SetEntityCoords(playerPed, respawnCoords.x, respawnCoords.y, respawnCoords.z)
    TriggerServerEvent("foltone_barbershop:remove_place", chairSelected)
    Wait(1000)
    DoScreenFadeIn(250)
end


local resetSkin = true
local hairstyles = {}
local hairIndex = 0
local hairColors = {1,1, 0.0}
local beards = {}
local beardsIndex = 0
local beardOpacity = 0
local breadColors = {1,1, 0.0}
local eyebrows = {}
local eyebrowsIndex = 0
local eyebrowsOpacity = 0.0
local eyebrowsColors = {1,1, 0.0}
local function generateList(startIndex, endIndex, targetTable)
    for i = startIndex, endIndex - 1 do
        table.insert(targetTable, i)
    end
end
local function getLists()
    local playerPed = PlayerPedId()
    local hairStylesCount = GetNumberOfPedDrawableVariations(playerPed, 2)
    local beardsCount = GetNumHeadOverlayValues(1)
    local eyebrowsCount = GetNumHeadOverlayValues(2)
    generateList(0, hairStylesCount, hairstyles)
    generateList(0, beardsCount, beards)
    generateList(0, eyebrowsCount, eyebrows)
end

local open = false
local function closeMenu()
    RageUI.CloseAll()
    open = false
    stopHairCut()
    if resetSkin then
        loadSkin()
    else
        saveSkin()
        resetSkin = true
    end
    hairIndex = 0
    hairColors = {1,1, 0.0}
    beardsIndex = 0
    beardOpacity = 0
    breadColors = {1,1, 0.0}
    eyebrowsIndex = 0
    eyebrowsOpacity = 0.0
    eyebrowsColors = {1,1, 0.0}
    chairSelected = nil
    sit = false
    setTimout(1000)
end
local menuBarber = RageUI.CreateMenu("", _U("menu_subtitle"))
function menuBarber.Closed()
    open = false
    closeMenu()
end
function RageUI.PoolMenus:FoltoneBarber()
    menuBarber.EnableMouse = true
    menuBarber:IsVisible(function(Items)
        Items:AddList(_U("hairstyle"), hairstyles, string.format("#%s", hairstyles), hairIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                hairIndex = Index
                TriggerEvent('skinchanger:change', "hair_1", hairIndex)
            end
        end)
        Items:AddList(_U("beard"), beards, string.format("#%s", beards), beardsIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                beardsIndex = Index
                TriggerEvent('skinchanger:change', "beard_1", beardsIndex)
                TriggerEvent('skinchanger:change', "beard_2", (beardOpacity * 10) + 0.0)
            end
        end)
        Items:AddList(_U("eyebrow"), eyebrows, string.format("#%s", eyebrows), eyebrowsIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                eyebrowsIndex = Index
                TriggerEvent('skinchanger:change', "eyebrows_1", eyebrowsIndex)
                TriggerEvent('skinchanger:change', "eyebrows_2", (eyebrowsOpacity * 10) + 0.0)
            end
        end)
        Items:AddButton(_U("pay"), nil, { RightLabel = ">", IsDisabled = false, Color = { BackgroundColor = { 0, 130, 0, 155 } } }, function(onSelected)
            if (onSelected) then
                ESX.TriggerServerCallback("foltone_barbershop:pay", function(paid)
                    if paid then
                        resetSkin = false
                        closeMenu()
                    else
                        Config.Notification(_U("not_enough_money"))
                    end
                end)
            end
        end)
        Items:AddButton(_U("exit"), nil, { RightLabel = ">", IsDisabled = false, Color = { BackgroundColor = { 130, 0, 0, 155 } } }, function(onSelected)
            if (onSelected) then
                resetSkin = true
                closeMenu()
            end
        end)
    end, function(Panels)
        Items:ColourPanel(_U("color"), rgbColorList, hairColors[1], hairColors[2], function(MinimumIndex, CurrentIndex, onColorChange)
            if (onColorChange) then
                CurrentIndex = CurrentIndex
                hairColors[1] = MinimumIndex
                hairColors[2] = CurrentIndex
                TriggerEvent('skinchanger:change', "hair_color_1", CurrentIndex - 1)
                TriggerEvent('skinchanger:change', "hair_color_2", CurrentIndex - 1)
            end
        end, 1)
        Items:PercentagePanel(beardOpacity, _U("opacity"), "0%", "100%", function(Percentage)
            beardOpacity = Percentage
            TriggerEvent('skinchanger:change', "beard_2", (beardOpacity * 10) + 0.0)
        end, 2)
        Items:ColourPanel(_U("color"), rgbColorList, breadColors[1], breadColors[2], function(MinimumIndex, CurrentIndex, onColorChange)
            if (onColorChange) then
                CurrentIndex = CurrentIndex
                breadColors[1] = MinimumIndex
                breadColors[2] = CurrentIndex
                TriggerEvent('skinchanger:change', "beard_3", CurrentIndex - 1)
                TriggerEvent('skinchanger:change', "beard_4", CurrentIndex - 1)
            end
        end, 2)
        Items:PercentagePanel(eyebrowsOpacity, _U("opacity"), "0%", "100%", function(Percentage)
            eyebrowsOpacity = Percentage
            TriggerEvent('skinchanger:change', "eyebrows_2", (eyebrowsOpacity * 10) + 0.0)
        end, 3)
        Items:ColourPanel(_U("color"), rgbColorList, eyebrowsColors[1], eyebrowsColors[2], function(MinimumIndex, CurrentIndex, onColorChange)
            if (onColorChange) then
                CurrentIndex = CurrentIndex
                eyebrowsColors[1] = MinimumIndex
                eyebrowsColors[2] = CurrentIndex
                TriggerEvent('skinchanger:change', "eyebrows_3", CurrentIndex - 1)
                TriggerEvent('skinchanger:change', "eyebrows_4", CurrentIndex - 1)
            end
        end, 3)
    end)
end
local function startHairCut(coords, chair)
    local newCoords = vector3(coords.x, coords.y, coords.z + 0.5)
    local heading = coords.w
    ESX.TriggerServerCallback("foltone_barbershop:check_place_enable", function(enable)
        if enable then
            chairSelected = chair
            DoScreenFadeOut(0)
            RageUI.Visible(menuBarber, not RageUI.Visible(menuBarber))
            TriggerServerEvent("foltone_barbershop:get_place", chairSelected)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local anim = "PROP_HUMAN_SEAT_BENCH"
            TaskStartScenarioAtPosition(playerPed, anim, newCoords.x, newCoords.y, newCoords.z + (playerCoords.z - newCoords.z) / 2, heading - 180.0, 0, true, true)
            cam = CreateCamInFrontOfHeadPlayer(newCoords, heading)
            ped = spawnPedHairdresser(newCoords, heading)
            sit = true
            ClearPedProp(playerPed, 0)
            Wait(1000)
            DoScreenFadeIn(250)
        end
    end, chair)
end
CreateThread(function()
    while ESX.PlayerData == nil do
        Wait(0)
    end
    Wait(1000)
    getLists()
    while true do
        local wait = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(chairPositionList) do
            local chairCoords = vector3(v.x, v.y, v.z)
            local distance = #(playerCoords - chairCoords)
            if distance <= 1.5 and not sit and not open and k ~= chairSelected then
                wait = 0
                helpNotification(_U("press_barber"))
                if IsControlJustPressed(0, 38) then
                    setTimout(1000)
                    startHairCut(v, k)
                end
            end
        end
        Wait(wait)
    end
end)

CreateThread(function()
    for k, v in pairs(Config.BarberShopPositions) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    ESX.PlayerData = ESX.GetPlayerData()
end)