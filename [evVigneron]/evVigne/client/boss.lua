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










function openvboss()
    ESX.TriggerServerCallback('ev:refresh', function(accountEv)
        evMoney = accountEv
    end)
    local vibo = RageUI.CreateMenu("Vignoble","boss")
    local subvibo = RageUI.CreateSubMenu(vibo, "Actions sur Joueurs", "boss")

    RageUI.Visible(vibo, not RageUI.Visible(vibo))

    while vibo do
        
        Citizen.Wait(0)

        RageUI.IsVisible(vibo,true,true,true,function()


            RageUI.Separator("↓ ~r~  Argent total de la sociétée ~s~↓")

            if evMoney ~= nil then
                RageUI.ButtonWithStyle("Argent de societé :", nil, {RightLabel = "~b~$" .. evMoney}, true, function()
                end)
            end


            RageUI.Separator("↓     ~y~Gestion de l'entreprise     ~s~↓")
        
            
            RageUI.ButtonWithStyle("Déposer de l'argent", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local number = KeyboardInput("Nombre ?", "", 50)
                    TriggerServerEvent('evtest', number)
                    ESX.TriggerServerCallback('ev:refresh', function(accountEv)
                        evMoney = accountEv
                    end)  
                    RageUI.CloseAll()
                end
            end)


            RageUI.ButtonWithStyle("Retirer de l'argent", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local number2 = KeyboardInput("Nombre ?", "", 50)
                    TriggerServerEvent('evtest2', number2)
                    ESX.TriggerServerCallback('ev:refresh', function(accountEv)
                        evMoney = accountEv
                    end)
                    RageUI.CloseAll()
                end
            end)

            RageUI.Separator("↓     ~p~Recrutement    ~s~↓")

            RageUI.ButtonWithStyle("Actions Joueurs", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, subvibo)

            RageUI.Separator("↓     ~g~Achats    ~s~↓")

            RageUI.ButtonWithStyle("Guardian ", nil, {RightLabel = "~b~"..Config.GuardianPrice.." $"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('ev:BuySoc', "guardian")
                    RageUI.CloseAll()
                end
            end)

            RageUI.ButtonWithStyle("Blista ", nil, {RightLabel = "~b~"..Config.BlistaPrice.." $"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('ev:BuySoc', "blista")
                    RageUI.CloseAll()
                end
            end)

            
        end, function()
        end)


        RageUI.IsVisible(subvibo,true,true,true,function()
            FreezeEntityPosition(GetPlayerPed(-1), true)


            RageUI.Separator("↓     ~p~Recrutement    ~s~↓")

            RageUI.ButtonWithStyle("Recruter le joueur", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('ev:recruter', GetPlayerServerId(closestPlayer))
					 else
						RageUI.Popup({message = "Aucun joueur à proximité"})
					end 
                end
            end)

            RageUI.ButtonWithStyle("Virer le joueur", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('ev:virer', GetPlayerServerId(closestPlayer))
					 else
						RageUI.Popup({message = "Aucun joueur à proximité"})
					end 
                end
            end)


            RageUI.ButtonWithStyle("Rank Up joueur", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('ev:rank', GetPlayerServerId(closestPlayer))
					 else
						RageUI.Popup({message = "Aucun joueur à proximité"})
					end 
                end
            end)

            RageUI.ButtonWithStyle("Derank le joueur", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('ev:derank', GetPlayerServerId(closestPlayer))
					 else
						RageUI.Popup({message = "Aucun joueur à proximité"})
					end 
                end
            end)

            
        end, function()
        end)

        if not RageUI.Visible(vibo) and not RageUI.Visible(subvibo) then
            vibo=RMenu:DeleteType("vibo", true)
            FreezeEntityPosition(GetPlayerPed(-1), false)
        end

    end

end





Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and ESX.PlayerData.job.grade_name == 'boss' then
                for k in pairs {vector3(-1876.1590576172,2060.8552246094,145.57369995117)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-1876.1590576172,2060.8552246094,145.57369995117)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 6 then 
                    wait = 0
                    DrawMarker(6, -1876.1590576172,2060.8552246094,145.57369995117-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour accéder aux actions boss")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        ESX.TriggerServerCallback('ev:refresh', function(accountEv)
                            evMoney = accountEv
                        end)
                        openvboss()
                    end
                end
            end

        end
    Citizen.Wait(wait)
    end
end)








--- Fonction KeyboardInput

KeyboardInput = function(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end