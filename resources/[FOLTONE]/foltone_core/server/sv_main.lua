ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('foltone:clearinventaire', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() > 0 then
        xPlayer.removeMoney(xPlayer.getMoney())
      end
      if xPlayer.getAccount('black_money').money > 0 then
        xPlayer.setAccountMoney('black_money', 0)
      end
  
      for i=1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].count > 0 then
          xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
        end
      end
      for i=1, #xPlayer.loadout, 1 do
        xPlayer.removeWeapon(xPlayer.loadout[i].name)
      end  
    cb()
end)