local config = require 'config'
local playerState = LocalPlayer.state
local GetFollowPedCamViewMode =     GetFollowPedCamViewMode
local SetFollowPedCamViewMode =     SetFollowPedCamViewMode
local IsPedOnAnyBike =              IsPedOnAnyBike
local IsPedInAnyBoat =              IsPedInAnyBoat
local IsPedInAnyHeli =              IsPedInAnyHeli
local IsPedInAnySub =               IsPedInAnySub
local IsPedInAnyPlane =             IsPedInAnyPlane
local SetCamViewModeForContext =    SetCamViewModeForContext
local SetFollowVehicleCamViewMode = SetFollowVehicleCamViewMode
local GetCamViewModeForContext =    GetCamViewModeForContext
local GetFollowVehicleCamViewMode = GetFollowVehicleCamViewMode
local IsPlayerFreeAiming =          IsPlayerFreeAiming
local IsControlPressed =            IsControlPressed

FPPWeapon = false
FPPVehicleWeapon = false

function setLastCam()
    if not playerState.lastCam then
        playerState.lastCam = (not cache.vehicle) and GetFollowPedCamViewMode() or getCamByVehicleType()
    end
end

function resetPlayerCam(cam, fullReset)
    if playerState.lastCam then
        if cache.vehicle then
            setCamByVehicleType(cam)
        else
            SetFollowPedCamViewMode(cam)
        end

        local playerCam = (not cache.vehicle) and GetFollowPedCamViewMode() or getCamByVehicleType()
        while playerCam ~= cam do
            Wait(1)
        end

        if fullReset then
            playerState.lastCam = nil
        end
    end
end

function isWeaponFPP(weapon)
    local weaponIsFPP = false
    local weaponIsVehicleFPP = false

    if config.forceAllWeaponsVehicleAimingFPP then
        weaponIsVehicleFPP = true
    else
        for x = 1, #config.forceVehicleAimingWeapons do
            local weaponHash = config.forceVehicleAimingWeapons[x]
            if weapon == weaponHash then
                weaponIsVehicleFPP = true
                break
            end
        end
    end

    if config.forceAllWeaponsFPP then
        weaponIsFPP = true
    else
        for x = 1, #config.forceAimingWeapons do
            local weaponHash = config.forceAimingWeapons[x]
            if weapon == weaponHash then
                weaponIsFPP = true
                break
            end
        end
    end

    return weaponIsFPP, weaponIsVehicleFPP
end

function setCamByVehicleType(cam)
    local ped = cache.ped
    local bike = IsPedOnAnyBike(ped)
    local boat = IsPedInAnyBoat(ped)
    local heli = IsPedInAnyHeli(ped)
    local subm = IsPedInAnySub(ped)
    local plane = IsPedInAnyPlane(ped)

    if boat then
        SetCamViewModeForContext(3, cam)
    elseif	heli then
        SetCamViewModeForContext(6, cam)
    elseif	plane then
        SetCamViewModeForContext(4, cam)
    elseif subm then
        SetCamViewModeForContext(5, cam)
    elseif bike then
        SetCamViewModeForContext(2, cam)
    else
        SetFollowVehicleCamViewMode(cam)
    end
end

function getCamByVehicleType()
    local ped = cache.ped
    local bike = IsPedOnAnyBike(ped)
    local boat = IsPedInAnyBoat(ped)
    local heli = IsPedInAnyHeli(ped)
    local subm = IsPedInAnySub(ped)
    local plane = IsPedInAnyPlane(ped)
    local cam

    if boat then
        cam = GetCamViewModeForContext(3)
    elseif	heli then
        cam = GetCamViewModeForContext(6)
    elseif	plane then
        cam = GetCamViewModeForContext(4)
    elseif subm then
        cam = GetCamViewModeForContext(5)
    elseif bike then
        cam = GetCamViewModeForContext(2)
    else
        cam = GetFollowVehicleCamViewMode()
    end

    return cam
end

function isPlayerAiming()
    local callback = false
    if IsPlayerFreeAiming(cache.playerId) or IsControlPressed(0, 25) then
        callback = true
    end
    return callback
end