local FoltoneLocation = {
	Timout = false,
	LocationSelected = nil,
	ListIndex = 1,
	ListPay = {
		"Liquide",
		"Banque",
	},
	PreviewVehicle = nil,
	LastVehicle = nil,
}

local function setTimout(time)
	FoltoneLocation.Timout = true
	SetTimeout(time, function()
		FoltoneLocation.Timout = false
	end)
end
local function StopPreviewLoc()
	DeleteEntity(FoltoneLocation.PreviewVehicle)
	FoltoneLocation.PreviewVehicle = nil
	FoltoneLocation.LastVehicle = nil
end
local function StartPreviewLoc(menuPosition, model)
	if not menuPosition then
		return
	end
	local vehicleModel = model
	if vehicleModel == FoltoneLocation.LastVehicle then
		return
	elseif FoltoneLocation.PreviewVehicle then
		DeleteEntity(FoltoneLocation.PreviewVehicle)
		FoltoneLocation.PreviewVehicle = nil
	end
	RequestModel(vehicleModel)
	while not HasModelLoaded(vehicleModel) do
		Wait(0)
	end
	local coords = vector3(menuPosition.x, menuPosition.y, menuPosition.z)
	local heading = menuPosition.w
	local vehicle = CreateVehicle(vehicleModel, coords, heading, true, false)
	SetEntityAlpha(vehicle, 180, 180)
	SetEntityCollision(vehicle, false, false)
	FreezeEntityPosition(vehicle, true)
	FoltoneLocation.PreviewVehicle = vehicle
	FoltoneLocation.LastVehicle = vehicleModel
end
local function PlaceEnable()
	local spawnPos = nil
	for i = 1, #Config.LocationList[FoltoneLocation.LocationSelected].SpawnVehiclePositions do
		local position = vector3(Config.LocationList[FoltoneLocation.LocationSelected].SpawnVehiclePositions[i].x, Config.LocationList[FoltoneLocation.LocationSelected].SpawnVehiclePositions[i].y, Config.LocationList[FoltoneLocation.LocationSelected].SpawnVehiclePositions[i].z)
		if ESX.Game.IsSpawnPointClear(position, 2.0) then
			spawnPos = Config.LocationList[FoltoneLocation.LocationSelected].SpawnVehiclePositions[i]
			break
		end
	end
	return spawnPos
end
local function spawnVehicle(model, position)
	local newPlate = "LOC"..math.random(10000,99999)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do Wait(1) end
	local veh = CreateVehicle(GetHashKey(model), position, 270.00, true, false)
	TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)	
	SetVehicleNumberPlateText(veh, newPlate)
    SetEntityAsMissionEntity(veh, 1, 1)
	for _ = 1, 3 do
		for alpha = 255, 105, -5 do
			SetEntityAlpha(veh, alpha, alpha)
			Wait(transitionDuration)
		end

		for alpha = 105, 255, 5 do
			SetEntityAlpha(veh, alpha, alpha)
			Wait(transitionDuration)
		end
	end
end

ESX = exports["es_extended"]:getSharedObject()

local MenuLocation = RageUI.CreateMenu(_U("menu_title"), _U("menu_subtitle"))
local open = false
function RageUI.PoolMenus:Foltone()
	MenuLocation.Closed = function()
		StopPreviewLoc()
		open = false
	end
	MenuLocation:IsVisible(function(Items)
		Items:AddList("Mode de paiement", FoltoneLocation.ListPay, FoltoneLocation.ListIndex, FoltoneLocation.ListIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			StopPreviewLoc()
			if onListChange then
				FoltoneLocation.ListIndex = Index;
			end
		end)
		for i = 1, #Config.LocationList[FoltoneLocation.LocationSelected].VehiclesList do
			Items:AddButton(Config.LocationList[FoltoneLocation.LocationSelected].VehiclesList[i].name, nil, {RightLabel = string.format("~g~%s$", Config.LocationList[FoltoneLocation.LocationSelected].VehiclesList[i].price), IsDisabled = FoltoneLocation.Timout }, function(onSelected)
				StartPreviewLoc(Config.LocationList[FoltoneLocation.LocationSelected].PreviewPosition, Config.LocationList[FoltoneLocation.LocationSelected].VehiclesList[i].model)
				if onSelected then
					setTimout(500)
					local place = PlaceEnable()
					if place then
						ESX.TriggerServerCallback("foltone_location:rentVehicle", function(cb)
							if cb then
								RageUI.CloseAll()
								StopPreviewLoc()
								spawnVehicle(Config.LocationList[FoltoneLocation.LocationSelected].VehiclesList[i].model, place)
								Config.Notification(_U("vehicle_out"))
							else
								Config.Notification(_U("no_money"))
							end
						end, Config.LocationList[FoltoneLocation.LocationSelected].VehiclesList[i].price, FoltoneLocation.ListIndex)
					else
						Config.Notification(_U("no_place"))
					end
				end
			end)
		end
	end, function(Panels)
	end)
end

CreateThread(function()
	while not ESX.PlayerLoaded do Wait(500) end
	for i = 1, #Config.LocationList do
		local ped = Config.LocationList[i].PedModel
		RequestModel(GetHashKey(ped))
		while not HasModelLoaded(GetHashKey(ped)) do Wait(1) end
		local ped = CreatePed(4, GetHashKey(ped), Config.LocationList[i].PedPosition, Config.LocationList[i].PedPosition.w, false, false)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

		if Config.LocationList[i].Blip.Enable then
			local blip = AddBlipForCoord(Config.LocationList[i].PedPosition.x, Config.LocationList[i].PedPosition.y, Config.LocationList[i].PedPosition.z)
			SetBlipSprite(blip, Config.LocationList[i].Blip.Sprite)
			SetBlipColour(blip, Config.LocationList[i].Blip.Color)
			SetBlipScale(blip, Config.LocationList[i].Blip.Scale)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.LocationList[i].Blip.Name)
			EndTextCommandSetBlipName(blip)
		end
	end

	while true do
		local wait = 500
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		for k, v in pairs(Config.LocationList) do
			local distance = #(playerCoords - vector3(v.PedPosition.x, v.PedPosition.y, v.PedPosition.z))
			if distance <= 1.5 and not open then
				wait = 0
				Config.DisplayText(_U("press_e"))
				if IsControlJustPressed(1, 51) and not FoltoneLocation.Timout then
					setTimout(500)
					open = true
					FoltoneLocation.LocationSelected = k
					RageUI.Visible(MenuLocation, not RageUI.Visible(MenuLocation))
				end
			elseif distance > 1.5 and open then
				open = false
				RageUI.Visible(MenuLocation, false)
				StopPreviewLoc()
			end
		end
		Wait(wait)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
	ESX.PlayerLoaded = true
end)
