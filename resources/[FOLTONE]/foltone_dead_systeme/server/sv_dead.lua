TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('foltone:clearInventaire', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  for i=1, #xPlayer.inventory, 1 do
    if xPlayer.inventory[i].count > 0 then
      xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
    end
  end
  cb()
end)

ESX.RegisterServerCallback('foltone:clearLoadout', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  for i=1, #xPlayer.loadout, 1 do
    xPlayer.removeWeapon(xPlayer.loadout[i].name)
  end  
  cb()
end)

ESX.RegisterServerCallback('foltone:clearMoney', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() > 0 then
        xPlayer.removeMoney(xPlayer.getMoney())
    end
  cb()
end)

ESX.RegisterServerCallback('foltone:clearBlackMoney', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('black_money').money > 0 then
      xPlayer.setAccountMoney('black_money', 0)
    end
  cb()
end)

ESX.RegisterCommand('revive', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent('foltone:revive')
end, true, {help = 'revive', validate = true, arguments = {
{name = 'playerId', help = "id player", type = 'player'}
}})
