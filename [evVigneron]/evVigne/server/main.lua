ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)



RegisterNetEvent('ev:submit')
AddEventHandler('ev:submit', function(info)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO vignoble (iden, nom, prenom ,stylep, motivations, discord) VALUES (@iden, @nom, @prenom ,@stylep, @motivations, @dis)',
        {
            ['@iden']   = xPlayer.identifier,
            ['@nom']   = info.nom,
            ['@prenom'] = info.prenom,
            ['@stylep'] = info.styleP,
            ['@motivations'] = info.motivations,
            ['@dis'] = info.nomDiscord,
        }, function (rowsChanged)
            TriggerClientEvent('esx:showNotification', source, "Candidature envoyé ~g~avec succès~s~ !")
    end)
end)


ESX.RegisterServerCallback('ev:recupCandidV', function(source, cb)
    local listeCandidV = {}

    MySQL.Async.fetchAll('SELECT * FROM vignoble WHERE accept=@acc', {['acc'] = 0
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listeCandidV, {
                nom = result[i].nom,
                prenom = result[i].prenom,
                style = result[i].stylep,
                motivations = result[i].motivations,
                ident = result[i].iden,
                dis = result[i].discord,
            })
        end

        cb(listeCandidV)
    end)
end)


RegisterNetEvent('ev:Accepter')
AddEventHandler('ev:Accepter', function(pol)
    local source = source
    MySQL.Async.execute('UPDATE `vignoble` SET `accept`=@o  WHERE iden=@iden', {['@o'] = 1,['iden'] = pol }, function(rowsChange)
        TriggerClientEvent('esx:showNotification', source, "Vous avez accepté le joueur")
    end)
end)

RegisterNetEvent('ev:Refuser')
AddEventHandler('ev:Refuser', function(pol)
    local source = source
    MySQL.Async.execute('DELETE FROM vignoble WHERE iden = @iden', {
        ['@iden'] = pol,
    })
    TriggerClientEvent('esx:showNotification', source, "Vous avez refusé le joueur")
end)



ESX.RegisterServerCallback('ev:recupAccept', function(source, cb)
    local listeAccept = {}

    MySQL.Async.fetchAll('SELECT * FROM vignoble WHERE accept=@ac', {['@ac'] = 1
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(listeAccept, {
                nom = result[i].nom,
                prenom = result[i].prenom,
                style = result[i].stylep,
                motivations = result[i].motivations,
                ident = result[i].iden,
                dis = result[i].discord,
            })
        end

        cb(listeAccept)
    end)
end)










------------- Annonces F6 


RegisterServerEvent('evV:Open')
AddEventHandler('evV:Open', function()
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vigneron', '~y~Annonce', 'Les vignerons sont maintenant ~g~disponibles', 'CHAR_FLOYD', 1)
    end
end)

RegisterServerEvent('evV:Close')
AddEventHandler('evV:Close', function()
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vigneron', '~y~Annonce', 'Les vignerons ne sont ~r~plus disponibles', 'CHAR_FLOYD', 1)
    end
end)

RegisterServerEvent('evv:Perso')
AddEventHandler('evv:Perso', function(tap)
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vigneron', '~y~Annonce', tap, 'CHAR_FLOYD', 1)
    end
end)






------------------------ boss 




RegisterNetEvent('evtest')
AddEventHandler('evtest', function(number)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local sous = xPlayer.getMoney()
    if sous >= tonumber(number) then
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
        account.addMoney(number)
        xPlayer.removeMoney(number)
        TriggerClientEvent('esx:showNotification', source, "Vous venez de dépoer ~b~"..number.."~s~ $")
    end)
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent !")
    end
end)

RegisterNetEvent('evtest2')
AddEventHandler('evtest2', function(number2)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
        account.removeMoney(number2)
        xPlayer.addMoney(number2)
        TriggerClientEvent('esx:showNotification', source, "Vous venez de retirer ~b~"..number2.."~s~ $")
    end)
end)





ESX.RegisterServerCallback('ev:refresh', function(source, cb, accountEv)
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @a', {['@a'] = "society_vigne"}, function(data)
        local accountEv = data[1].money
        cb(accountEv)
    end)
end)








RegisterServerEvent('ev:rank')
AddEventHandler('ev:rank', function(target)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob('vigne', tonumber(xTarget.job.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été promu")
  	TriggerClientEvent('esx:showNotification', target, "Vous avez été promu !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron ou le joueur ne peut pas être promu.")

  end
end)



RegisterServerEvent('ev:derank')
AddEventHandler('ev:derank', function(target)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob('vigne', tonumber(xTarget.job.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été rétrograder")
  	TriggerClientEvent('esx:showNotification', target, "Vous avez été rétrograder !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron ou le joueur ne peut pas être rétrograder.")

  end
end)




RegisterServerEvent('ev:recruter')
AddEventHandler('ev:recruter', function(target)
	local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob("vigne", 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été recruté")
  	TriggerClientEvent('esx:showNotification', target, "Bienvenue dans l'entreprise !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron...")
	end
end)


RegisterServerEvent('ev:virer')
AddEventHandler('ev:virer', function(target)
	local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob("unemployed", 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "Le joueur a été viré")
  	TriggerClientEvent('esx:showNotification', target, "Vous avez été viré !")
  	else
	TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'êtes pas patron...")
	end
end)





----------------- AChat SOciétée 


RegisterNetEvent('ev:BuySoc')
AddEventHandler('ev:BuySoc', function(voit)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if voit == "guardian" then
        MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @a', {['@a'] = "society_vigne"}, function(data)
            accountEv = data[1].money
            local priceev = Config.GuardianPrice
            if accountEv < priceev then
                TriggerClientEvent('esx:showNotification', source, "La société n'a pas assez d'argent")
            else

                TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
                    account.removeMoney(priceev)
                end)
                MySQL.Async.fetchAll('SELECT * FROM vignoble_veh WHERE veh = @veh', {['@veh'] = ""..voit..""}, function(data)
                    local stockP = data[1].stock
                    MySQL.Async.execute('UPDATE `vignoble_veh` SET `stock`=@stock  WHERE veh=@veh', {['@stock'] = stockP + 1, ['@veh'] = voit }, function(rowsChange)
                        TriggerClientEvent('esx:showNotification', source, "Vous venez d'ajouter un véhicule au garage !")
                    end)
                            
                    
                end)
            end
        end)
    else
        MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @a', {['@a'] = "society_vigne"}, function(data)
            accountEv = data[1].money
            local priceev = Config.BlistaPrice
            if accountEv < priceev then
                TriggerClientEvent('esx:showNotification', source, "La société n'a pas assez d'argent")
            else

                TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
                    account.removeMoney(priceev)
                end)
                MySQL.Async.fetchAll('SELECT * FROM vignoble_veh WHERE veh = @veh', {['@veh'] = ""..voit..""}, function(data)
                    local stockP = data[1].stock
                    MySQL.Async.execute('UPDATE `vignoble_veh` SET `stock`=@stock  WHERE veh=@veh', {['@stock'] = stockP + 1, ['@veh'] = voit }, function(rowsChange)
                        TriggerClientEvent('esx:showNotification', source, "Vous venez d'ajouter un véhicule au garage !")
                    end)
                            
                    
                end)
            end
        end)
    end
end)




------------------ COFFRE 




-- Coffre
RegisterServerEvent('evJob:prendreitems')
AddEventHandler('evJob:prendreitems', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then

			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _src, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _src, 'Objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _src, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('evJob:stockitem')
AddEventHandler('evJob:stockitem', function(itemName, count)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _src, "Objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _src, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('evJob:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('evJob:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		cb(inventory.items)
	end)
end)





--------------- evRECOLTE 



RegisterNetEvent('ev:Recolte')
AddEventHandler('ev:Recolte', function(item)
    local source = source
    local limiteitem = 100
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "Tu n'a plus de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Récolte en cours...")
		return
    end
end)



RegisterNetEvent('ev:Trait')
AddEventHandler('ev:Trait', function(item, item2)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbi = xPlayer.getInventoryItem(item).count
    local nbi_pooch = xPlayer.getInventoryItem(item2).count

    if nbi_pooch > 100 then
        TriggerClientEvent('esx:showNotification', source, '~r~Ton sac à dos est plein !')
    elseif nbi < 3 then
        TriggerClientEvent('esx:showNotification', source, 'Pas assez de ~r~raisin~s~ pour traiter...')
    else
        TriggerClientEvent('esx:showNotification', source, '~g~Nettoyage et Traitement en cours...')
        xPlayer.removeInventoryItem(item, 3)
        xPlayer.addInventoryItem(item2, 1)
    end
end)


RegisterNetEvent('ev:Vente')
AddEventHandler('ev:Vente', function(item, item2)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local Ter = xPlayer.getInventoryItem(item2).count
    local Gc = xPlayer.getInventoryItem(item).count

    if Ter == 0 and Gc == 0 then
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez rien a vendre !")
    elseif Ter == 0 then
        xPlayer.removeInventoryItem(item, 1)
        xPlayer.addMoney(Config.rewardsGc)
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
            account.removeMoney((Config.rewardsGc/2))
            print((Config.rewardsGc/2))
        end)
        TriggerClientEvent('esx:showNotification', source, '~g~Vente : ~b~'..Config.rewardsGc..' $')
    elseif Gc == 0 then
        xPlayer.removeInventoryItem(item2, 1)
        xPlayer.addMoney(Config.rewardsTer)
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
            account.removeMoney((Config.rewardsTer/2))
            print((Config.rewardsTer/2))
        end)
        TriggerClientEvent('esx:showNotification', source, '~g~Vente : ~b~'..Config.rewardsTer..' $')
    else
        xPlayer.removeInventoryItem(item, 1)
        xPlayer.addMoney(Config.rewardsGc)
        xPlayer.removeInventoryItem(item2, 1)
        xPlayer.addMoney(Config.rewardsTer)
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_vigne", function (account)
            account.removeMoney((Config.rewardsGc/2))
            account.removeMoney((Config.rewardsTer/2))
            print((Config.rewardsGc/2))
        end)
        TriggerClientEvent('esx:showNotification', source, '~g~Vente : ~b~'..Config.rewardsGc..'~s~ et ~b~'..Config.rewardsTer..' $')
    end
end)