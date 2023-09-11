loaded = false


ESX = exports["es_extended"]:getSharedObject()


Citizen.CreateThread(function()
    loaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)

local health = 100
local armor = 0
local food = 0
local water = 0

function open()
    SendNUIMessage({
        type = "hud",
        status = true,
    })
end

function close()
    SendNUIMessage({
        type = "hud",
        status = false,
    })
end

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    while loaded == false do
        Citizen.Wait(300)
    end
    while true do 
        Citizen.Wait(300)
        SetRadarBigmapEnabled(false, false)
        if Config.disableHealthArmor then
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
        end
        
        local ped = GetPlayerPed(-1)
        local playerId = PlayerId()
        local pedhealth = GetEntityHealth(ped)
        SetPlayerHealthRechargeMultiplier(playerId, 0)

        if pedhealth < 100 then
            health = 0
        else
            pedhealth = pedhealth - 100
            health = pedhealth
        end
        
        armor = GetPedArmour(ped)

        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
              food = hunger.getPercent()
              water = thirst.getPercent()
            end)
        end)

        SendNUIMessage({
            type = "update",
            health = health,
            armor = armor,
            food = food,
            water = water,
        })
    end
end)

Citizen.CreateThread(function()
    while loaded == false do
        Citizen.Wait(500)
    end
    local pauseMenu = false
    while true do
        Citizen.Wait(500)
        if Config.disableHudPauseMenu then
            if IsPauseMenuActive() then 
                pauseMenu = true
                close()
            elseif not IsPauseMenuActive() and pauseMenu then
                pauseMenu = false
                open()
            end
        end
    end
end)
