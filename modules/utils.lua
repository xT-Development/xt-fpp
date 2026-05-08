local config = lib.require('config')
local IsPedOnAnyBike =              IsPedOnAnyBike
local IsPedInAnyBoat =              IsPedInAnyBoat
local IsPedInAnyHeli =              IsPedInAnyHeli
local IsPedInAnySub =               IsPedInAnySub
local IsPedInAnyPlane =             IsPedInAnyPlane
local GetFollowPedCamViewMode =     GetFollowPedCamViewMode
local SetCamViewModeForContext =    SetCamViewModeForContext
local SetFollowVehicleCamViewMode = SetFollowVehicleCamViewMode
local GetCamViewModeForContext =    GetCamViewModeForContext
local GetFollowVehicleCamViewMode = GetFollowVehicleCamViewMode
local IsPlayerFreeAiming =          IsPlayerFreeAiming
local IsControlPressed =            IsControlPressed

FPPWeapon = false
FPPVehicleWeapon = false

local utils = {}

function utils.isWeaponFPP(weapon)
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

function utils.setCamByVehicleType(cam)
    local ped = cache.ped
    local bike = IsPedOnAnyBike(ped)
    local boat = IsPedInAnyBoat(ped)
    local heli = IsPedInAnyHeli(ped)
    local subm = IsPedInAnySub(ped)
    local plane = IsPedInAnyPlane(ped)

    if boat then
        SetCamViewModeForContext(3, cam)
    elseif heli then
        SetCamViewModeForContext(6, cam)
    elseif plane then
        SetCamViewModeForContext(4, cam)
    elseif subm then
        SetCamViewModeForContext(5, cam)
    elseif bike then
        SetCamViewModeForContext(2, cam)
    else
        SetFollowVehicleCamViewMode(cam)
    end
end

function utils.getCamByVehicleType()
    local ped = cache.ped
    local bike = IsPedOnAnyBike(ped)
    local boat = IsPedInAnyBoat(ped)
    local heli = IsPedInAnyHeli(ped)
    local subm = IsPedInAnySub(ped)
    local plane = IsPedInAnyPlane(ped)
    local cam

    if boat then
        cam = GetCamViewModeForContext(3)
    elseif heli then
        cam = GetCamViewModeForContext(6)
    elseif plane then
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

function utils.isPlayerAiming()
    if not cache.weapon then return false end

    return IsPlayerFreeAiming(cache.playerId) or IsControlPressed(0, 25)
end

function utils.getPlayerCam()
    return (not cache.vehicle) and GetFollowPedCamViewMode() or utils.getCamByVehicleType()
end

return utils
