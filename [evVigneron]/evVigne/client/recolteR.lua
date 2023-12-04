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








function OpenR()
    local openRR = RageUI.CreateMenu("Raisin", "Vignoble")

    RageUI.Visible(openRR, not RageUI.Visible(openRR))
        while openRR do
            FreezeEntityPosition(PlayerPedId(), true)
        Wait(0)
        RageUI.IsVisible(openRR, true, false, true, function()



            RageUI.PercentagePanel(Config.Param, "Récolte en cours (~g~" .. math.floor(Config.Param * 100) .. "%~s~)", "", "", function(_, a_, percent)


                if Config.Param < 1.0 then
                    Config.Param = Config.Param + Config.Wait
                    
                else
                    Config.Param = 0
                    TriggerServerEvent('ev:Recolte', "raisin")
                end




            end)

        end, function()
        end)
        if not RageUI.Visible(openRR) then
            openRR = RMenu:DeleteType("test", true)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end
end







Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
				for k in pairs {vector3(-1801.1875,2213.7456054688,92.338043212891)} do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = {vector3(-1801.1875,2213.7456054688,92.338043212891)}
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= 6 then
					wait = 0
                    DrawMarker(6, -1801.1875,2213.7456054688,92.338043212891-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0) 
				end

				if dist <= 1.0 then
					wait = 0
					
					AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour commencer la récolte")
                    DisplayHelpTextThisFrame("HELP", false)
					if IsControlJustPressed(1,51) then
						OpenR()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)
