local config = require 'config'
local playerState = LocalPlayer.state
local SetFollowPedCamViewMode = SetFollowPedCamViewMode
local IsControlJustReleased =   IsControlJustReleased

local function weaponLoop(weapon)
    Wait(500)
    local sleep = 1
    while (cache.weapon == weapon) do
        if not cache.vehicle then
            sleep = 1

            if isPlayerAiming() then
                setLastCam()

                if not cache.vehicle and FPPWeapon then
                    SetFollowPedCamViewMode(4)
                end

                DisableControlAction(0, 0, true)
            else
                if IsControlJustReleased(0, 25) then
                    resetPlayerCam(playerState.lastCam, true)
                end
                Wait(100)
            end
        else
            sleep = 1000
        end

        Wait(sleep)
    end
end

lib.onCache('weapon', function(value)
    if not config.forceAimingFPP then
        return
    end

    if not cache.weapon and value then
        FPPWeapon, FPPVehicleWeapon = isWeaponFPP(value)
        if not FPPWeapon then return end

        setLastCam()
        weaponLoop(value)
    else
        FPPWeapon, FPPVehicleWeapon = false, false
    end
end)