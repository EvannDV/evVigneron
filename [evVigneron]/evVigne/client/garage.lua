ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)




------------------------Menu

evStock = {}


function evGarageV()

    local evGarageVShop = RageUI.CreateMenu("Garage", "intéractions")
    

    RageUI.Visible(evGarageVShop, not RageUI.Visible(evGarageVShop))

    while evGarageVShop do


        Citizen.Wait(0)
        RageUI.IsVisible(evGarageVShop, true, true, true, function()


            
            if #evStock < 1 then
                RageUI.Separator("")
                RageUI.Separator("~r~Pas de véhicules")
                RageUI.Separator("")
            else
                for i = 1, #evStock, 1 do
                    RageUI.ButtonWithStyle("→ "..evStock[i].veh, nil, {RightLabel = "Stock [~b~"..evStock[i].stock.."~s~]"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if evStock[i].stock ~= 0 then
                                TriggerServerEvent('ev:RemooveVeh', evStock[i].veh)
                                evRefresh()
                                RageUI.CloseAll()
                            else
                                ESX.ShowNotification("Pas de véhicules en stock !")
                            end
                        end
                    end)
                end
            end
        
        end)


        if not RageUI.Visible(evGarageVShop) then
            evGarageVShop=RMenu:DeleteType("evGarageVShop", true)
        end
    end
end



function evRefresh()
    Citizen.Wait(100)
    ESX.TriggerServerCallback('ev:recupStock', function(stock)
        evStock = stock
    end)
end


-- Marker garage
Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
                for k in pairs {vector3(-1919.8020019531,2048.9167480469,140.73526000977)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-1919.8020019531,2048.9167480469,140.73526000977)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(6, -1919.8020019531,2048.9167480469,140.73526000977-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ouvrir le garage")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then
                        ESX.TriggerServerCallback('ev:recupStock', function(stock)
                            evStock = stock
                        end)
                        evGarageV()
                    end
                end
            end
            end

    Citizen.Wait(wait)
    end
end)





-- Marker garage RENTRER
Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
                for k in pairs {vector3(-1922.4827880859,2040.5980224609,140.73487854004)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-1922.4827880859,2040.5980224609,140.73487854004)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(6, -1922.4827880859,2040.5980224609,140.73487854004-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 5.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour rentrer le vehicule dans le garage")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then
                        local voiture = GetVehiclePedIsIn(PlayerPedId(), false)
                        local pro = GetEntityModel(voiture)
                        print(pro)
                        if voiture == 0 then
                            ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
                        else
                            if pro == -344943009 then
                                TriggerServerEvent('ev:AddVeh', "blista")
                                ESX.Game.DeleteVehicle(voiture)
                            elseif pro == -2107990196 then
                                TriggerServerEvent('ev:AddVeh', "guardian")
                                ESX.Game.DeleteVehicle(voiture)
                            else
                                ESX.ShowNotification("Vous ne pouvez pas ranger ce vehicule")
                            end
                        end
                    end
                end
            end
            end

    Citizen.Wait(wait)
    end
end)






RegisterNetEvent('ev:SpawnVigne')
AddEventHandler('ev:SpawnVigne', function(voit)

    local model = GetHashKey(voit)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    local pos = GetEntityCoords(PlayerPedId())
    local vehicle = CreateVehicle(model, -1913.1351318359,2039.5850830078,140.73687744141, 219.4046173095703, true, false)
end)