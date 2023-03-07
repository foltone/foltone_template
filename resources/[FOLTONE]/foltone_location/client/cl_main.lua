ESX = exports["es_extended"]:getSharedObject()

local TempVehLoc = nil
local TempModelLoc = nil
achat = false

local MenuLocation = RageUI.CreateMenu("Location", "Location");
local ListIndex = 1;
local ListPay = {
    "Liquide",
    "Banque",
}
local Trigger = 'foltone_location:AchatLiquide'


RegisterNetEvent('foltone_location:achatconfirme')
AddEventHandler('foltone_location:achatconfirme', function(model)
    local newPlate = "LOC"..math.random(1010,9090)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do Wait(1) end
    veh = CreateVehicle(GetHashKey(model), Config.PositionVehicule, 270.00, true, false)
    SetVehicleNumberPlateText(veh, newPlate)
    SetEntityAsMissionEntity(veh, 1, 1)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    if Config.GiveDoubleCle == true then
		TriggerServerEvent('foltone_vehiclelock:givekey', 'no', newPlate)
    end
end)

function RageUI.PoolMenus:Foltone()
	MenuLocation:IsVisible(function(Items)
		Items:AddList("Mode de paiement", ListPay, ListIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			StopPrevue()
			if (onListChange) then
				ListIndex = Index;
			end
            if (Index) == 1 then
                Trigger = 'foltone_location:AchatLiquide'
            end
            if (Index) == 2 then
                Trigger = 'foltone_location:AchatBanque'
            end
		end)
		for k,v in pairs(Config.VehiculesList) do
			Items:AddButton(v.name, nil, {RightLabel ="~g~"..v.price.."$", IsDisabled = false }, function(onSelected)
				StartPrevueLocation(v.model, vector3(Config.PositionVehicule), 270.0)
				if (onSelected) then
					TriggerServerEvent(Trigger, v.model, v.price)
					RageUI.CloseAll()
					StopPrevue()
				end
			end)
		end
	end, function(Panels)
	end)
end

CreateThread(function()
    while true do
		local wait = 500
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local pos = Config.Position
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Position)
		if dist <= 8.0 then
			wait = 0
			if IsControlJustPressed(1,177) then
				StopPrevue()
				FreezeEntityPosition(GetPlayerPed(-1), false)
			end
			DrawMarker(36, Config.Position, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 52, 152, 219, 250, false, true, p19, false)  
			if dist <= 1.0 then
				wait = 0
				ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour accéder à la ~g~Location ~s~!")
				if IsControlJustPressed(1,51) then
					RageUI.Visible(MenuLocation, not RageUI.Visible(MenuLocation))
				end
			else
				RageUI.CloseAll()
				DeleteEntity(TempVehLoc)
			end
    	end
	Wait(wait)
	end
end)

Citizen.CreateThread(function()
    if Config.Blip then
		local blip = AddBlipForCoord(Config.Position)

		SetBlipSprite(blip, 225)
		SetBlipScale (blip, 0.6)
		SetBlipColour(blip, 29)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Location')
		EndTextCommandSetBlipName(blip)
    end
end)

function StopPrevue()
    DestroyAllCams(false)
    RenderScriptCams(false, true, 1500, false, false)
    DeleteEntity(TempVehLoc)
    TempVehLoc = nil
    TempModelLoc = nil
	FreezeEntityPosition(GetPlayerPed(-1), false)
end
function StartPrevueLocation(model, coords, heading)
	if Config.Camera == true then
		camloc = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		SetCamActive(camloc, true)
		RenderScriptCams(1, 0, 0, 1, 1)
		SetCamFov(camloc, 40.0)
		SetCamCoord(camloc, Config.PositionCamera)
		PointCamAtCoord(camloc, Config.PositionVehicule)
		FreezeEntityPosition(GetPlayerPed(-1), true)
	end
    if model == TempModelLoc then
        return
    else
        if TempVehLoc ~= nil then
            DeleteEntity(TempVehLoc)
            TempVehLoc = nil
        end
        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do Wait(1) end
        TempModelLoc = model
        TempVehLoc = CreateVehicle(GetHashKey(model), coords, heading, 0, 0)
        FreezeEntityPosition(TempVehLoc, true)
        SetEntityAlpha(TempVehLoc, 180, 180)
    end
end