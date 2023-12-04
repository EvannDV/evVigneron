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








function OpenVEnte()
    local OpenVEnteR = RageUI.CreateMenu("Vente", "Express Achats")

    RageUI.Visible(OpenVEnteR, not RageUI.Visible(OpenVEnteR))
        while OpenVEnteR do
            FreezeEntityPosition(PlayerPedId(), true)
        Wait(0)
        RageUI.IsVisible(OpenVEnteR, true, false, true, function()



            RageUI.PercentagePanel(Config.Param, "Vente en cours (~g~" .. math.floor(Config.Param * 100) .. "%~s~)", "", "", function(_, a_, percent)


                if Config.Param < 1.0 then
                    Config.Param = Config.Param + Config.Wait
                    
                else
                    Config.Param = 0
                    TriggerServerEvent('ev:Vente', "terroirb", "grandcru")
                end




            end)

        end, function()
        end)
        if not RageUI.Visible(OpenVEnteR) then
            OpenVEnteR = RMenu:DeleteType("test", true)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end
end







Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
				for k in pairs {vector3(-354.73760986328,6066.8432617188,31.498565673828)} do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = {vector3(-354.73760986328,6066.8432617188,31.498565673828)}
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= 6 then
					wait = 0
                    DrawMarker(6, -354.73760986328,6066.8432617188,31.498565673828-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0) 
				end

				if dist <= 1.0 then
					wait = 0
					
					AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour commencer la vente")
                    DisplayHelpTextThisFrame("HELP", false)
					if IsControlJustPressed(1,51) then
						OpenVEnte()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)



Citizen.CreateThread(function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        local blip23 = AddBlipForCoord(vector3(-354.78018188477,6066.9443359375,31.498558044434))
        SetBlipSprite(blip23, 85)
        SetBlipScale(blip23, 0.9)
        SetBlipColour(blip23, 7)
        SetBlipAsShortRange(blip23, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vente")
        EndTextCommandSetBlipName(blip23)
    end
end)


