ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)







ESX.RegisterServerCallback('ev:recupStock', function(source, cb)
    local stock = {}

    MySQL.Async.fetchAll('SELECT * FROM vignoble_veh', {
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(stock, {
                veh = result[i].veh,
                stock = result[i].stock,
            })
        end

        cb(stock)
    end)
end)


RegisterNetEvent('ev:RemooveVeh')
AddEventHandler('ev:RemooveVeh', function(voit)
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM vignoble_veh WHERE veh = @veh', {['@veh'] = voit}, function(data)
        local stockP = data[1].stock
            MySQL.Async.fetchAll('SELECT * FROM vignoble_veh WHERE veh = @veh', {['@veh'] = voit}, function(data)
                local stockAct = data[1].stock
                MySQL.Async.execute('UPDATE `vignoble_veh` SET `stock`=@stock  WHERE veh=@veh', {['@stock'] = stockAct - 1, ['@veh'] = voit }, function(rowsChange)
                    TriggerClientEvent('esx:showNotification', source, "Vous venez de ~g~sortir~s~ le véhicule au garage !")
                    TriggerClientEvent('ev:SpawnVigne', source, voit)
                end)
                
            end)
        
    end)
end)


RegisterNetEvent('ev:AddVeh')
AddEventHandler('ev:AddVeh', function(voit)
    local source = source
    MySQL.Async.fetchAll('SELECT * FROM vignoble_veh WHERE veh = @veh', {['@veh'] = ""..voit..""}, function(data)
        local stockP = data[1].stock
            MySQL.Async.execute('UPDATE `vignoble_veh` SET `stock`=@stock  WHERE veh=@veh', {['@stock'] = stockP + 1, ['@veh'] = voit }, function(rowsChange)
                TriggerClientEvent('esx:showNotification', source, "Vous venez de ~r~rentrer~s~ le véhicule au garage !")
            end)
                
        
    end)
end)






