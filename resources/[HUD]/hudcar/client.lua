local enableCruise = false
local motorcruise = false

function getVehicleInDirection(coordFrom, coordTo)
    local playerPed = PlayerPedId()
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, playerPed, 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
local pedInVeh = false
Citizen.CreateThread(function()
	local currSpeed = 0.0
	while true do
		sleep = 2000
		local player = PlayerPedId()
		local position = GetEntityCoords(player)
		local vehicle = GetVehiclePedIsIn(player, false)

		-- Set vehicle states
		if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
            sleep = 5
		else
			-- Reset states when not in car
			pedInVeh = false
			motorcruise = false
		end
		local vehicleClass = GetVehicleClass(vehicle)
		if pedInVeh and vehicleClass ~= 13 then
			local prevSpeed = currSpeed
			currSpeed = GetEntitySpeed(vehicle)

			-- Set PED flags
			SetPedConfigFlag(player, 32, true)

            
            
        end
        Citizen.Wait(sleep)
	end
end)

local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed, false)
local Mph = GetEntitySpeed(vehicle) * 3.6
local uiopen = false
local colorblind = false

RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)


Citizen.CreateThread(function()
    while true do
        local pPed = GetPlayerPed(-1)
        local pInVeh = IsPedInAnyVehicle(pPed, false)
        if pInVeh then
            Citizen.Wait(0)
            local player = PlayerPedId()
 
            if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then          
                if not uiopen then
                    uiopen = true
                    SendNUIMessage({
                      open = 1,
                    }) 
                end
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                Fuel = exports["LegacyFuel"]:GetFuel(vehicle)
                Mph = math.ceil(GetEntitySpeed(vehicle) * 3.6)
                
    
                local atl = false
                if IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed) then
                    atl = string.format("%.1f", GetEntityHeightAboveGround(vehicle) * 3.28084)
                end
                local engine = false
                if GetVehicleEngineHealth(vehicle) < 400.0 then
                    engine = true
                end
                local GasTank = false
                if GetVehiclePetrolTankHealth(vehicle) < 3002.0 then
                    GasTank = true
                end
                SendNUIMessage({
                  open = 2,
                  mph = Mph,
                  fuel = math.ceil(Fuel),
                  street = street,
                  colorblind = colorblind,
                  atl = atl,
                  engine = engine,
                  GasTank = GasTank
                }) 
            else
                if uiopen then
                    SendNUIMessage({
                      open = 3,
                    }) 
    
                    uiopen = false
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)