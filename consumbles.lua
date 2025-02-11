-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local alcoholCount = 0
local ParachuteEquiped = false
local currentVest = nil
local currentVestTexture = nil
local healing = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(500)
    SetPedArmour(PlayerPedId(), tonumber(QBCore.Functions.GetPlayerData().metadata["armor"]))
end)

-- Functions

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function EquipParachuteAnim()
    loadAnimDict("clothingshirt")
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, false, false, false)
end

local function HealOxy()
    if not healing then
        healing = true
    else
        return
    end

    local count = 9
    while count > 0 do
        Wait(1000)
        count -= 1
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 6)
    end
    healing = false
end

local function TrevorEffect()
    StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
    Wait(3000)
    StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
    Wait(3000)
	StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
	StopScreenEffect("DrugsTrevorClownsFight")
	StopScreenEffect("DrugsTrevorClownsFightIn")
	StopScreenEffect("DrugsTrevorClownsFightOut")
end

local function MethBagEffect()
    local startStamina = 8
    TrevorEffect()
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
        if math.random(5, 100) < 51 then
            TrevorEffect()
        end
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

local function EcstasyEffect()
    local startStamina = 30
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do
        Wait(1000)
        startStamina -= 1
        if math.random(1, 100) < 51 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        end
    end
    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
end

local function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end

local function CrackBaggyEffect()
    local startStamina = 8
    local ped = PlayerPedId()
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
    while startStamina > 0 do
        Wait(1000)
        startStamina -= 1
        if math.random(1, 100) < 60 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, math.random(1000, 2000), math.random(1000, 2000), 3, false, false, false)
        end
        if math.random(1, 100) < 51 then
            AlienEffect()
        end
    end
    if IsPedRunning(ped) then
        SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

local function CokeBaggyEffect()
    local startStamina = 20
    local ped = PlayerPedId()
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
    while startStamina > 0 do
        Wait(1000)
        startStamina -= 1
        if math.random(1, 100) < 10 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
        end
        if math.random(1, 300) < 10 then
            AlienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(ped) then
        SetPedToRagdoll(ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

-- Events

RegisterNetEvent('consumables:client:Eat', function(itemName)
    ExecuteCommand( "e burger" )
    QBCore.Functions.Progressbar("eat_something", "Yiyorsun..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
        ExecuteCommand( "e c" )
        TriggerServerEvent("consumables:server:addHunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + ConsumablesEat[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
        TriggerServerEvent('ak4y-battlepass:taskCountAdd:standart', 6, 1)
        TriggerServerEvent('ak4y-battlepass:taskCountAdd:premium', 2, 1)
    end)
end)

RegisterNetEvent('consumables:client:Drink', function(itemName)
    ExecuteCommand( "e su" )
    QBCore.Functions.Progressbar("drink_something", "İçiyorsun..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
        ExecuteCommand( "e c" )
        TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + ConsumablesDrink[itemName])
        TriggerServerEvent('ak4y-battlepass:taskCountAdd:standart', 7, 1)
        TriggerServerEvent('ak4y-battlepass:taskCountAdd:premium', 3, 1)
    end)
end)

RegisterNetEvent('consumables:client:DrinkAlcohol', function(itemName)
    ExecuteCommand( "e bira" )
    QBCore.Functions.Progressbar("snort_coke", "Alkol İçiyorsun..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ExecuteCommand( "e c" )
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
        TriggerServerEvent("consumables:server:drinkAlcohol", itemName)
        TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + ConsumablesAlcohol[itemName])
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
        TriggerEvent("consumables:client:onBeer")
        alcoholCount += 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end

    end, function() -- Cancel
        ExecuteCommand( "e c" )
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end)

RegisterNetEvent('consumables:client:Cokebaggy', function()
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar("snort_coke", "Hızlı kokla..", math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("consumables:server:useCokeBaggy")
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["cokebaggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 200)
        CokeBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        QBCore.Functions.Notify("İptal edildi..", "error")
    end)
end)

RegisterNetEvent('consumables:client:Crackbaggy', function()
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar("snort_coke", "Sigara çatlağı..", math.random(7000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("consumables:server:useCrackBaggy")
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["crack_baggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 300)
        CrackBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(ped, "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        QBCore.Functions.Notify("İptal edildi", "error")
    end)
end)

RegisterNetEvent('consumables:client:EcstasyBaggy', function()
    QBCore.Functions.Progressbar("use_ecstasy", "Pops Pills", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("consumables:server:useXTCBaggy")
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["xtcbaggy"], "remove")
        EcstasyEffect()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        QBCore.Functions.Notify("İptal edildi", "error")
    end)
end)

RegisterNetEvent('consumables:client:oxy', function()
    QBCore.Functions.Progressbar("use_oxy", "Ağrı kesici kullanıyorsun", 2000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("consumables:server:useOxy")
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["oxy"], "remove")
        ClearPedBloodDamage(PlayerPedId())
		HealOxy()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        QBCore.Functions.Notify("İptal edildi", "error")
    end)
end)

RegisterNetEvent('consumables:client:meth', function()
    QBCore.Functions.Progressbar("snort_meth", "Meth kullanıyorsun", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("consumables:server:useMeth")
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["meth"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 300)
		TriggerEvent("evidence:client:SetStatus", "agitated", 300)
        MethBagEffect()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        QBCore.Functions.Notify("İptal edildi..", "error")
	end)
end)

RegisterNetEvent('consumables:client:UseJoint', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        TriggerEvent('animations:client:EmoteCommandStart', {"smoke3"})
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"smokeweed"})
    end
    QBCore.Functions.Progressbar("smoke_joint", "Esrar içiyorsun..", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["joint"], "remove", 1)
        TriggerEvent("consumables:client:onSpice")
        TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
        MethBagEffect()
    end)
end)

RegisterNetEvent('consumables:client:UseParachute', function()
    EquipParachuteAnim()
    QBCore.Functions.Progressbar("use_parachute", "Paraşütü giyiyorsun..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["parachute"], "remove")
        GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 1, false, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 7, texture = 0},  -- Adding Parachute Clothing
            }
        }
        TriggerEvent('qb-clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, false, false, false)
    end)
end)

RegisterNetEvent('consumables:client:ResetParachute', function()
    if ParachuteEquiped then
        EquipParachuteAnim()
        QBCore.Functions.Progressbar("reset_parachute", "Paraşütü topluyorsun..", 40000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = PlayerPedId()
            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["weapon_bottle"], "add")
            local ParachuteRemoveData = {
                outfitData = {
                    ["bag"] = { item = 0, texture = 0} -- Removing Parachute Clothing
                }
            }
            TriggerEvent('qb-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, false, false, false)
            TriggerServerEvent("qb-smallpenis:server:AddParachute")
            ParachuteEquiped = false
        end)
    else
        QBCore.Functions.Notify("Paraşütün yok!", "error")
    end
end)


RegisterNetEvent('hospital:client:UseBandage2', function()
    local ped = PlayerPedId()
    ExecuteCommand("e burger")
    QBCore.Functions.Progressbar("use_armor", "Taco yiyorsun..", 5000, false, true, {
        function()
            ExecuteCommand("e c")
        end
    }, {}, {}, {}, function() -- Tamamlandığında
        local ped = PlayerPedId()
        ExecuteCommand("e c")
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["taco"], "remove")
        SetEntityHealth(ped, GetEntityHealth(ped) + 25)
    end, function() -- İptal Edildiğinde
        local ped = PlayerPedId()
        StopAnimTask(ped, "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
        QBCore.Functions.Notify(Lang:t('error.canceled'), "error")
    end)
end)


RegisterNetEvent('consumables:client:UseArmor', function()
    if GetPedArmour(PlayerPedId()) >= 25 then QBCore.Functions.Notify('Zaten yeterince zırhın var!', 'error') return end
    QBCore.Functions.Progressbar("use_armor", "Zırhı giyiyorsun..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
        animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
        anim = "weed_inspecting_high_base_inspector",
        flags = 49,
    }, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["armor"], "remove")
        TriggerServerEvent('hospital:server:SetArmor', 75)
        TriggerServerEvent("consumables:server:useArmor")
        SetPedArmour(PlayerPedId(), 25)
    end)
end)

RegisterNetEvent('consumables:client:UseHeavyArmor', function()
    if GetPedArmour(PlayerPedId()) == 100 then QBCore.Functions.Notify('Zaten yeterince zırhınız var!', 'error') return end
    local ped = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.Progressbar("use_heavyarmor", "Zırhı giyiyorsun..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
        animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
        anim = "weed_inspecting_high_base_inspector",
        flags = 49,
    }, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["heavyarmor"], "remove")
        TriggerServerEvent("consumables:server:useHeavyArmor", 100)
        SetPedArmour(ped, 100)

    end)
end)

RegisterNetEvent('consumables:client:UseHeavyArmor2', function()
    if not QBCore.Functions.GetPlayerData().job.type == "leo" then 
        QBCore.Functions.Notify("Bu zırhı kullanmayı bilmiyorsun!", "error", 4000)
        return 
    end 

    if GetPedArmour(PlayerPedId()) == 100 then QBCore.Functions.Notify('Zaten yeterince zırhınız var!', 'error') return end
    local ped = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.Progressbar("use_heavyarmor", "Zırhı giyiyorsun..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
        animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
        anim = "weed_inspecting_high_base_inspector",
        flags = 49,
    }, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["heavyarmor"], "remove")
        TriggerServerEvent("consumables:server:useHeavyArmor2", 100)
        SetPedArmour(ped, 100)

    end)
end)


RegisterNetEvent('consumables:client:ResetArmor', function()
    local ped = PlayerPedId()
    if currentVest ~= nil and currentVestTexture ~= nil then
        QBCore.Functions.Progressbar("remove_armor", "Zırhı çıkarıyorsun..", 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(ped, 9, currentVest, currentVestTexture, 2)
            SetPedArmour(ped, 0)
            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["heavyarmor"], "add")
            TriggerServerEvent('consumables:server:resetArmor')
        end)
    else
        QBCore.Functions.Notify("Çıkarabileğin zırh yok", "error")
    end
end)


-- RegisterNetEvent('consumables:client:UseRedSmoke', function()
--     if ParachuteEquiped then
--         local ped = PlayerPedId()
--         SetPlayerParachuteSmokeTrailColor(ped, 255, 0, 0)
--         SetPlayerCanLeaveParachuteSmokeTrail(ped, true)
--         TriggerEvent("inventory:client:Itembox", QBCore.Shared.Items["smoketrailred"], "remove")
--     else
--         QBCore.Functions.Notify("You need to have a paracute to activate smoke!", "error")
--     end
-- end)

--Threads

CreateThread(function()
    local sleep = 1000
    while true do
        if alcoholCount > 0 then
            sleep = 1000 * 60 * 15
            alcoholCount -= 1
        else
            sleep = 2000
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('consumables:client:onSpice')
AddEventHandler('consumables:client:onSpice', function()
  QBCore.Functions.Notify("Aman aman nerelere geldik!", "success")

  RequestAnimSet("move_m@drunk@moderatedrunk") 
  while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
    Citizen.Wait(0)
  end
  
  local playerPed = GetPlayerPed(-1)
  
  TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	ClearPedTasksImmediately(GetPlayerPed(-1))

  TaskWanderStandard(playerPed, 10.0, 10)
  SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
  SetTimecycleModifier("spectator4")
  SetTimecycleModifierStrength(0.89)
  ShakeGameplayCam('DRUNK_SHAKE', 3.5)
  Citizen.Wait(15000)
  SetPedMotionBlur(playerPed, true)
  ShakeGameplayCam('DRUNK_SHAKE', 8.8)

  Wait(60000)

  ClearTimecycleModifier()
  ResetScenarioTypesEnabled()
  ResetPedMovementClipset(GetPlayerPed(-1), 0)
  SetPedIsDrunk(GetPlayerPed(-1), false)
  SetPedMotionBlur(GetPlayerPed(-1), false)
  ShakeGameplayCam('DRUNK_SHAKE', 0.0)
  ClearPedTasksImmediately(GetPlayerPed(-1))
end)

RegisterNetEvent('consumables:client:onBeer')
AddEventHandler('consumables:client:onBeer', function()

  RequestAnimSet("move_m@drunk@verydrunk") 
  while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
    Citizen.Wait(0)
  end

  RequestAnimSet("move_m@drunk@moderatedrunk") 
  while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
    Citizen.Wait(0)
  end

  local playerPed = GetPlayerPed(-1)
 
  TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRINKING", 0, true)
	Citizen.Wait(5000)
  ClearPedTasksImmediately(GetPlayerPed(-1))

  SetPedMotionBlur(playerPed, true)
  ShakeGameplayCam('DRUNK_SHAKE', 1.5)
  SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
  Citizen.Wait(15000)
  ShakeGameplayCam('DRUNK_SHAKE', 2.5)
  SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
  Citizen.Wait(10000)
  ShakeGameplayCam('DRUNK_SHAKE', 3.0)
  SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)


  Wait(60000)

  ClearTimecycleModifier()
  ResetScenarioTypesEnabled()
  ResetPedMovementClipset(GetPlayerPed(-1), 0)
  SetPedIsDrunk(GetPlayerPed(-1), false)
  SetPedMotionBlur(GetPlayerPed(-1), false)
  ShakeGameplayCam('DRUNK_SHAKE', 0.0)
end)
