local Tinkr = ...

---@class Bastion
local Bastion = {
    DebugMode = false
}
Bastion.__index = Bastion

function Bastion.require(class)
    return Tinkr:require("scripts/bastion/src/" .. class .. "/" .. class, Bastion)
end

---@type ClassMagic
Bastion.ClassMagic = Bastion.require("ClassMagic")
---@type List
Bastion.List = Bastion.require("List")
---@type NotificationsList, Notification
Bastion.NotificationsList, Bastion.Notification = Bastion.require("NotificationsList")
---@type Vector3
Bastion.Vector3 = Bastion.require("Vector3")
---@type Sequencer
Bastion.Sequencer = Bastion.require("Sequencer")
---@type Command
Bastion.Command = Bastion.require("Command")
---@type Cache
Bastion.Cache = Bastion.require("Cache")
---@type Cacheable
Bastion.Cacheable = Bastion.require("Cacheable")
---@type Refreshable
Bastion.Refreshable = Bastion.require("Refreshable")
---@type Unit
Bastion.Unit = Bastion.require("Unit")
---@type Aura
Bastion.Aura = Bastion.require("Aura")
---@type APL, APLActor, APLTrait
Bastion.APL, Bastion.APLActor, Bastion.APLTrait = Bastion.require("APL")
Bastion.Module = Bastion.require("Module")
---@type UnitManager
Bastion.UnitManager = Bastion.require("UnitManager"):New()
---@type ObjectManager
Bastion.ObjectManager = Bastion.require("ObjectManager"):New()
---@type EventManager
Bastion.EventManager = Bastion.require("EventManager"):New()
---@type Spell
Bastion.Spell = Bastion.require("Spell")
---@type SpellBook
Bastion.SpellBook = Bastion.require("SpellBook"):New()
---@type Item
Bastion.Item = Bastion.require("Item")
---@type ItemBook
Bastion.ItemBook = Bastion.require("ItemBook"):New()
---@type AuraTable
Bastion.AuraTable = Bastion.require("AuraTable")
---@type Class
Bastion.Class = Bastion.require("Class")
---@type Timer
Bastion.Timer = Bastion.require("Timer")
---@type Timer
Bastion.CombatTimer = Bastion.Timer:New('combat')
---@type MythicPlusUtils
Bastion.MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()
---@type NotificationsList
Bastion.Notifications = Bastion.NotificationsList:New()

Bastion.modules = {}
Bastion.Enabled = false

Bastion.EventManager:RegisterWoWEvent('UNIT_AURA', function(unit, auras)
    local u = Bastion.UnitManager[unit]

    if u then
        u:GetAuras():OnUpdate(auras)
    end
end)

Bastion.EventManager:RegisterWoWEvent("UNIT_SPELLCAST_SUCCEEDED", function(...)
    local unit, castGUID, spellID = ...

    local spell = Bastion.SpellBook:GetIfRegistered(spellID)

    if unit == "player" and spell then
        spell.lastCastAt = GetTime()

        if spell:GetPostCastFunction() then
            spell:GetPostCastFunction()(spell)
        end
    end
end)

local pguid = UnitGUID("player")
local missed = {}

Bastion.EventManager:RegisterWoWEvent("COMBAT_LOG_EVENT_UNFILTERED", function()
    local args = { CombatLogGetCurrentEventInfo() }

    local subEvent = args[2]
    local sourceGUID = args[4]
    local destGUID = args[8]
    local spellID = args[12]

    -- if sourceGUID == pguid then
    --     local args = { CombatLogGetCurrentEventInfo() }

    --     for i = 1, #args do
    --         Log(tostring(args[i]))
    --     end
    -- end

    local u = Bastion.UnitManager[sourceGUID]
    local u2 = Bastion.UnitManager[destGUID]

    local t = GetTime()

    if u then
        u:SetLastCombatTime(t)
    end

    if u2 then
        u2:SetLastCombatTime(t)

        if subEvent == "SPELL_MISSED" and sourceGUID == pguid and spellID == 408 then
            local missType = args[15]

            if missType == "IMMUNE" then
                local castingSpell = u:GetCastingOrChannelingSpell()

                if castingSpell then
                    if not missed[castingSpell:GetID()] then
                        missed[castingSpell:GetID()] = true
                    end
                end
            end
        end
    end
end)

Bastion.Ticker = C_Timer.NewTicker(0.1, function()
    if not Bastion.CombatTimer:IsRunning() and UnitAffectingCombat("player") then
        Bastion.CombatTimer:Start()
    elseif Bastion.CombatTimer:IsRunning() and not UnitAffectingCombat("player") then
        Bastion.CombatTimer:Reset()
    end

    if Bastion.Enabled then
        Bastion.ObjectManager:Refresh()
        for i = 1, #Bastion.modules do
            Bastion.modules[i]:Tick()
        end
    end
end)

function Bastion:Register(module)
    table.insert(Bastion.modules, module)
    Bastion:Print("Registered", module)
end

-- Find a module by name
function Bastion:FindModule(name)
    for i = 1, #Bastion.modules do
        if Bastion.modules[i].name == name then
            return Bastion.modules[i]
        end
    end

    return nil
end

function Bastion:Print(...)
    local args = { ... }
    local str = "|cFFDF362D[Bastion]|r |cFFFFFFFF"
    for i = 1, #args do
        str = str .. tostring(args[i]) .. " "
    end
    print(str)
end

function Bastion:Debug(...)
    if not Bastion.DebugMode then
        return
    end
    local args = { ... }
    local str = "|cFFDF6520[Bastion]|r |cFFFFFFFF"
    for i = 1, #args do
        str = str .. tostring(args[i]) .. " "
    end
    print(str)
end

local Command = Bastion.Command:New('bastion')

Command:Register('toggle', 'Toggle bastion on/off', function()
    Bastion.Enabled = not Bastion.Enabled
    if Bastion.Enabled then
        Bastion:Print("Enabled")
    else
        Bastion:Print("Disabled")
    end
end)

Command:Register('debug', 'Toggle debug mode on/off', function()
    Bastion.DebugMode = not Bastion.DebugMode
    if Bastion.DebugMode then
        Bastion:Print("Debug mode enabled")
    else
        Bastion:Print("Debug mode disabled")
    end
end)

Command:Register('dumpspells', 'Dump spells to a file', function()
    local i = 1
    local rand = math.random(100000, 999999)
    while true do
        local spellName, spellSubName = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        if not spellName then
            do break end
        end

        -- use spellName and spellSubName here
        local spellID = select(7, GetSpellInfo(spellName))

        if spellID then
            WriteFile('bastion-' .. UnitClass('player') .. '-' .. rand .. '.lua',
                "local " .. spellName .. " = Bastion.SpellBook:GetSpell(" .. spellID .. ")", true)
        end
        i = i + 1
    end
end)

Command:Register('module', 'Toggle a module on/off', function(args)
    local module = Bastion:FindModule(args[2])
    if module then
        module:Toggle()
        if module.enabled then
            Bastion:Print("Enabled", module.name)
        else
            Bastion:Print("Disabled", module.name)
        end
    else
        Bastion:Print("Module not found")
    end
end)

Command:Register('mplus', 'Toggle m+ module on/off', function(args)
    local cmd = args[2]
    if cmd == 'debuffs' then
        Bastion.MythicPlusUtils:ToggleDebuffLogging()
        Bastion:Print("Debuff logging", Bastion.MythicPlusUtils.debuffLogging and "enabled" or "disabled")
        return
    end

    if cmd == 'casts' then
        Bastion.MythicPlusUtils:ToggleCastLogging()
        Bastion:Print("Cast logging", Bastion.MythicPlusUtils.castLogging and "enabled" or "disabled")
        return
    end

    Bastion:Print("[MythicPlusUtils] Unknown command")
    Bastion:Print("Available commands:")
    Bastion:Print("debuffs")
    Bastion:Print("casts")
end)

Command:Register('missed', 'Dump the list of immune kidney shot spells', function()
    for k, v in pairs(missed) do
        Bastion:Print(k)
    end
end)

local files = ListFiles("scripts/bastion/scripts")

for i = 1, #files do
    local file = files[i]
    if file:sub(-4) == ".lua" or file:sub(-5) == '.luac' then
        Tinkr:require("scripts/bastion/scripts/" .. file:sub(1, -5), Bastion)
    end
end
