ESX = exports["es_extended"]:getSharedObject()

ESX.PlayerData = {}
ESX.PlayerLoaded = false

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

CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(500)
    end
    local health = 100
    local armor = 0
    local food = 0
    local water = 0


    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    
    local playerPed = PlayerPedId()
    
    while true do 
        local wait = 750

        if Config.disableHudPauseMenu then
            if IsPauseMenuActive() then 
                pauseMenu = true
                close()
            elseif not IsPauseMenuActive() and pauseMenu then
                pauseMenu = false
                open()
            end
        end

        local pedhealth = GetEntityHealth(playerPed)

        SetRadarBigmapEnabled(false, false)
        if Config.disableHealthArmor then
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
        end

        if pedhealth < 100 then
            health = 0
        else
            pedhealth = pedhealth - 100
            health = pedhealth
        end
        
        armor = GetPedArmour(playerPed)

        TriggerEvent("esx_status:getStatus", "hunger", function(hunger)
            TriggerEvent("esx_status:getStatus", "thirst", function(thirst)
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

        Wait(wait)
    end
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)
