local FoltoneBank = {
    Timeout = false,
    BankOrATMSelected = 0
}

local function setTimeout(time)
    FoltoneBank.Timeout = true
    SetTimeout(time, function()
        FoltoneBank.Timeout = false
    end)
end
local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

ESX = exports["es_extended"]:getSharedObject()

local bankMenu = RageUI.CreateMenu(_U("bank"), _U("bank_menu"))
local open = false

function RageUI.PoolMenus:Foltone()
	bankMenu.Closed = function()
		open = false
	end
	bankMenu:IsVisible(function(Items)
        for i = 1, #ESX.PlayerData.accounts do
            local account = ESX.PlayerData.accounts[i]
            if account.name == "bank" then
                Items:AddButton(_U("bank_balance"), nil, {RightLabel = string.format("~b~%s$", account.money)}, function(onselected, onactive)
                end)
            elseif account.name == "money" then
                Items:AddButton(_U("money"), nil, {RightLabel = string.format("~g~%s$", account.money)}, function(onselected, onactive)
                end)
            end
        end
        for i = 1, #ESX.PlayerData.accounts do
            local account = ESX.PlayerData.accounts[i]
            if account.name == "bank" then
                Items:AddButton(_U("withdraw"), nil, { RightLabel = "", IsDisabled = FoltoneBank.Timeout }, function(onselected, onactive)
                    if onselected then
                        setTimeout(500)
                        local amount = KeyboardInput(_U("withdraw_amount"), "", 10)
                        if amount then
                            amount = tonumber(amount)
                            if amount then
                                if amount > 0 and account.money >= amount then
                                    ESX.TriggerServerCallback("foltone_bank:withdrawMoney", function(ok)
                                        if ok then
                                            Config.Notification(_U("withdraw_success", amount))
                                        else
                                            Config.Notification(_U("withdraw_error"))
                                        end
                                    end, amount)
                                else
                                    Config.Notification(_U("invalid_amount"))
                                end
                            else
                                Config.Notification(_U("invalid_amount"))
                            end
                        end
                    end
                end)
            elseif account.name == "money" then
                Items:AddButton(_U("deposit"), nil, { RightLabel = "", IsDisabled = FoltoneBank.Timeout }, function(onselected, onactive)
                    if onselected then
                        setTimeout(500)
                        local amount = KeyboardInput(_U("deposit_amount"), "", 10)
                        if amount then
                            amount = tonumber(amount)
                            if amount then
                                if amount > 0 and account.money >= amount then
                                    ESX.TriggerServerCallback("foltone_bank:depositMoney", function(ok)
                                        if ok then
                                            Config.Notification(_U("deposit_success", amount))
                                        else
                                            Config.Notification(_U("deposit_error"))
                                        end
                                    end, amount)
                                else
                                    Config.Notification(_U("invalid_amount"))
                                end
                            else
                                Config.Notification(_U("invalid_amount"))
                            end
                        end
                    end
                end)
            end
        end
        for i = 1, #ESX.PlayerData.accounts do
            local account = ESX.PlayerData.accounts[i]
            if account.name == "bank" then
                Items:AddButton(_U("transfer"), nil, { RightLabel = "", IsDisabled = FoltoneBank.Timeout }, function(onselected, onactive)
                    if onselected then
                        setTimeout(500)
                        local amount = KeyboardInput(_U("transfer_amount"), "", 10)
                        if amount then
                            amount = tonumber(amount)
                            if amount then
                                if amount > 0 and account.money >= amount then
                                    local target = KeyboardInput(_U("transfer_target"), "", 10)
                                    if target then
                                        target = tonumber(target)
                                        if target then
                                            if target > 0 then
                                                ESX.TriggerServerCallback("foltone_bank:transferMoney", function(ok)
                                                    if ok then
                                                        Config.Notification(_U("transfer_success", amount, target))
                                                    else
                                                        Config.Notification(_U("transfer_error"))
                                                    end
                                                end, amount, target)
                                            else
                                                Config.Notification(_U("invalid_target"))
                                            end
                                        else
                                            Config.Notification(_U("invalid_target"))
                                        end
                                    end
                                else
                                    Config.Notification(_U("invalid_amount"))
                                end
                            else
                                Config.Notification(_U("invalid_amount"))
                            end
                        end
                    end
                end)
            end
        end
    end, function(Panels)
	end)
end

CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(500)
    end
    local function CreateBlip(pos, sprite, size, color, name)
        local blip = AddBlipForCoord(pos)
        SetBlipSprite(blip, sprite)
        SetBlipScale(blip, size)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(name)
        EndTextCommandSetBlipName(blip)
    end
    local MenuPositions = {}
    for k, v in pairs(Config.BankPosition) do
        CreateBlip(v, 108, 0.8, 2, _U("bank"))
        table.insert(MenuPositions, v)
    end
    for k, v in pairs(Config.ATMPosition) do
        CreateBlip(v, 277, 0.4, 2, _U("atm"))
        table.insert(MenuPositions, v)
    end
    while true do
        local wait = 500
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        for k, v in pairs(MenuPositions) do
            local distance = #(playerPos - v)
            if distance < 10.0 then
                wait = 0
                Config.Marker(v)
                if distance <= 1.5 and not open then
                    Config.DisplayText(_U("press_to_open"))
                    if IsControlJustPressed(0, 38) then
                        RageUI.Visible(bankMenu, not RageUI.Visible(bankMenu))
                        open = true
                        FoltoneBank.BankOrATMSelected = k
                    end
                elseif distance > 1.5 and open and FoltoneBank.BankOrATMSelected == k then
                    RageUI.CloseAll()
                    open = false
                    FoltoneBank.BankOrATMSelected = 0
                end
            end
        end
        -- for k, v in pairs(Config.BankPosition) do
        --     local distance = #(playerPos - v)
        --     if distance < 10.0 then
        --         wait = 0
        --         Config.Marker(v)
        --         if distance <= 1.5 and not open then
        --             Config.DisplayText(_U("press_to_open"))
        --             if IsControlJustPressed(0, 38) then
        --                 RageUI.Visible(bankMenu, not RageUI.Visible(bankMenu))
        --                 open = true
        --                 FoltoneBank.BankOrATMSelected = k
        --             end
        --         elseif distance > 1.5 and open and FoltoneBank.BankOrATMSelected == k then
        --             print("closed")
        --             RageUI.CloseAll()
        --             open = false
        --             FoltoneBank.BankOrATMSelected = 0
        --         end
        --     end
        -- end
        -- for k, v in pairs(Config.ATMPosition) do
        --     local distance = #(playerPos - v)
        --     if distance <= 1.5 and not open then
        --         wait = 0
        --         Config.DisplayText(_U("press_to_open"))
        --         if IsControlJustPressed(0, 38) then
        --             RageUI.Visible(bankMenu, not RageUI.Visible(bankMenu))
        --             open = true
        --             FoltoneBank.BankOrATMSelected = k
        --         end
        --     elseif distance > 1.5 and open and FoltoneBank.BankOrATMSelected == k then
        --         RageUI.CloseAll()
        --         open = false
        --         FoltoneBank.BankOrATMSelected = 0
        --     end
        -- end
        Wait(wait)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)
RegisterNetEvent("esx:setAccountMoney")
AddEventHandler("esx:setAccountMoney", function(account)
    for i = 1, #ESX.PlayerData.accounts do
        if ESX.PlayerData.accounts[i].name == account.name then
            ESX.PlayerData.accounts[i] = account
            break
        end
    end
end)
