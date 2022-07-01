local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function ShowHelpNotification(msg, beep)
	local beep = beep
	if beep == nil then
		beep = true
	end
	AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
	EndTextCommandDisplayHelp(0, false, beep, 1)
end

local CONTROLS = {
		TOGGLE = {"", 183 --[[INPUT_CELLPHONE_CAMERA_GRID]]},
		ENABLE = {"Activer les sirènes", 183 --[[INPUT_CELLPHONE_CAMERA_GRID]]},
		DISABLE = {"Désactiver les sirènes", 183 --[[INPUT_CELLPHONE_CAMERA_GRID]]},
		LIGHTS = {"Coupé les gyros", 86 --[[INPUT_VEH_HORN]]},
}

Citizen.CreateThread(function()
	local Wait = Wait
	local GetVehiclePedIsUsing = GetVehiclePedIsUsing
	local PlayerPedId = PlayerPedId
	local IsVehicleSirenOn = IsVehicleSirenOn
	local DisableControlAction = DisableControlAction
	local IsDisabledControlJustPressed = IsDisabledControlJustPressed
	local DecorExistOn = DecorExistOn
	local DecorGetBool = DecorGetBool
	local DecorSetBool = DecorSetBool
	local PlaySoundFrontend = PlaySoundFrontend

	DecorRegister("esc_siren_enabled", 2)
	while true do	
		local veh = GetVehiclePedIsUsing(PlayerPedId())
		local wait = 500
		if veh then
			if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
				wait = 0
				if IsVehicleSirenOn(veh) then
					DisableControlAction(0, CONTROLS['TOGGLE'][2], true)
					if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
						ShowHelpNotification("Appuyer sur ~INPUT_CELLPHONE_CAMERA_GRID~ pour ~r~désactiver~s~ les sirènes", false)
						if IsDisabledControlJustPressed(0, CONTROLS['TOGGLE'][2]) then
							DecorSetBool(veh, "esc_siren_enabled", false)
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						end
					else
						if not DecorExistOn(veh, "esc_siren_enabled") then
							DecorSetBool(veh, "esc_siren_enabled", false)
						end
						ShowHelpNotification("Appuyer sur ~INPUT_CELLPHONE_CAMERA_GRID~ pour ~g~activer~s~ les sirènes", false)
						if IsDisabledControlJustPressed(0, CONTROLS['TOGGLE'][2]) then
							DecorSetBool(veh, "esc_siren_enabled", true)
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						end
					end
				end
			end
		end
        Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	local EnumerateVehicles = EnumerateVehicles
	local DecorExistOn = DecorExistOn
	local DecorGetBool = DecorGetBool
	local DisableVehicleImpactExplosionActivation = DisableVehicleImpactExplosionActivation
	local wait = 500
	while true do
		Wait(wait)
		for veh in EnumerateVehicles() do
			if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
				DisableVehicleImpactExplosionActivation(veh, false)
			else
				DisableVehicleImpactExplosionActivation(veh, true)
			end
		end
	end
end)