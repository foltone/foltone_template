local ESX <const> = exports["es_extended"]:getSharedObject()
local SetTimeout <const> = SetTimeout
local ApplyPedOverlay <const> = ApplyPedOverlay
local ClearPedDecorationsLeaveScars <const> = ClearPedDecorationsLeaveScars
local GetEntityCoords <const> = GetEntityCoords
local PlayerPedId <const> = PlayerPedId
local Wait <const> = Wait
local FreezeEntityPosition <const> = FreezeEntityPosition


local FoltoneTattooShop = {
    Timeout = false,
    PlayerTattoos = {},
    CategorieSelected = nil,
    LastTattoo = nil,
    UpdatedMainMenu = false,
    Cam = nil,
    CamRotationOffset = 0.0,
    CamHeight = 1.0,
    CamDistance = 2.0,
    CamSpot = nil
}

local function setTimout(time)
    FoltoneTattooShop.Timeout = true
    SetTimeout(time, function()
        FoltoneTattooShop.Timeout = false
    end)
end

local function loadSkin()
    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)
end
local function setNaked()
    local playerPed = PlayerPedId()
    if GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01") then
        for k, v in pairs(Config.NakedSkinMale) do
            TriggerEvent("skinchanger:change", k, v)
        end
    elseif GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01") then
        for k, v in pairs(Config.NakedSkinFemale) do
            TriggerEvent("skinchanger:change", k, v)
        end
    end
end
local function applyPlayerTattoo(tattoo)
    local playerPed = PlayerPedId()
    if GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01") then
        ApplyPedOverlay(playerPed, GetHashKey(tattoo.collection), GetHashKey(tattoo.hashMale))
    elseif GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01") then
        ApplyPedOverlay(playerPed, GetHashKey(tattoo.collection), GetHashKey(tattoo.hashFemale))
    end
end
local function applyOwnPlayerTattoos()
    ClearPedDecorationsLeaveScars(PlayerPedId())
    if FoltoneTattooShop.PlayerTattoos and #FoltoneTattooShop.PlayerTattoos > 0 then
        for k, v in pairs(FoltoneTattooShop.PlayerTattoos) do
            applyPlayerTattoo(v)
        end
    end
end
local function alreadyHaveTattoo(collection, name)
    if FoltoneTattooShop.PlayerTattoos and #FoltoneTattooShop.PlayerTattoos > 0 then
        for k, v in pairs(FoltoneTattooShop.PlayerTattoos) do
            if v.collection == collection and v.name == name then
                return true
            end
        end
    end
    return false
end

local function deleteCam()
    RenderScriptCams(false, false, 1, true, true)
    DestroyCam(FoltoneTattooShop.Cam, true)
    FoltoneTattooShop.Cam = nil
    FoltoneTattooShop.CamRotationOffset = 0.0
    FoltoneTattooShop.CamHeight = 1.0
    FoltoneTattooShop.CamDistance = 2.0
    FoltoneTattooShop.CamSpot = nil
end
local function getOffsetCoordsAroundPoint(centerCoords, baseHeading, offset, rotationOffset)
    local totalHeading = baseHeading + rotationOffset
    local headingRadians = math.rad(totalHeading)
    local directionVector = vector3(-math.sin(headingRadians) * offset, math.cos(headingRadians) * offset, 0.0)
    return centerCoords + directionVector
end
local function createCam(distance, hauteur)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    if FoltoneTattooShop.Cam then
        deleteCam(FoltoneTattooShop.Cam)
    end

    FoltoneTattooShop.CamDistance = distance
    FoltoneTattooShop.CamHeight = hauteur

    local camCoords = getOffsetCoordsAroundPoint(coords, heading, distance, FoltoneTattooShop.CamRotationOffset)
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z + hauteur)
    PointCamAtCoord(camera, coords.x, coords.y, coords.z + hauteur)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 1, true, true)

    return camera
end
local function changeCameraPosition(camera, distance, hauteur)
    FoltoneTattooShop.CamDistance = distance
    FoltoneTattooShop.CamHeight = hauteur
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local camCoords = getOffsetCoordsAroundPoint(coords, heading, distance, FoltoneTattooShop.CamRotationOffset)
    SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z + hauteur)
    PointCamAtCoord(camera, coords.x, coords.y, coords.z + hauteur)
end
local function rotateCamera(camera, angle)
    FoltoneTattooShop.CamRotationOffset = FoltoneTattooShop.CamRotationOffset + angle
    changeCameraPosition(camera, FoltoneTattooShop.CamDistance, FoltoneTattooShop.CamHeight)
end

local menuTattoo = RageUI.CreateMenu("", Trad("subtitle_menu"), nil, nil, "shopui_title_tattoos4", "shopui_title_tattoos4")
local subMenuTattoo = RageUI.CreateSubMenu(menuTattoo, nil, Trad("subtitle_menu"), nil, nil, "shopui_title_tattoos4", "shopui_title_tattoos4")
local open = false
local function closeMenu()
    FreezeEntityPosition(PlayerPedId(), false)
    deleteCam()
    applyOwnPlayerTattoos()
    FoltoneTattooShop.UpdatedMainMenu = false
    RageUI.CloseAll()
    loadSkin()
    open = false
end
function RageUI.PoolMenus:FoltoneTattooShop()
    function menuTattoo.Closed()
        closeMenu()
    end
    menuTattoo:IsVisible(function(Items)
        if IsControlPressed(0, 44) then
            rotateCamera(FoltoneTattooShop.Cam, -1.0)
        end
        menuTattoo:AddInstructionButton({ GetControlInstructionalButton(2, 44, 0), Trad("rotate_left") })
        if IsControlPressed(0, 38) then
            rotateCamera(FoltoneTattooShop.Cam, 1.0)
        end
        menuTattoo:AddInstructionButton({ GetControlInstructionalButton(2, 38, 0), Trad("rotate_right") })
        if not FoltoneTattooShop.UpdatedMainMenu then
            ClearPedDecorationsLeaveScars(PlayerPedId())
            applyOwnPlayerTattoos()
            FoltoneTattooShop.UpdatedMainMenu = true
        end
        for k, v in pairs(Config.CategoriesLabel) do
            Items:AddButton(v.label, nil, { RightLabel = ">>>" }, function(onSelected)
                if (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_TORSO" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.5, 0.3)
                elseif (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_HEAD" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.35, 0.7)
                elseif (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_HAIR" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.35, 0.7)
                elseif (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_LEFT_ARM" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.7, 0.1)
                elseif (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_RIGHT_ARM" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.7, 0.1)
                elseif (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_LEFT_LEG" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.7, -0.6)
                elseif (not FoltoneTattooShop.CamSpot or FoltoneTattooShop.CamSpot ~= v.name) and v.name == "ZONE_RIGHT_LEG" then
                    FoltoneTattooShop.CamSpot = v.name
                    changeCameraPosition(FoltoneTattooShop.Cam, 0.7, -0.6)
                end
                if onSelected then
                    FoltoneTattooShop.CategorieSelected = Config.TattoosCategories[v.name]
                    RageUI.NextMenu = subMenuTattoo
                end
            end)
        end
    end, function(Panels)
    end)
    subMenuTattoo:IsVisible(function(Items)
        if IsControlPressed(0, 44) then
            rotateCamera(FoltoneTattooShop.Cam, -1.0)
        end
        subMenuTattoo:AddInstructionButton({ GetControlInstructionalButton(2, 44, 0), Trad("rotate_left") })
        if IsControlPressed(0, 38) then
            rotateCamera(FoltoneTattooShop.Cam, 1.0)
        end
        subMenuTattoo:AddInstructionButton({ GetControlInstructionalButton(2, 38, 0), Trad("rotate_right") })
        FoltoneTattooShop.UpdatedMainMenu = false
        for i = 1, #FoltoneTattooShop.CategorieSelected do
            local v = FoltoneTattooShop.CategorieSelected[i]
            local label = GetLabelText(v.name)
            if label == "NULL" and string.sub(v.name, 1, 4) == "hair" then
                label = string.format("%s #%s", Trad("hair"), i)
            else
                label = v.label
            end
            if alreadyHaveTattoo(v.collection, v.name) then
                Items:AddButton(label, Trad("remove_tattoo", Config.Price), { RightBadge = RageUI.BadgeStyle.Tattoo }, function(onSelected)
                    if onSelected then
                        if ESX.GetAccount("money").money >= Config.Price then
                            for k2, v2 in pairs(FoltoneTattooShop.PlayerTattoos) do
                                if string.lower(v2.collection) == string.lower(v.collection) and string.lower(v2.name) == string.lower(v.name) then
                                    table.remove(FoltoneTattooShop.PlayerTattoos, k2)
                                    break
                                end
                            end
                            TriggerServerEvent("foltone_tattooshop:removeTattoo", FoltoneTattooShop.PlayerTattoos)
                            applyOwnPlayerTattoos()
                        else
                            Config.Notification(Trad("not_enough_money"))
                        end
                    end
                end)
            else
                Items:AddButton(label, nil, { RightLabel = string.format("~g~%s$", Config.Price) }, function(onSelected)
                    if FoltoneTattooShop.LastTattoo ~= v.name then
                        ClearPedDecorationsLeaveScars(PlayerPedId())
                        FoltoneTattooShop.LastTattoo = v.name
                        applyOwnPlayerTattoos()
                        applyPlayerTattoo(v)
                    end
                    if onSelected then
                        if ESX.GetAccount("money").money >= Config.Price then
                            FoltoneTattooShop.PlayerTattoos[#FoltoneTattooShop.PlayerTattoos + 1] = v
                            applyOwnPlayerTattoos()
                            TriggerServerEvent("foltone_tattooshop:buyTattoo", FoltoneTattooShop.PlayerTattoos, Config.Price)
                        else
                            Config.Notification(Trad("not_enough_money"))
                        end
                    end
                end)
            end
        end
    end, function(Panels)
    end)
end

CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(500)
    end
    for i = 1, #Config.TattooShopPositions do
        local blip = AddBlipForCoord(Config.TattooShopPositions[i])
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
    while true do
        local wait = 750
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(Config.TattooShopPositions) do
            local distance = #(playerCoords - v)
            if distance <= 3.0 and not open and not FoltoneTattooShop.Timeout then
                wait = 0
                Config.DisplayText(Trad("press_access"))
                if IsControlJustPressed(0, 38) then
                    open = true
                    FreezeEntityPosition(playerPed, true)
                    setNaked()
                    FoltoneTattooShop.Cam = createCam(1.0, 0.5)
                    RageUI.Visible(menuTattoo, not RageUI.Visible(menuTattoo))
                end
            elseif distance > 3.0 and distance < 10.0 and open then
                closeMenu()
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)
AddEventHandler("skinchanger:modelLoaded", function()
    ESX.TriggerServerCallback("foltone_tattooshop:getPlayerTattoos", function(tattoos)
        if tattoos and #tattoos > 0 then
            FoltoneTattooShop.PlayerTattoos = tattoos
            applyOwnPlayerTattoos()
        else
            FoltoneTattooShop.PlayerTattoos = {}
        end
    end)
end)
RegisterNetEvent("foltone_tattooshop:notification")
AddEventHandler("foltone_tattooshop:notification", function(message)
    Config.Notification(message)
end)
