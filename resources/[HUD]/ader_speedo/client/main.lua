Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)

        Citizen.Wait(Config['TickTime'])

        if isInVehicle then

            Citizen.Wait(0)

            local vehicle = GetVehiclePedIsIn(ped, false)
            local fuel = GetVehicleFuelLevel(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local speed = GetEntitySpeed(vehicle)*3.6 -- KMH
            -- local speed = GetEntitySpeed(vehicle)*2.236936 -- MPH

            SendNUIMessage({
                isInVehicle = isInVehicle;
                speed = speed;
                fuel = fuel;
                gear = gear;
            });
        else
            SendNUIMessage({
                isInVehicle = false;
            });
        end
    end
end)
