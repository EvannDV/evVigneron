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

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(vector3(-1889.4436035156,2047.8543701172,140.87498474121))
    SetBlipSprite(blip, 85)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 7)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vigneron")
    EndTextCommandSetBlipName(blip)
end)

EvInfo = {
    nom = nil,
    prenom = nil,
    styleP = nil,
    motivations = nil,
    nomDiscord = nil,
}
ev = "→"

evCheckVi = {}
-------------Menu



function evVigneAdd()
    local evVigneAddMenu = RageUI.CreateMenu("Postuler", Config.UrServ)

    RageUI.Visible(evVigneAddMenu, not RageUI.Visible(evVigneAddMenu))

    while evVigneAddMenu do
        
        Citizen.Wait(0)

        RageUI.IsVisible(evVigneAddMenu,true,true,true,function()






            RageUI.ButtonWithStyle("~p~→ ~s~Nom", nil, {RightLabel = EvInfo.nom}, true,function(h,a,s)
                if s then
                    EvInfo.nom = Keyboard("Votre Nom : ", "", 20)
                end
        
            end)

            RageUI.ButtonWithStyle("~p~→ ~s~Prénom", nil, {RightLabel = EvInfo.prenom}, true,function(h,a,s)
                if s then
                    EvInfo.prenom = Keyboard("Votre Prénom : ", "", 20)
                end
        
            end)

            RageUI.ButtonWithStyle("~p~→ ~s~Style de poste", nil, {RightLabel = EvInfo.styleP}, true,function(h,a,s)
                if s then
                    EvInfo.styleP = Keyboard("Mi-Temps ou CDD ou CDI ", "", 20)
                end
        
            end)

            RageUI.ButtonWithStyle("~p~→ ~s~Motivations", nil, {RightLabel = EvInfo.motivations}, true,function(h,a,s)
                if s then
                    EvInfo.motivations = Keyboard("Vos motivations :", "", 50)
                end
        
            end)

            RageUI.ButtonWithStyle("~p~→ ~s~Nom Discord", nil, {RightLabel = ev}, true,function(h,a,s)
                if s then
                    EvInfo.nomDiscord = Keyboard("Votre Nom Discord :", "", 30)
                    ev = "✅"
                end
        
            end)

            RageUI.ButtonWithStyle("~p~→ ~s~Postuler", nil, {Color = {BackgroundColor = { 0, 120, 0, 25 }}}, true,function(h,a,s)
                if s then
                    if EvInfo.nom == nil or EvInfo.prenom == nil or EvInfo.styleP == nil or EvInfo.motivations == nil or EvInfo.nomDiscord == nil then
                        ESX.ShowNotification("Vous devez remplir toutes les cases !")
                    else
                        TriggerServerEvent('ev:submit', EvInfo)
                        EvInfo = {
                            nom = nil,
                            prenom = nil,
                            styleP = nil,
                            motivations = nil,
                            nomDiscord = nil,
                        }
                        ev = "→"
                        RageUI.CloseAll()
                    end

                end
        
            end)

            




            



        
        end, function()
        end)

        

        if not RageUI.Visible(evVigneAddMenu) then
            evVigneAddMenu=RMenu:DeleteType("Delete", true)
            EvInfo = {
                nom = nil,
                prenom = nil,
                styleP = nil,
                motivations = nil,
                nomDiscord = nil,
                ev = "→"
            }
        end

    end

end


----------Fonction Keyboard


function Keyboard(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end


-- Marker postuler
 Citizen.CreateThread(function()
    while true do 
        local wait = 750

                for k in pairs {vector3(-1890.7485351563,2058.6027832031,140.98461914063)} do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = {vector3(-1890.7485351563,2058.6027832031,140.98461914063)}
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 15 then 
                    wait = 0
                    DrawMarker(6, -1890.7485351563,2058.6027832031,140.98461914063-0.99, 0.0, 0.0, 0.0, -90, 0.0, 0.0, 0.5, 0.5, 0.5, 132, 102, 226, 170, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist <= 1.0 then 
                    wait = 0

                    AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour intéragir")
                    DisplayHelpTextThisFrame("HELP", false)
                    if IsControlJustPressed(1, 51) then 
                        evVigneAdd()
                    end
                end
            end

    Citizen.Wait(wait)
    end
end)

--------------PED

Citizen.CreateThread(function()
    local hash = GetHashKey("cs_molly")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
      Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "cs_molly", -1890.7485351563,2058.6027832031,140.98461914063-1, 224.89561462402344, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)





--- Blips 


Citizen.CreateThread(function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        local blipR1 = AddBlipForCoord(vector3(-1801.1875,2213.7456054688,92.338043212891))
        SetBlipSprite(blipR1, 682)
        SetBlipScale(blipR1, 0.7)
        SetBlipColour(blipR1, 7)
        SetBlipAsShortRange(blipR1, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Recolte")
        EndTextCommandSetBlipName(blipR1)
    end
end)


Citizen.CreateThread(function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        local blipRB = AddBlipForCoord(vector3(-1760.8078613281,2147.5085449219,125.26357269287))
        SetBlipSprite(blipRB, 682)
        SetBlipScale(blipRB, 0.7)
        SetBlipColour(blipRB, 7)
        SetBlipAsShortRange(blipRB, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Recolte 2")
        EndTextCommandSetBlipName(blipRB)
    end
end)


Citizen.CreateThread(function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        local blipTr = AddBlipForCoord(vector3(-1401.8165283203,2485.3151855469,26.54783821106))
        SetBlipSprite(blipTr, 682)
        SetBlipScale(blipTr, 0.7)
        SetBlipColour(blipTr, 7)
        SetBlipAsShortRange(blipTr, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Traitement")
        EndTextCommandSetBlipName(blipTr)
    end
end)


Citizen.CreateThread(function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
        local blipTr2 = AddBlipForCoord(vector3(-2278.2556152344,2451.5895996094,0.92245274782181))
        SetBlipSprite(blipTr2, 682)
        SetBlipScale(blipTr2, 0.7)
        SetBlipColour(blipTr2, 7)
        SetBlipAsShortRange(blipTr2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Traitement 2")
        EndTextCommandSetBlipName(blipTr2)
    end
end)