function open()
    SendNUIMessage({
        type = "ui",
        status = true,
    })
end

function close()
    SendNUIMessage({
        type = "ui",
        status = false,
    })
end

local health = 0
local armor = 0
local stamina = 0
local oxygen = 0
local isPause = false
local sleep = 250

-- Send data to HTML
Citizen.CreateThread(function()
    while true do
        local ped =  PlayerPedId()
        local playerId = PlayerId()
        local shift = IsControlJustReleased(0, 21)
        local w = IsControlJustReleased(0, 31)
        local water = IsEntityInWater(ped)
        health = GetEntityHealth(ped)/2
        armor = GetPedArmour(ped)
        stamina = 100 - GetPlayerSprintStaminaRemaining(playerId)
        stamina = math.ceil(stamina)
        oxygen = GetPlayerUnderwaterTimeRemaining(playerId)*10
        oxygen = math.ceil(oxygen)
        if shift or stamina < 100 then
            sleep = 125
        elseif water then
            sleep = 125
        end
        SendNUIMessage({
            type = "update",
            health = health,
            armor = armor,
            stamina = stamina,
            oxygen = oxygen,
        })
        Citizen.Wait(sleep)
    end
end)

-- Disable HUD while pause menu is active
Citizen.CreateThread(function()
    while true do
        if IsPauseMenuActive() then 
            isPause = true
            SendNUIMessage({
                type = "ui",
                status = false,
            })
        
        elseif not IsPauseMenuActive() and isPause then
            isPause = false
            SendNUIMessage({
                type = "ui",
                status = true,
            })
        end
        Citizen.Wait(250)
    end
end)

-- Register a command wich disable or enable the HUD
RegisterCommand("hud", function()
    if visible then
        close()
        visible = false
    else
        open()
        visible = true
    end
end)
