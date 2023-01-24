local Tinkr, Bastion = ...

local SubModulue = Bastion.Module:New('sub')
local Evaluator = Tinkr.Util.Evaluator
local Player = Bastion.UnitManager:Get('player')
local None = Bastion.UnitManager:Get('none')
local Target = Bastion.UnitManager:Get('target')

local RollTheBones       = Bastion.SpellBook:GetSpell(315508)
local SliceAndDice       = Bastion.SpellBook:GetSpell(315496)
local BetweenTheEyes     = Bastion.SpellBook:GetSpell(315341)
local BladeRush          = Bastion.SpellBook:GetSpell(271877)
local Vanish             = Bastion.SpellBook:GetSpell(1856)
local Dispatch           = Bastion.SpellBook:GetSpell(2098)
local Ambush             = Bastion.SpellBook:GetSpell(8676)
local Stealth            = Bastion.SpellBook:GetSpell(1784)
local PistolShot         = Bastion.SpellBook:GetSpell(185763)
local Opportunity        = Bastion.SpellBook:GetSpell(195627)
local SinisterStrike     = Bastion.SpellBook:GetSpell(193315)
local GrandMelee         = Bastion.SpellBook:GetSpell(193358)
local Broadside          = Bastion.SpellBook:GetSpell(193356)
local TrueBearing        = Bastion.SpellBook:GetSpell(193359)
local RuthlessPrecision  = Bastion.SpellBook:GetSpell(193357)
local SkullAndCrossbones = Bastion.SpellBook:GetSpell(199603)
local BuriedTreasure     = Bastion.SpellBook:GetSpell(199600)
local AdrenalineRush     = Bastion.SpellBook:GetSpell(13750)
local ShadowDance        = Bastion.SpellBook:GetSpell(185313)
local ShadowDanceAura    = Bastion.SpellBook:GetSpell(185422)
local Audacity           = Bastion.SpellBook:GetSpell(381845)
local Flagellation       = Bastion.SpellBook:GetSpell(323654)
local Dreadblades        = Bastion.SpellBook:GetSpell(343142)
local JollyRoger         = Bastion.SpellBook:GetSpell(199603)
local BladeFlurry        = Bastion.SpellBook:GetSpell(13877)
local Kick               = Bastion.SpellBook:GetSpell(1766)
local MarkedForDeath     = Bastion.SpellBook:GetSpell(137619)
local CrimsonVial        = Bastion.SpellBook:GetSpell(185311)
local Shiv               = Bastion.SpellBook:GetSpell(5938)
local KidneyShot         = Bastion.SpellBook:GetSpell(408)
local InstantPoison      = Bastion.SpellBook:GetSpell(315584)
local Sanguine           = Bastion.SpellBook:GetSpell(226512)
local AtrophicPosion     = Bastion.SpellBook:GetSpell(381637)
local Evasion            = Bastion.SpellBook:GetSpell(5277)
local TricksOfTheTrade   = Bastion.SpellBook:GetSpell(57934)
local CheapShot          = Bastion.SpellBook:GetSpell(1833)
local BagOfTricks        = Bastion.SpellBook:GetSpell(312411)
local AutoAttack         = Bastion.SpellBook:GetSpell(6603)
local SymbolsOfDeath     = Bastion.SpellBook:GetSpell(212283)
local ShadowBlades       = Bastion.SpellBook:GetSpell(121471)
local ColdBlood          = Bastion.SpellBook:GetSpell(382245)
local ShurikenTornado    = Bastion.SpellBook:GetSpell(277925)
local ThistleTea         = Bastion.SpellBook:GetSpell(381623)
local Gloomblade         = Bastion.SpellBook:GetSpell(200758)
local Shadowstrike       = Bastion.SpellBook:GetSpell(185438)
local Rupture            = Bastion.SpellBook:GetSpell(1943)
local Eviscerate         = Bastion.SpellBook:GetSpell(196819)
local NumbingPoison      = Bastion.SpellBook:GetSpell(5761)
local ShurikenStorm      = Bastion.SpellBook:GetSpell(197835)
local BlackPowder        = Bastion.SpellBook:GetSpell(319175)
local SecretTechnique    = Bastion.SpellBook:GetSpell(280719)
local DarkBrew           = Bastion.SpellBook:GetSpell(310454)
local Premeditation      = Bastion.SpellBook:GetSpell(343173)
local DanseMacabre       = Bastion.SpellBook:GetSpell(393969)

local IrideusFragment = Bastion.ItemBook:GetItem(193743)
local Healthstone = Bastion.ItemBook:GetItem(5512)
local WindscarWhetstone = Bastion.ItemBook:GetItem(137486)
local DarkMoonRime = Bastion.ItemBook:GetItem(198477)
local AlgetharsPuzzleBox = Bastion.ItemBook:GetItem(193701)

local RimeCards = {
    One = Bastion.SpellBook:GetSpell(382844),
    Two = Bastion.SpellBook:GetSpell(382845),
    Three = Bastion.SpellBook:GetSpell(382846),
    Four = Bastion.SpellBook:GetSpell(382847),
    Five = Bastion.SpellBook:GetSpell(382848),
    Six = Bastion.SpellBook:GetSpell(382849),
    Seven = Bastion.SpellBook:GetSpell(382850),
    Eight = Bastion.SpellBook:GetSpell(382851),
}

local PurgeTarget = Bastion.UnitManager:CreateCustomUnit('purge', function(unit)
    local purge = nil

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() then
            return false
        end

        if not Player:CanSee(unit) then
            return false
        end

        if Player:GetDistance(unit) > 40 then
            return false
        end

        if unit:GetAuras():HasAnyStealableAura() then
            purge = unit
            return true
        end
    end)

    if purge == nil then
        purge = None
    end

    return purge
end)

local KickTarget = Bastion.UnitManager:CreateCustomUnit('kick', function(unit)
    local kick = nil

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() then
            return false
        end

        if not Player:CanSee(unit) then
            return false
        end

        if Player:GetDistance(unit) > 40 then
            return false
        end

        if Player:InMelee(unit) and Player:IsFacing(unit) and Bastion.MythicPlusUtils:CastingCriticalKick(unit, 5) then
            kick = unit
            return true
        end
    end)

    if kick == nil then
        kick = None
    end

    return kick
end)

local Tank = Bastion.UnitManager:CreateCustomUnit('tank', function(unit)
    local tank = nil

    Bastion.UnitManager:EnumFriends(function(unit)
        if Player:GetDistance(unit) > 40 then
            return false
        end

        if not Player:CanSee(unit) then
            return false
        end

        if unit:IsDead() then
            return false
        end

        if unit:IsTank() then
            tank = unit
            return true
        end

        return false
    end)

    if tank == nil then
        tank = None
    end

    return tank
end)

local RuptureTarget = Bastion.UnitManager:CreateCustomUnit('rupture', function()
    local target = nil

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() then
            return false
        end

        if not Player:CanSee(unit) then
            return false
        end

        if not Player:InMelee(unit) then
            return false
        end

        if not Player:IsFacing(unit) then
            return false
        end

        if (
            not unit:GetAuras():FindMy(Rupture):IsUp() or
                unit:GetAuras():FindMy(Rupture):GetRemainingTime() < 6
            )
            and unit:TimeToDie() > 12
            and unit:GetCombatTime() > 4
        then
            target = unit
            return true
        end
    end)

    if target == nil then
        target = None
    end

    return target
end)

local DefaultAPL = Bastion.APL:New('default')
local AOEAPL = Bastion.APL:New('aoe')
local SpecialAPL = Bastion.APL:New('special')
local RacialsAPL = Bastion.APL:New('racials')

local Facing = function(t)
    return Bastion.APLTrait:New(function()
        return Player:IsFacing(t)
    end)
end

SpecialAPL:AddSpell(
    Kick:CastableIf(function(self)
        return KickTarget:Exists() and self:IsInRange(KickTarget) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling()
    end):SetTarget(KickTarget)
):AddTraits(
    Facing(KickTarget)
)

SpecialAPL:AddSpell(
    KidneyShot:CastableIf(function(self)
        return KickTarget:Exists() and self:IsInRange(KickTarget) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Kick:GetTimeSinceLastCast() > 2 and
            (Player:GetComboPoints(Target) >= 5 or
                (
                Player:GetComboPoints(Target) >= 4 and
                    (Player:GetAuras():FindMy(Broadside):IsUp() or Player:GetAuras():FindMy(Opportunity):IsUp())))
            and not Target:GetAuras():Find(Sanguine):IsUp()

    end):SetTarget(KickTarget)
)

SpecialAPL:AddSpell(
    CheapShot:CastableIf(function(self)
        return KickTarget:Exists() and self:IsInRange(KickTarget) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and Player:GetAuras():FindMy(Stealth):IsUp()
            and not Target:GetAuras():Find(Sanguine):IsUp()
    end):SetTarget(KickTarget)
)

SpecialAPL:AddSpell(
    Stealth:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and not Player:IsAffectingCombat() and
            not Player:GetAuras():FindMy(Stealth):IsUp() and not IsMounted()
    end):SetTarget(Player)
)

SpecialAPL:AddSpell(
    CrimsonVial:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetHealthPercent() < 70
    end):SetTarget(Player)
)

SpecialAPL:AddSpell(
    Shiv:CastableIf(function(self)
        return PurgeTarget:Exists() and self:IsInRange(PurgeTarget) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and PurgeTarget:GetAuras():HasAnyStealableAura()
    end):SetTarget(PurgeTarget)
)

SpecialAPL:AddSpell(
    InstantPoison:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            not Player:GetAuras():FindMy(InstantPoison):IsUp() and not Player:IsMoving()
    end):SetTarget(Player)
)

SpecialAPL:AddSpell(
    AtrophicPosion:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            not Player:GetAuras():FindMy(AtrophicPosion):IsUp() and not Player:IsMoving()
    end):SetTarget(Player)
)

SpecialAPL:AddSpell(
    NumbingPoison:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            not Player:GetAuras():FindMy(NumbingPoison):IsUp() and not Player:IsMoving()
    end):SetTarget(Player)
)

SpecialAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsEquippedAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetHealthPercent() < 40
    end):SetTarget(Player)
)

SpecialAPL:AddSpell(
    TricksOfTheTrade:CastableIf(function(self)
        return Tank:Exists() and self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:IsTanking(Target)
    end):SetTarget(Tank)
)

SpecialAPL:AddSpell(
    Evasion:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetHealthPercent() < 40
    end):SetTarget(Player)
)

SpecialAPL:AddItem(
    IrideusFragment:UsableIf(function(self)
        return self:IsEquippedAndUsable() and
            not Player:IsCastingOrChanneling() and (Player:GetMeleeAttackers() > 2 or Target:IsBoss())
    end):SetTarget(Player)
)

SpecialAPL:AddItem(
    WindscarWhetstone:UsableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and self:IsEquippedAndUsable() and
            not Player:IsCastingOrChanneling() and (Player:GetMeleeAttackers() > 2 or Target:IsBoss())
    end):SetTarget(Player)
)

SpecialAPL:AddItem(
    AlgetharsPuzzleBox:UsableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and self:IsEquippedAndUsable() and
            not Player:IsCastingOrChanneling() and (Player:GetMeleeAttackers() > 3 or Target:IsBoss())
    end):SetTarget(Player)
)

SpecialAPL:AddItem(
    DarkMoonRime:UsableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and self:IsEquippedAndUsable() and
            not Player:IsCastingOrChanneling() and (Player:GetMeleeAttackers() > 2 or Target:IsBoss()) and
            (Player:GetAuras():FindMy(RimeCards.One):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Two):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Three):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Four):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Five):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Six):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Seven):IsUp() or
                Player:GetAuras():FindMy(RimeCards.Eight):IsUp()
            )
    end):SetTarget(Target)
)

-- Use  Shadowstrike during  Shadow Dance.
SpecialAPL:AddSpell(
    Shadowstrike:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and Player:GetAuras():FindMy(Premeditation):IsUp() and
            Player:GetEnemies(10) <= 3
    end):SetTarget(Target)
)

RacialsAPL:AddSpell(
    BagOfTricks:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling()
    end):SetTarget(Target)
)

-- Use  Symbols of Death on cooldown as much as possible.
DefaultAPL:AddSpell(
    SymbolsOfDeath:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling()
    end):SetTarget(Player):OnCast(function()
        ShurikenTornado:Cast(Target)
    end)
)

-- Use  Shadow Blades on cooldown.
DefaultAPL:AddSpell(
    ShadowBlades:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling()
    end):SetTarget(Player)
)

-- Use  Cold Blood before a finishing move, ideally before  Secret Technique.
DefaultAPL:AddSpell(
    ColdBlood:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetComboPoints(Target) >= 5 and SecretTechnique:IsKnownAndUsable() and
            Player:GetAuras():FindMy(SliceAndDice):IsUp() and
            Target:GetAuras():FindMy(Rupture):IsUp()
    end):SetTarget(Player):OnCast(function()
        SecretTechnique:Cast(Target)
    end)
)

-- Line up  Shuriken Tornado with  Symbols of Death.
DefaultAPL:AddSpell(
    ShurikenTornado:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetAuras():FindMy(SymbolsOfDeath):IsUp()
    end):SetTarget(Player)
)

-- Use  Shadow Dance on cooldown as much as possible.
DefaultAPL:AddSpell(
    ShadowDance:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and Gloomblade:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and Player:GetComboPoints(Target) <= 2
    end):SetTarget(Player):OnCast(function()
        Gloomblade:Cast(Target) -- We want to cast gloomblade immediately with shadow dance to trigger 1 stack of danse macabre
    end)
)

-- Use  Thistle Tea when low on energy.
-- actions.cds+=/thistle_tea,if=cooldown.symbols_of_death.remains>=3&!buff.thistle_tea.up&(energy.deficit>=100|cooldown.thistle_tea.charges_fractional>=2.75&buff.shadow_dance.up)|buff.shadow_dance.remains>=4&!buff.thistle_tea.up&spell_targets.shuriken_storm>=3|!buff.thistle_tea.up&fight_remains<=(6*cooldown.thistle_tea.charges)
DefaultAPL:AddSpell(
    ThistleTea:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetPowerDeficit() >= 100 and
            ThistleTea:GetTimeSinceLastCast() >= 3
    end):SetTarget(Player)

)

-- Use Finishing moves with 6 or more combo points (5 or more during  Shadow Dance) with the following priority:
-- Cast  Slice and Dice if it needs to be refreshed for maintenance or if it is not up.
DefaultAPL:AddSpell(
    SliceAndDice:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 6 or
                (Player:GetComboPoints(Target) >= 5 and
                    Player:GetAuras():FindMy(ShadowDanceAura):IsUp())) and
            (
            not Player:GetAuras():FindMy(SliceAndDice):IsUp() or
                Player:GetAuras():FindMy(SliceAndDice):GetRemainingTime() < 12
            )
    end):SetTarget(Player)
)

-- Cast  Rupture if it needs to be refreshed for maintenance or if it is not up.
DefaultAPL:AddSpell(
    Rupture:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 6 or
                (Player:GetComboPoints(Target) >= 5 and
                    Player:GetAuras():FindMy(ShadowDanceAura):IsUp())) and (
            not Target:GetAuras():FindMy(Rupture):IsUp() or
                Target:GetAuras():FindMy(Rupture):GetRemainingTime() < 6
            ) and not Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
    end):SetTarget(Target)
)

DefaultAPL:AddSpell(
    SecretTechnique:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 5) and
            Player:GetAuras():FindMy(ShadowDanceAura):IsUp() and
            (Player:GetAuras():FindMy(DanseMacabre):GetCount() >= 3 or
                not DanseMacabre:IsKnown()) and
            (not ColdBlood:IsKnown() or
                ColdBlood:GetCooldownRemaining() > Player:GetAuras():FindMy(ShadowDanceAura):GetRemainingTime() - 2)
    end):SetTarget(Target)
)

-- Cast Eviscerate if it is available.
DefaultAPL:AddSpell(
    Eviscerate:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 6 or
                (Player:GetComboPoints(Target) >= 5 and
                    Player:GetAuras():FindMy(ShadowDanceAura):IsUp()))
    end):SetTarget(Target)
)

-- Vanish - Is a fairly weak cooldown. It is best to use on low combo points for a  Shadowstrike cast. Use it after  Secret Technique in  Shadow Dance when playing with  Danse Macabre.
DefaultAPL:AddSpell(
    Vanish:CastableIf(function(self)
        return Tank:Exists() and Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetComboPoints(Target) < 4
    end):SetTarget(Player)
)

-- Use Combo Point builder with the following priority:
-- Use  Gloomblade outside of  Shadow Dance.
DefaultAPL:AddSpell(
    Gloomblade:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            not Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
    end):SetTarget(Target)
)

-- Use  Shadowstrike during  Shadow Dance.
DefaultAPL:AddSpell(
    Shadowstrike:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
    end):SetTarget(Target)
)

-- AOE

-- Use  Symbols of Death on cooldown as much as possible.
AOEAPL:AddSpell(
    SymbolsOfDeath:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling()
    end):SetTarget(Player):OnCast(function()
        ShurikenTornado:Cast(Target)
    end)
)

-- Use  Shadow Blades on cooldown.
AOEAPL:AddSpell(
    ShadowBlades:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling()
    end):SetTarget(Player)
)

-- Use  Cold Blood before a finishing move.
AOEAPL:AddSpell(
    ColdBlood:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetComboPoints(Target) >= 5 and SecretTechnique:IsKnownAndUsable() and
            Player:GetAuras():FindMy(SliceAndDice):IsUp() and
            Target:GetAuras():FindMy(Rupture):IsUp()
    end):SetTarget(Player):OnCast(function()
        SecretTechnique:Cast(Target)
    end)
)

-- Line up  Shuriken Tornado with  Symbols of Death.
AOEAPL:AddSpell(
    ShurikenTornado:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetAuras():FindMy(SymbolsOfDeath):IsUp()
    end):SetTarget(Target)
)

-- Use  Shadow Dance on cooldown as much as possible.
AOEAPL:AddSpell(
    ShadowDance:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and Gloomblade:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and Player:GetComboPoints(Target) <= 2
    end):SetTarget(Player):OnCast(function()
        Gloomblade:Cast(Target) -- We want to cast gloomblade immediately with shadow dance to trigger 1 stack of danse macabre
    end)
)

-- Use  Thistle Tea with  Shadow Dance.
AOEAPL:AddSpell(
    ThistleTea:CastableIf(function(self)
        return Target:Exists() and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetPowerDeficit() >= 100 and
            ThistleTea:GetTimeSinceLastCast() >= 3
    end):SetTarget(Player)
)

-- Use Finishing moves with 5 or more combo points with the following priority:
-- Cast  Slice and Dice if it needs to be refreshed for maintenance or if it is not up.
AOEAPL:AddSpell(
    SliceAndDice:CastableIf(function(self)
        return Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 5) and
            (
            not Player:GetAuras():FindMy(SliceAndDice):IsUp() or
                Player:GetAuras():FindMy(SliceAndDice):GetRemainingTime() < 6
            )
            and Player:GetEnemies(10) < 6
    end):SetTarget(Target)
)

-- Cast  Rupture if it needs to be refreshed for maintenance or if it is not up.
AOEAPL:AddSpell(
    Rupture:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 5) and (
            not Target:GetAuras():FindMy(Rupture):IsUp() or
                Target:GetAuras():FindMy(Rupture):GetRemainingTime() < 6
            )
            and not Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
            and not Player:GetAuras():FindMy(SymbolsOfDeath):IsUp()
            and not Player:GetAuras():FindMy(ThistleTea):IsUp()
    end):SetTarget(Target)
)

-- Cast  Rupture on all targets. (scam??)
AOEAPL:AddSpell(
    Rupture:CastableIf(function(self)
        return RuptureTarget:Exists() and self:IsInRange(RuptureTarget) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(RuptureTarget) >= 6) and (
            not RuptureTarget:GetAuras():FindMy(Rupture):IsUp() or
                RuptureTarget:GetAuras():FindMy(Rupture):GetRemainingTime() < 6
            )
            and not Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
    end):SetTarget(RuptureTarget)
)

-- actions.finish+=/secret_technique,if=buff.shadow_dance.up&(buff.danse_macabre.stack>=3|!talent.danse_macabre)&(!talent.cold_blood|cooldown.cold_blood.remains>buff.shadow_dance.remains-2)
AOEAPL:AddSpell(
    SecretTechnique:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 5) and
            Player:GetAuras():FindMy(ShadowDanceAura):IsUp() and
            (Player:GetAuras():FindMy(DanseMacabre):GetCount() >= 3 or
                not DanseMacabre:IsKnown()) and
            (not ColdBlood:IsKnown() or
                ColdBlood:GetCooldownRemaining() > Player:GetAuras():FindMy(ShadowDanceAura):GetRemainingTime() - 2)
    end):SetTarget(Target)
)

-- Cast  Black Powder with 3 or more targets, 2 or more when talented into  Dark Brew.
AOEAPL:AddSpell(
    BlackPowder:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            (Player:GetComboPoints(Target) >= 5) and
            (Player:GetEnemies(10) >= 3 or
                (Player:GetEnemies(10) >= 2 and
                    DarkBrew:IsKnown()))
    end):SetTarget(Target)
)

-- Cast  Eviscerate.
AOEAPL:AddSpell(
    Eviscerate:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetComboPoints(Target) >= 5
    end):SetTarget(Target)
)

-- Vanish - Is a fairly weak cooldown. It is best to use on low combo points for a  Shadowstrike cast. Use it after  Secret Technique in  Shadow Dance when playing with  Danse Macabre.
AOEAPL:AddSpell(
    Vanish:CastableIf(function(self)
        return Tank:Exists() and Target:Exists() and Player:InMelee(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetComboPoints(Target) < 4
    end):SetTarget(Player)
)

-- Use Combo Point builder with the following priority:
-- Use  Shuriken Storm on 2 targets outside of  Shadow Dance.
AOEAPL:AddSpell(
    ShurikenStorm:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetEnemies(10) == 2 and
            not Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
    end):SetTarget(Player)
)

-- Use  Shadowstrike on 2 and 3 targets during  Shadow Dance or to proc  Premeditation.
AOEAPL:AddSpell(
    Shadowstrike:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetEnemies(10) >= 2 and Player:GetEnemies(10) <= 3 and
            Player:GetAuras():FindMy(ShadowDanceAura):IsUp()
    end):SetTarget(Target)
)

-- Use  Shuriken Storm at > 2 targets.
AOEAPL:AddSpell(
    ShurikenStorm:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetEnemies(10) > 2
    end):SetTarget(Player)
)

-- Use gloomblade at <= 2 targets.
AOEAPL:AddSpell(
    Gloomblade:CastableIf(function(self)
        return Target:Exists() and self:IsInRange(Target) and
            self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetEnemies(10) <= 2
    end):SetTarget(Target)
)

SubModulue:Sync(function()
    SpecialAPL:Execute()
    if Player:GetEnemies(10) >= 2 then
        AOEAPL:Execute()
    else
        DefaultAPL:Execute()
    end
    RacialsAPL:Execute()
end)

Bastion:Register(SubModulue)
