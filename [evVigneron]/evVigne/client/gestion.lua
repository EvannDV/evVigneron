ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
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


evListeV = {}
evAccCli = {}

-------------Menu



function evVigneGest()
    local evVigneGestMenu = RageUI.CreateMenu("Gestion", "Candidatures")
    local subListeV = RageUI.CreateSubMenu(evVigneGestMenu, "Candidature", Config.UrServ)
    local subAcc = RageUI.CreateSubMenu(evVigneGestMenu, "Acceptations", Config.UrServ)

    RageUI.Visible(evVigneGestMenu, not RageUI.Visible(evVigneGestMenu))

    while evVigneGestMenu do
        
        Citizen.Wait(0)

        RageUI.IsVisible(evVigneGestMenu,true,true,true,function()
            ESX.TriggerServerCallback('ev:recupCandidV', function(listEv)
                evListeV = listEv
            end)

            RageUI.ButtonWithStyle("~p~→ ~s~Membres Acceptés", nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
            end, subAcc)


                if #evListeV < 1 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~Pas de candidatures")
                    RageUI.Separator("")
                else
                    for i = 1, #evListeV, 1 do
                        RageUI.ButtonWithStyle("~p~→ ~r~"..evListeV[i].prenom.." "..evListeV[i].nom, nil, {RightLabel = "~s~Contrat : ~b~"..evListeV[i].style},true, function(Hovered, Active, Selected)
                            if (Selected) then
                                prenom = evListeV[i].prenom
                                nom = evListeV[i].nom
                                style = evListeV[i].style
                                motivations = evListeV[i].motivations
                                identif = evListeV[i].ident
                                discordEv = evListeV[i].dis
                            end
                        end, subListeV)
                    end
                end



        
        end, function()
        end)

        RageUI.IsVisible(subListeV,true,true,true,function()


            RageUI.Separator("↓   ~o~Infos Personnels~s~   ↓")
            RageUI.Separator("Discord : ~g~"..discordEv)
            RageUI.Separator("~r~"..prenom.." "..nom)
            RageUI.Separator("")
            RageUI.Separator("↓   ~o~Type de Poste~s~   ↓")
            RageUI.Separator("~b~"..style)
            RageUI.Separator("")
            RageUI.Separator("↓   ~o~Motivations~s~   ↓")
            RageUI.Separator(motivations)
            RageUI.Separator("")
            RageUI.ButtonWithStyle("~p~→ ~s~Accepter", nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('ev:Accepter', identif)
                end
            end, evVigneGestMenu)
            RageUI.ButtonWithStyle("~p~→ ~s~Refuser", nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('ev:Refuser', identif)
                end
            end, evVigneGestMenu)
        
        end, function()
        end)

        RageUI.IsVisible(subAcc,true,true,true,function()
            ESX.TriggerServerCallback('ev:recupAccept', function(acc)
                evAccCli = acc
            end)

            if #evAccCli < 1 then
                RageUI.Separator("")
                RageUI.Separator("~r~Pas de membres accceptés")
                RageUI.Separator("")
            else
            for i = 1, #evAccCli, 1 do
                RageUI.ButtonWithStyle("~p~→ ~r~"..evAccCli[i].prenom.." "..evAccCli[i].nom, nil, {RightLabel = "~s~Contrat : ~b~"..evAccCli[i].style},true, function(Hovered, Active, Selected)
                    if (Selected) then
                        prenom = evAccCli[i].prenom
                        nom = evAccCli[i].nom
                        style = evAccCli[i].style
                        motivations = evAccCli[i].motivations
                        identif = evAccCli[i].ident
                        discordEv = evAccCli[i].dis
                    end
                end, subListeV)
            end
        end
        
        end, function()
        end)

        

        if not RageUI.Visible(evVigneGestMenu) and not RageUI.Visible(subListeV) and not RageUI.Visible(subAcc) then
            evVigneGestMenu=RMenu:DeleteType("Delete", true)
        end

    end

end





-- Marker gestion
 Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and ESX.PlayerData.job.grade_name == 'boss' then
                for k in pairs {vector3(-1878.9903564453,2062.6352539063,145.57368469238)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-1878.9903564453,2062.6352539063,145.57368469238)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(6, -1878.9903564453,2062.6352539063,145.57368469238-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour intéragir")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then
                        ESX.TriggerServerCallback('ev:recupCandidV', function(listEv)
                            evListeV = listEv
                        end) 
                        evVigneGest()
                    end
                end
            end
            end

    Citizen.Wait(wait)
    end
end)






