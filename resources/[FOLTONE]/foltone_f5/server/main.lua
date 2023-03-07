ESX = exports["es_extended"]:getSharedObject()

local function makeTargetedEventFunction(fn)
	return function(target, ...)
		if tonumber(target) == -1 then return end
		fn(target, ...)
	end
end

-- Weapon Menu --
RegisterServerEvent('foltone:Weapon_addAmmoToPedS')
AddEventHandler('foltone:Weapon_addAmmoToPedS', function(plyId, value, quantity)
	if #(GetEntityCoords(source, false) - GetEntityCoords(plyId, false)) <= 3.0 then
		TriggerClientEvent('foltone:Weapon_addAmmoToPedC', plyId, value, quantity)
	end
end)

-- facture menu --

ESX.RegisterServerCallback('VInventory:billing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end
		cb(bills)
	end)
end)


function getMaximumGrade(jobName)
	local p = promise.new()

	MySQL.Async.fetchScalar('SELECT grade FROM job_grades WHERE job_name = @job_name ORDER BY `grade` DESC', { ['@job_name'] = jobName }, function(result)
		p:resolve(result)
	end)

	local queryResult = Citizen.Await(p)

	return tonumber(queryResult)
end


RegisterServerEvent('foltone:Boss_promouvoirplayer')
AddEventHandler('foltone:Boss_promouvoirplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('foltone:Boss_destituerplayer')
AddEventHandler('foltone:Boss_destituerplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('foltone:Boss_recruterplayer')
AddEventHandler('foltone:Boss_recruterplayer', function(target, job, grade)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
	end
end)

RegisterServerEvent('foltone:Boss_virerplayer')
AddEventHandler('foltone:Boss_virerplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
		targetXPlayer.setJob('unemployed', 0)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end)


-- RegisterServerEvent('foltone:Boss_promouvoirplayer2')
-- AddEventHandler('foltone:Boss_promouvoirplayer2', makeTargetedEventFunction(function(target)
-- 	local sourceXPlayer = ESX.GetPlayerFromId(source)
-- 	local sourceJob2 = sourceXPlayer.getJob2()

-- 	if sourceJob2.grade_name == 'boss' then
-- 		local targetXPlayer = ESX.GetPlayerFromId(target)
-- 		local targetJob2 = targetXPlayer.getJob2()

-- 		if sourceJob2.name == targetJob2.name then
-- 			local newGrade = tonumber(targetJob2.grade) + 1

-- 			if newGrade ~= getMaximumGrade(targetJob2.name) then
-- 				targetXPlayer.setJob2(targetJob2.name, newGrade)

-- 				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~promu %s~w~.'):format(targetXPlayer.name))
-- 				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~promu par %s~w~.'):format(sourceXPlayer.name))
-- 			else
-- 				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation ~r~Gouvernementale~w~.')
-- 			end
-- 		else
-- 			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
-- 		end
-- 	else
-- 		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
-- 	end
-- end))

-- RegisterServerEvent('foltone:Boss_destituerplayer2')
-- AddEventHandler('foltone:Boss_destituerplayer2', makeTargetedEventFunction(function(target)
-- 	local sourceXPlayer = ESX.GetPlayerFromId(source)
-- 	local sourceJob2 = sourceXPlayer.getJob2()

-- 	if sourceJob2.grade_name == 'boss' then
-- 		local targetXPlayer = ESX.GetPlayerFromId(target)
-- 		local targetJob2 = targetXPlayer.getJob2()

-- 		if sourceJob2.name == targetJob2.name then
-- 			local newGrade = tonumber(targetJob2.grade) - 1

-- 			if newGrade >= 0 then
-- 				targetXPlayer.setJob2(targetJob2.name, newGrade)

-- 				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~rétrogradé %s~w~.'):format(targetXPlayer.name))
-- 				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~r~rétrogradé par %s~w~.'):format(sourceXPlayer.name))
-- 			else
-- 				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
-- 			end
-- 		else
-- 			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
-- 		end
-- 	else
-- 		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
-- 	end
-- end))

-- RegisterServerEvent('foltone:Boss_recruterplayer2')
-- AddEventHandler('foltone:Boss_recruterplayer2', makeTargetedEventFunction(function(target, grade2)
-- 	local sourceXPlayer = ESX.GetPlayerFromId(source)
-- 	local sourceJob2 = sourceXPlayer.getJob2()

-- 	if sourceJob2.grade_name == 'boss' then
-- 		local targetXPlayer = ESX.GetPlayerFromId(target)

-- 		targetXPlayer.setJob2(sourceJob2.name, 0)
-- 		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~recruté %s~w~.'):format(targetXPlayer.name))
-- 		TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~embauché par %s~w~.'):format(sourceXPlayer.name))
-- 	end
-- end))

-- RegisterServerEvent('foltone:Boss_virerplayer2')
-- AddEventHandler('foltone:Boss_virerplayer2', makeTargetedEventFunction(function(target)
-- 	local sourceXPlayer = ESX.GetPlayerFromId(source)
-- 	local sourceJob2 = sourceXPlayer.getJob2()

-- 	if sourceJob2.grade_name == 'boss' then
-- 		local targetXPlayer = ESX.GetPlayerFromId(target)
-- 		local targetJob2 = targetXPlayer.getJob2()

-- 		if sourceJob2.name == targetJob2.name then
-- 			targetXPlayer.setJob2('unemployed2', 0)
-- 			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~viré %s~w~.'):format(targetXPlayer.name))
-- 			TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~viré par %s~w~.'):format(sourceXPlayer.name))
-- 		else
-- 			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
-- 		end
-- 	else
-- 		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
-- 	end
-- end))



local Jobs = {}
local RegisteredSocieties = {}

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data,
	}

	for i = 1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

function GetSociety(name)
	for i = 1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end


ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent("esx_addonaccount:getSharedAccount", society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('foltone:AfficheKeys', function(source, cb, plate)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local AffiKeys = {}

    if xPlayer ~= nil then
        MySQL.Async.fetchAll('SELECT * FROM open_car WHERE identifier = @identifier ', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            for k, v in pairs(result) do
                table.insert(AffiKeys, {
                    id = v.id, 
                    label = v.label,
                    value = v.value,
                    got = v.got,
                    nb = v.nb,
                })
            end
            cb(AffiKeys)
        end)
    end
end)

ESX.RegisterServerCallback('foltone:getWeight', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	playerWeight = xPlayer.getWeight()
	cb(playerWeight)
end)
