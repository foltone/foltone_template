Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

local IsDead = false

AddEventHandler('esx:onPlayerDeath', function(data)
	IsDead = true
	startDead()
	StartScreenEffect('DeathFailOut', 0, false)
end)

function messageTimer(text)
	-- Texte timer
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextOutline()
	SetTextCentre(true)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5, 0.8)
	-- Message style gta
	local request = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
	if HasScaleformMovieLoaded(request) then
		PushScaleformMovieFunction(request, "SHOW_SHARD_WASTED_MP_MESSAGE")
		BeginTextComponent("STRING")
		AddTextComponentString(_U('you_dead'))
		EndTextComponent()
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(request, 255, 255, 255, 255)
	end
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0
	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		return --[[hours, mins,]] secs
	end
end

function startDead()
	local earlySpawnTimer = ESX.Math.Round(Config.firstTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.secondTimer / 1000)

	Citizen.CreateThread(function()
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(1000)
			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_possible_in', secondsToClock(earlySpawnTimer))
			messageTimer(text)
		end
		while bleedoutTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_auto_in', secondsToClock(bleedoutTimer))
			if not false then
				text = text .. _U('push_key_for_respawn')
				if IsControlPressed(0, 38) and timeHeld > 60 then
					respawnAuto()
					break
				end
			end
			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end
			messageTimer(text)
		end
		if bleedoutTimer < 1 and IsDead then
			respawnAuto()
		end
	end)
end

function respawnAuto()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		local CoordsRespawn = Config.position
		ESX.SetPlayerData('lastPosition', CoordsRespawn)
		TriggerServerEvent('esx:updateLastPosition', CoordsRespawn)
		respawnPed(playerPed, CoordsRespawn, 249.668)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		Citizen.Wait(10)
		if Config.clearInventaire then
			ESX.TriggerServerCallback('foltone:clearInventaire', function()
			end)
		end
		if Config.clearLoadout then
			ESX.TriggerServerCallback('foltone:clearLoadout', function()
				ESX.SetPlayerData('loadout', {})
			end)
		end
		if Config.clearMoney then
			ESX.TriggerServerCallback('foltone:clearMoney', function()
			end)
		end
		if Config.clearBlackMoney then
			ESX.TriggerServerCallback('foltone:clearBlackMoney', function()
			end)
		end
		ClearPedTasksImmediately(playerPed)
		ESX.ShowNotification(_U('respawn_now'))
	end)
end

function respawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	IsDead = false
	ClearPedBloodDamage(ped)
end

RegisterNetEvent('foltone:revive')
AddEventHandler('foltone:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		respawnPed(playerPed, formattedCoords, 0.0)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)
