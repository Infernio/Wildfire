ScriptName _WF_PlayerTrackingScript Extends ReferenceAlias
{A central script that Wildfire uses to check which items the player picks up.}

import _WF_Constants
import _WF_Utils

; GENERAL
Actor               Property playerRef Auto
{The player reference.}
_WF_PerkTreeManager Property perkManager Auto
{The global perk tree manager.}
Keyword             Property isRelic Auto
{The keyword that indicates whether or not an item is a relic.}
Keyword             Property isResearch Auto
{The keyword that indicates whether or not an item is a research document.}

; RESEARCH
Keyword             Property researchBonusArcana Auto
{The keyword that indicates that a research item is more likely to give arcana research.}
Keyword             Property researchBonusReflexes Auto
{The keyword that indicates that a research item is more likely to give reflexes research.}
Keyword             Property researchBonusStrength Auto
{The keyword that indicates that a research item is more likely to give strength research.}
Keyword             Property researchValueMinor Auto
{The keyword that indicates that a research item came from a minor relic.}
Keyword             Property researchValueNormal Auto
{The keyword that indicates that a research item came from a normal relic.}
Keyword             Property researchValueAncient Auto
{The keyword that indicates that a research item came from an ancient relic.}

Event OnItemAdded(Form baseItem, int itemCount, ObjectReference itemRef, ObjectReference sourceContainer)
    If(baseItem.HasKeyword(IsRelic))
        ProcessRelic(itemCount)
    ElseIf(baseItem.HasKeyword(isResearch))
        ProcessResearch(baseItem)
    EndIf
EndEvent

Function ProcessRelic(int itemCount)
{Handles relics being added to the player's inventory.
Arguments:
 - itemCount: The number of relics that have been added to the player's inventory.}
    If(!perkManager.IsTreeUnlocked(Archaeology()))
        ; We discovered archaeology, grant a perk as well
        perkManager.UnlockTree(Archaeology(), true)
    EndIf
EndFunction

Function ProcessResearch(Form item)
{Handles a research document being added to the player's inventory.
Arguments:
 - item: The research item that was added to the player's inventory.}
    ; begin by calculating the player's skill points in different areas
    float magicSkills = GetTotalMagicSkills(playerRef)
    float stealthSkills = GetTotalStealthSkills(playerRef)
    float combatSkills = GetTotalCombatSkills(playerRef)
    float totalSkills = magicSkills + stealthSkills + combatSkills

    ; then, use that information to increase the chances of giving them a fitting bonus
    ; normalize that chance to 80% so that we can add a 20% bonus afterwards
    float arcanaChance = 0.8 * (magicSkills / totalSkills)
    float reflexesChance = 0.8 * (stealthSkills / totalSkills)
    float strengthChance = 0.8 * (combatSkills / totalSkills)

    ; if the item has a fitting keyword, use that
    If(item.HasKeyword(researchBonusArcana))
        arcanaChance += 0.2
    ElseIf(item.HasKeyword(researchBonusReflexes))
        reflexesChance += 0.2
    ElseIf(item.HasKeyword(researchBonusStrength))
        strengthChance += 0.2
    Else
        ; otherwise, apply randomly
        int random = Utility.RandomInt(0, 2)
        If(random == 0)
            arcanaChance += 0.2
        ElseIf(random == 1)
            reflexesChance += 0.2
        Else
            strengthChance += 0.2
        EndIf
    EndIf

    ; advance archaeology first
    int researchPoints = GetResearchAmount(item)
    perkManager.AdvanceWildfireSkill(Archaeology(), researchPoints)

    ; then use our calculated chances to give the player research
    float random = Utility.RandomFloat(0, 1)
    If(random <= arcanaChance)
        perkManager.AdvanceWildfireSkill(Arcana(), researchPoints)
    ElseIf(random <= arcanaChance + reflexesChance)
        perkManager.AdvanceWildfireSkill(Reflexes(), researchPoints)
    Else
        perkManager.AdvanceWildfireSkill(Strength(), researchPoints)
    EndIf

    ; and then, get rid of the item
    playerRef.RemoveItem(item, abSilent = true)
EndFunction

int Function GetResearchAmount(Form item)
    {Returns a fitting amount of research progress based on the keyword the specified item has.
    Arguments:
     - item: The item to consider.
    Returns:
     A fitting amount of research progress based on the specified item.}
    ; TODO Balance and make it configurable / based on difficulty
    If(item.HasKeyword(researchValueMinor))
        return 1
    ElseIf(item.HasKeyword(researchValueNormal))
        return 10
    ElseIf(item.HasKeyword(researchValueAncient))
        return 100
    EndIf
EndFunction
