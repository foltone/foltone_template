local current = 0;
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
	ESX.UI.HUD.SetDisplay(0.0)
end)

Citizen.CreateThread(function()
	if (Config.HideOnHidedRadar) then
		while true do
			Citizen.Wait(500)
		if IsPauseMenuActive() then
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({action = "toggle", show = false})
				end
			else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({action = "toggle", show = true})
				end
			end
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer
	local accounts = data.accounts
	for k, v in pairs(accounts) do
		local account = v
		if account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "" .. account.money .. " $"})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "" .. account.money .. " $"})
		elseif account.name == "money" then
			SendNUIMessage({action = "setValue", key = "money", value = "" .. account.money .. " $"})
		end
	end
	SendNUIMessage({action = "setValue", key = "job", value = ('%s - <strong>%s</strong>'):format(data.job.label, data.job.grade_label) })
	SendNUIMessage({action = "setValue", key = "job2", value = ('%s - <strong>%s</strong>'):format(data.job2.label, data.job2.grade_label) })
	SendNUIMessage({action = "setValue", key = "money", value = "$" .. data.money})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "" .. account.money .. " $"})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "" .. account.money .. " $"})
	elseif account.name == "money" then
		SendNUIMessage({action = "setValue", key = "money", value = "" .. account.money .. " $"})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	SendNUIMessage({action = "setValue", key = "job", value = ('%s - <strong>%s</strong>'):format(job.label, job.grade_label) })
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	SendNUIMessage({action = "setValue", key = "job2", value = ('%s - <strong>%s</strong>'):format(job2.label, job2.grade_label) })
end)