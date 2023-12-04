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








function OpenRB()
    local OpenRBR = RageUI.CreateMenu("Raisin Blanc", "Vignoble")

    RageUI.Visible(OpenRBR, not RageUI.Visible(OpenRBR))
        while OpenRBR do
            FreezeEntityPosition(PlayerPedId(), true)
        Wait(0)
        RageUI.IsVisible(OpenRBR, true, false, true, function()



            RageUI.PercentagePanel(Config.Param, "Récolte en cours (~g~" .. math.floor(Config.Param * 100) .. "%~s~)", "", "", function(_, a_, percent)


                if Config.Param < 1.0 then
                    Config.Param = Config.Param + Config.Wait
                    
                else
                    Config.Param = 0
                    TriggerServerEvent('ev:Recolte', "raisinb")
                end




            end)

        end, function()
        end)
        if not RageUI.Visible(OpenRBR) then
            OpenRBR = RMenu:DeleteType("test", true)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end
end







Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
				for k in pairs {vector3(-1760.8078613281,2147.5085449219,125.26357269287)} do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = {vector3(-1760.8078613281,2147.5085449219,125.26357269287)}
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= 6 then
					wait = 0
                    DrawMarker(6, -1760.8078613281,2147.5085449219,125.26357269287-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0) 
				end

				if dist <= 1.0 then
					wait = 0
					
					AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour commencer la récolte")
                    DisplayHelpTextThisFrame("HELP", false)
					if IsControlJustPressed(1,51) then
						OpenRB()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)
