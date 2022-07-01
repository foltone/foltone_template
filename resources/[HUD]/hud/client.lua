local lastValues = {}
local currentValues = {
	["health"] = 100,
	["armor"] = 100,
	["hunger"] = 100,
	["thirst"] = 100,
}

currentValues["hunger"] = 100
currentValues["thirst"] = 100

hunger = "Full"
thirst = "Sustained"
local cruise = {
	enabled = false,
	airTime = 0
}

Citizen.CreateThread(function()
    while true do
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)

                local myhunger = hunger.getPercent()
                local mythirst = thirst.getPercent()

                SendNUIMessage({
                    action = "updateStatusHud",
					varSetHunger = myhunger,
					varSetThirst = mythirst,
                })
            end)
        end)
        Citizen.Wait(500)
    end
end)

currentValues["hunger"] = 0
currentValues["thirst"] = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			currentValues["hunger"]  = status.val/1000000*100
		end)
		TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			currentValues["thirst"] = status.val/1000000*100
		end)
	end
end)

-- this should just use nui instead of drawrect - it literally ass fucks usage.
Citizen.CreateThread(function()
	local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(500)
	SetRadarBigmapEnabled(false, true)
	
	local counter = 0
	local get_ped = PlayerPedId() -- current ped
	currentValues["health"] = (GetEntityHealth(get_ped) - 100)
	currentValues["voice"] = 0
	currentValues["armor"] = GetPedArmour(get_ped)
	
	while true do
		Citizen.Wait(50)

		if sleeping then
			if IsControlJustReleased(0,38) then
				sleeping = false
				DetachEntity(PlayerPedId(), 1, true)
			end
		end

		
		if GetEntityMaxHealth(GetPlayerPed(-1)) ~= 200 then
			SetEntityMaxHealth(GetPlayerPed(-1), 200)
			SetEntityHealth(GetPlayerPed(-1), 200)
		end

		if counter == 0 then
			
			 -- current ped
			get_ped = PlayerPedId()
			SetPedSuffersCriticalHits(get_ped,false)
			currentValues["health"] = GetEntityHealth(get_ped) - 100
			currentValues["armor"] = GetPedArmour(get_ped)



			if currentValues["hunger"] < 0 then
				currentValues["hunger"] = 0
			end
			if currentValues["thirst"] < 0 then
				currentValues["thirst"] = 0
			end

			if currentValues["hunger"] > 100 then currentValues["hunger"] = 100 end

			if currentValues["health"] < 1 then currentValues["health"] = 100 end
			if currentValues["thirst"] > 100 then currentValues["thirst"] = 100 end
			local valueChanged = false

			for k,v in pairs(currentValues) do
				if lastValues[k] == nil or lastValues[k] ~= v then
					valueChanged = true
					lastValues[k] = v
				end
			end

			if valueChanged then
				SendNUIMessage({
					type = "updateStatusHud",
					varSetHealth = currentValues["health"],
					varSetArmor = currentValues["armor"],
					varSetHunger = currentValues["hunger"],
					varSetThirst = currentValues["thirst"],
					colorblind = colorblind,
				})
			end

			counter = 25

		end

		counter = counter - 1

        

		BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
	end
end)