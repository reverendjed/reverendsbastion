local Tinkr, Bastion = ...

-- Create a new Aura class
local Aura = {}

function Aura:__index(k)
    local response = Bastion.ClassMagic:Resolve(Aura, k)

    if response == nil then
        response = rawget(self, k)
    end

    if response == nil then
        error("Aura:__index: " .. k .. " does not exist")
    end

    return response
end

function Aura:__tostring()
    return "Bastion.__Aura(" .. self:GetSpell():GetID() .. ")" .. " - " .. (self:GetName() or "''")
end

-- Constructor
function Aura:New(unit, index, type)
    if unit == nil then
        local self = setmetatable({}, Aura)
        self.aura = {
            name = nil,
            icon = nil,
            count = 0,
            dispelType = nil,
            duration = 0,
            expirationTime = 0,
            source = nil,
            isStealable = false,
            nameplateShowPersonal = false,
            spellId = 0,
            canApplyAura = false,
            isBossDebuff = false,
            castByPlayer = false,
            nameplateShowAll = false,
            timeMod = 0,

            index = nil,
            type = nil,

        }
        return self
    end

    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
    spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit.unit, index, type)

    local self = setmetatable({}, Aura)
    self.aura = {
        name = name,
        icon = icon,
        count = count,
        dispelType = dispelType,
        duration = duration,
        expirationTime = expirationTime,
        source = source,
        isStealable = isStealable,
        nameplateShowPersonal = nameplateShowPersonal,
        spellId = spellId,
        canApplyAura = canApplyAura,
        isBossDebuff = isBossDebuff,
        castByPlayer = castByPlayer,
        nameplateShowAll = nameplateShowAll,
        timeMod = timeMod,

        index = index,
        type = type,
    }
    return self
end

function Aura:CreateFromUnitAuraInfo(unitAuraInfo)
    local self = setmetatable({}, Aura)
    self.aura = {
        name = unitAuraInfo.name,
        icon = unitAuraInfo.icon,
        count = unitAuraInfo.applications,
        dispelType = unitAuraInfo.dispelName,
        duration = unitAuraInfo.duration,
        expirationTime = unitAuraInfo.expirationTime,
        source = unitAuraInfo.sourceUnit,
        isStealable = unitAuraInfo.isStealable,
        nameplateShowPersonal = unitAuraInfo.nameplateShowPersonal,
        spellId = unitAuraInfo.spellId,
        canApplyAura = unitAuraInfo.canApplyAura,
        isBossDebuff = unitAuraInfo.isBossAura,
        castByPlayer = unitAuraInfo.isFromPlayerOrPlayerPet,
        nameplateShowAll = unitAuraInfo.nameplateShowAll,
        timeMod = unitAuraInfo.timeMod,

        index = nil,
        type = unitAuraInfo.isHarmful and "HARMFUL" or "HELPFUL",
    }
    return self
end

-- Check if the aura is valid
function Aura:IsValid()
    return self.aura.name ~= nil
end

-- Check if the aura is up
function Aura:IsUp()
    return self:IsValid() and (self:GetDuration() == 0 or self:GetRemainingTime() > 0)
end

-- Get the auras index
function Aura:GetIndex()
    return self.aura.index
end

-- Get the auras type
function Aura:GetType()
    return self.aura.type
end

-- Get the auras name
function Aura:GetName()
    return self.aura.name
end

-- Get the auras icon
function Aura:GetIcon()
    return self.aura.icon
end

-- Get the auras count
function Aura:GetCount()
    return self.aura.count
end

-- Get the auras dispel type
function Aura:GetDispelType()
    return self.aura.dispelType
end

-- Get the auras duration
function Aura:GetDuration()
    return self.aura.duration
end

-- Get the auras remaining time
function Aura:GetRemainingTime()
    local remainingTime = self.aura.expirationTime - GetTime()

    if remainingTime < 0 then
        remainingTime = 0
    end

    return remainingTime
end

-- Get the auras expiration time
function Aura:GetExpirationTime()
    return self.aura.expirationTime
end

-- Get the auras source
function Aura:GetSource()
    return Bastion.UnitManager[self.aura.source]
end

-- Get the auras stealable status
function Aura:GetIsStealable()
    return self.aura.isStealable
end

-- Get the auras nameplate show personal status
function Aura:GetNameplateShowPersonal()
    return self.aura.nameplateShowPersonal
end

-- Get the auras spell id
function Aura:GetSpell()
    return Bastion.Spell:New(self.aura.spellId)
end

-- Get the auras can apply aura status
function Aura:GetCanApplyAura()
    return self.aura.canApplyAura
end

-- Get the auras is boss debuff status
function Aura:GetIsBossDebuff()
    return self.aura.isBossDebuff
end

-- Get the auras cast by player status
function Aura:GetCastByPlayer()
    return self.aura.castByPlayer
end

-- Get the auras nameplate show all status
function Aura:GetNameplateShowAll()
    return self.aura.nameplateShowAll
end

-- Get the auras time mod
function Aura:GetTimeMod()
    return self.aura.timeMod
end

-- Check if the aura is a buff
function Aura:IsBuff()
    return self.aura.type == "HELPFUL"
end

-- Check if the aura is a debuff
function Aura:IsDebuff()
    return self.aura.type == "HARMFUL"
end

-- Check if the aura is dispelable by a spell
function Aura:IsDispelableBySpell(spell)
    if self:GetDispelType() == nil then
        return false
    end

    if self:GetDispelType() == 'Magic' and spell:IsMagicDispel() then
        return true
    end

    if self:GetDispelType() == 'Curse' and spell:IsCurseDispel() then
        return true
    end

    if self:GetDispelType() == 'Poison' and spell:IsPoisonDispel() then
        return true
    end

    if self:GetDispelType() == 'Disease' and spell:IsDiseaseDispel() then
        return true
    end

    return false
end

return Aura
