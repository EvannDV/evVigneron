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








function OpenT()
    local OpenTR = RageUI.CreateMenu("Raisin", "Vignoble")

    RageUI.Visible(OpenTR, not RageUI.Visible(OpenTR))
        while OpenTR do
            FreezeEntityPosition(PlayerPedId(), true)
        Wait(0)
        RageUI.IsVisible(OpenTR, true, false, true, function()



            RageUI.PercentagePanel(Config.Param, "Nettoyage et Traitement en cours (~g~" .. math.floor(Config.Param * 100) .. "%~s~)", "", "", function(_, a_, percent)


                if Config.Param < 1.0 then
                    Config.Param = Config.Param + Config.Wait
                    
                else
                    Config.Param = 0
                    ExecuteCommand('e mechanic')
                    TriggerServerEvent('ev:Trait', "raisin", "jusraisin")
                end




            end)

        end, function()
        end)
        if not RageUI.Visible(OpenTR) then
            OpenTR = RMenu:DeleteType("test", true)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end
end







Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
				for k in pairs {vector3(-1401.8165283203,2485.3151855469,26.54783821106)} do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = {vector3(-1401.8165283203,2485.3151855469,26.54783821106)}
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= 6 then
					wait = 0
                    DrawMarker(0, -1401.8165283203,2485.3151855469,26.54783821106, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0) 
				end

				if dist <= 1.0 then
					wait = 0
					
					AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour commencer le nettoyage et le traitement")
                    DisplayHelpTextThisFrame("HELP", false)
					if IsControlJustPressed(1,51) then
						OpenT()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)
