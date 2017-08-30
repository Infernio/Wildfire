ScriptName _WF_PlayerTrackingScript Extends ReferenceAlias
{A central script that Wildfire uses to check which items the player picks up.}

import _WF_Utils

; GENERAL
Actor           Property playerRef Auto
{The player reference.}
Keyword         Property isRelic Auto
{The keyword that indicates whether or not an item is a relic.}
Keyword         Property isResearch Auto
{The keyword that indicates whether or not an item is a research document.}

; RESEARCH
Keyword         Property researchBonusArcana Auto
{The keyword that indicates that a research item is more likely to give arcana research.}
Keyword         Property researchBonusReflexes Auto
{The keyword that indicates that a research item is more likely to give reflexes research.}
Keyword         Property researchBonusStrength Auto
{The keyword that indicates that a research item is more likely to give strength research.}
Keyword         Property researchValueMinor Auto
{The keyword that indicates that a research item came from a minor relic.}
Keyword         Property researchValueNormal Auto
{The keyword that indicates that a research item came from a normal relic.}
Keyword         Property researchValueAncient Auto
{The keyword that indicates that a research item came from an ancient relic.}

; ARCHAEOLOGY
GlobalVariable  Property archaeologyUnlocked Auto
{The global variable that determines whether or not archaeology has been unlocked already.}
Message         Property archaeologyUnlockedMsg Auto
{The message that will be shown to the player when they unlock archaeology.}
Message         Property archaeologySkillAdvancedMsg Auto
{The message that will be shown to the player when they find relics but don't have enough for a perk yet.}
Activator       Property archaeologyNodeController Auto
{The node controller that controls the archaeology perk tree.}
GlobalVariable  Property archaeologyPerksAvailable Auto
{The global variable that stores the number of available archaeology perks.}
GlobalVariable  Property archaeologyCampfireProgress Auto
{The progress towards the next perk, in the range [0 - 1].}
GlobalVariable  Property archaeologyPerksEarned Auto
{The global variable that stores the number of archaeology perks that have already been earned.}
GlobalVariable  Property archaeologyPerksTotal Auto
{The global variable that stores the total number of perks in the archaeology tree.}
Message         Property archaeologyPerkEarnedMsg Auto
{The message that will be shown to the player when they gain a perk.}
GlobalVariable  Property archaeologyRelicsFound Auto
{The global variable that stores the number of relics that have been found towards the next perk.}
GlobalVariable  Property archaeologyRelicsRequired Auto
{The global variable that stores the number of relics required for the next perk.}

; ARCANA
GlobalVariable  Property arcanaUnlocked Auto
{The global variable that determines whether or not arcana has been unlocked already.}
Message         Property arcanaUnlockedMsg Auto
{The message that will be shown to the player when they unlock arcana.}
Message         Property arcanaSkillAdvancedMsg Auto
{The message that will be shown to the player when they research relics but don't have enough for a perk yet.}
Activator       Property arcanaNodeController Auto
{The node controller that controls the arcana perk tree.}
GlobalVariable  Property arcanaPerksAvailable Auto
{The global variable that stores the number of available arcana perks.}
GlobalVariable  Property arcanaCampfireProgress Auto
{The progress towards the next perk, in the range [0 - 1].}
GlobalVariable  Property arcanaPerksEarned Auto
{The global variable that stores the number of arcana perks that have already been earned.}
GlobalVariable  Property arcanaPerksTotal Auto
{The global variable that stores the total number of perks in the arcana tree.}
Message         Property arcanaPerkEarnedMsg Auto
{The message that will be shown to the player when they gain a perk.}
GlobalVariable  Property arcanaResearchPoints Auto
{The global variable that stores the number of arcana research points the player has earned.}
GlobalVariable  Property arcanaResearchPointsRequired Auto
{The global variable that stores the number of arcana research points the player needs for the next perk.}

; REFLEXES
GlobalVariable  Property reflexesUnlocked Auto
{The global variable that determines whether or not reflexes has been unlocked already.}
Message         Property reflexesUnlockedMsg Auto
{The message that will be shown to the player when they unlock reflexes.}
Message         Property reflexesSkillAdvancedMsg Auto
{The message that will be shown to the player when they research relics but don't have enough for a perk yet.}
Activator       Property reflexesNodeController Auto
{The node controller that controls the reflexes perk tree.}
GlobalVariable  Property reflexesPerksAvailable Auto
{The global variable that stores the number of available reflexes perks.}
GlobalVariable  Property reflexesCampfireProgress Auto
{The progress towards the next perk, in the range [0 - 1].}
GlobalVariable  Property reflexesPerksEarned Auto
{The global variable that stores the number of reflexes perks that have already been earned.}
GlobalVariable  Property reflexesPerksTotal Auto
{The global variable that stores the total number of perks in the reflexes tree.}
Message         Property reflexesPerkEarnedMsg Auto
{The message that will be shown to the player when they gain a perk.}
GlobalVariable  Property reflexesResearchPoints Auto
{The global variable that stores the number of reflexes research points the player has earned.}
GlobalVariable  Property reflexesResearchPointsRequired Auto
{The global variable that stores the number of reflexes research points the player needs for the next perk.}

; STRENGTH
GlobalVariable  Property strengthUnlocked Auto
{The global variable that determines whether or not strength has been unlocked already.}
Message         Property strengthUnlockedMsg Auto
{The message that will be shown to the player when they unlock strength.}
Message         Property strengthSkillAdvancedMsg Auto
{The message that will be shown to the player when they research relics but don't have enough for a perk yet.}
Activator       Property strengthNodeController Auto
{The node controller that controls the strength perk tree.}
GlobalVariable  Property strengthPerksAvailable Auto
{The global variable that stores the number of available strength perks.}
GlobalVariable  Property strengthCampfireProgress Auto
{The progress towards the next perk, in the range [0 - 1].}
GlobalVariable  Property strengthPerksEarned Auto
{The global variable that stores the number of strength perks that have already been earned.}
GlobalVariable  Property strengthPerksTotal Auto
{The global variable that stores the total number of perks in the strength tree.}
Message         Property strengthPerkEarnedMsg Auto
{The message that will be shown to the player when they gain a perk.}
GlobalVariable  Property strengthResearchPoints Auto
{The global variable that stores the number of strength research points the player has earned.}
GlobalVariable  Property strengthResearchPointsRequired Auto
{The global variable that stores the number of strength research points the player needs for the next perk.}

Event OnInit()
    CheckCampfireVersion()
EndEvent

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
    If(archaeologyUnlocked.GetValue() == 0)
        ; we discovered archaeology
        If(CampUtil.RegisterPerkTree(archaeologyNodeController, "Wildfire.esp"))
            archaeologyUnlockedMsg.Show()
            GrantPerk(5, 10, archaeologyRelicsFound, archaeologyRelicsRequired, archaeologyCampfireProgress, archaeologyPerksAvailable, archaeologyPerksEarned, archaeologyPerkEarnedMsg)
            archaeologyUnlocked.SetValue(1)
        Else
            ; something went very wrong
            Debug.MessageBox("Failed to register a perk tree. You may have too many Campfire perk tree mods installed.")
        EndIf
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
    int researchPoints = GetResearchAmount(item, researchValueMinor, researchValueNormal, researchValueAncient)
    AdvanceArchaeology(researchPoints)

    ; then use our calculated chances to give the player research
    float random = Utility.RandomFloat(0, 1)
    If(random <= arcanaChance)
        AdvanceArcana(researchPoints)
    ElseIf(random <= arcanaChance + reflexesChance)
        AdvanceReflexes(researchPoints)
    Else
        AdvanceStrength(researchPoints)
    EndIf

    ; and then, get rid of the item
    playerRef.RemoveItem(item, abSilent = true)
EndFunction

Function AdvanceArchaeology(int amount)
{Advances archaeology and grants perks if applicable.
Arguments:
- amount: The amount of points to advance archaeology by.}
    AdvanceSkill(amount, archaeologyPerksTotal.GetValue() as int, 5, 10, archaeologyRelicsFound, archaeologyRelicsRequired, archaeologyCampfireProgress, archaeologyPerksAvailable, archaeologyPerksEarned, archaeologySkillAdvancedMsg, archaeologyPerkEarnedMsg)
EndFunction

Function AdvanceArcana(int amount)
{Advances arcana and grants perks if applicable.
Arguments:
- amount: The amount of points to advance arcana by.}
    AdvanceSkill(amount, arcanaPerksTotal.GetValue() as int, 5, 10, arcanaResearchPoints, arcanaResearchPointsRequired, arcanaCampfireProgress, arcanaPerksAvailable, arcanaPerksEarned, arcanaSkillAdvancedMsg, arcanaPerkEarnedMsg)
EndFunction

Function AdvanceReflexes(int amount)
{Advances reflexes and grants perks if applicable.
Arguments:
- amount: The amount of points to advance reflexes by.}
    AdvanceSkill(amount, reflexesPerksTotal.GetValue() as int, 5, 10, reflexesResearchPoints, reflexesResearchPointsRequired, reflexesCampfireProgress, reflexesPerksAvailable, reflexesPerksEarned, reflexesSkillAdvancedMsg, reflexesPerkEarnedMsg)
EndFunction

Function AdvanceStrength(int amount)
{Advances strength and grants perks if applicable.
Arguments:
- amount: The amount of points to advance strength by.}
    AdvanceSkill(amount, strengthPerksTotal.GetValue() as int, 5, 10, strengthResearchPoints, strengthResearchPointsRequired, strengthCampfireProgress, strengthPerksAvailable, strengthPerksEarned, strengthSkillAdvancedMsg, strengthPerkEarnedMsg)
EndFunction

Function AdvanceSkill(int amount, int numPerks, int linearScale, int constantScale, GlobalVariable progressVar, GlobalVariable requiredProgressVar, GlobalVariable campfireProgressVar, GlobalVariable availablePerksVar, GlobalVariable earnedPerksVar, Message skillAdvancedMsg, Message perkEarnedMsg)
{Advances the specified skill by the specified amount of points. Returns true if a 'skill advanced' message should be shown.
Arguments:
 - amount:               The amount the skill should be increased by.
 - numPerks:             The total number of perks in this tree.
 - linearScale:          The linear scaling factor that should be used for calculating the cost of the next perk.
 - constantScale:        The constant scaling factor that should be used for calculating the cost of the next perk.
 - progressVar:          The global variable that stores the player's progress towards the next perk (NOT the campfire, percentage-based one).
 - requiredProgressVar:  The global variable that indicates how much more progress needs to be made until a new perk will be available.
 - campfireProgressVar:  The (percentage-based) global variable used to incdicate the progress in the campfire perk tree menu.
 - availablePerksVar:    The global variable that determines the nubmer of perks in this tree that the player can currently purchase.
 - earnedPerksVar:       The global variable that determines the total number of perks in this tree that the player has purchased thus far.
 - skillAdvancedMsg:     The message that will be shown if the skill has advanced.
 - perkEarnedMsg:        The message that will be shown to the player when they unlock the perk.}
    bool showSkillAdvancedMsg = true

    ; string debugStr = "amount: " + amount + "\n" + "numPerks: " + numPerks + "\n" + "linearScale:" + linearScale + "\n" + "constantScale:" + constantScale + "\n" + "progressVar:" + progressVar.GetValueInt() + "\n" + "requiredProgressVar:" + requiredProgressVar.GetValueInt()
    ; Debug.MessageBox(debugStr + "\n" + "campfireProgressVar:" + campfireProgressVar.GetValue() + "\n" + "availablePerksVar:" + availablePerksVar.GetValueInt() + "\n" + "earnedPerksVar:" + earnedPerksVar.GetValueInt() + "\n")

    ; if we still have perks to unlock
    If(earnedPerksVar.GetValue() < numPerks)
        int i = 0
        While(i < amount)
            IncrementGlobalVariable(progressVar)
            campfireProgressVar.SetValue(progressVar.GetValue() / requiredProgressVar.GetValue())

            ; if that put us over the 'required progress' mark, grant a perk
            If(progressVar.GetValue() >= requiredProgressVar.GetValue())
                GrantPerk(linearScale, constantScale, progressVar, requiredProgressVar, campfireProgressVar, availablePerksVar, earnedPerksVar, perkEarnedMsg)
                showSkillAdvancedMsg = false
            EndIf

            i += 1
        EndWhile
    EndIf
    If(showSkillAdvancedMsg)
        ; show this 'skill advanced' message only once to limit spam
        skillAdvancedMsg.Show()
    EndIf
EndFunction

Function GrantPerk(int linearScale, int constantScale, GlobalVariable progressVar, GlobalVariable requiredProgressVar, GlobalVariable campfireProgressVar, GlobalVariable availablePerksVar, GlobalVariable earnedPerksVar, Message perkEarnedMsg)
{Grants a perk and sets the relevant global variables.
Arguments:
 - linearScale:          The linear scaling factor that should be used for calculating the cost of the next perk.
 - constantScale:        The constant scaling factor that should be used for calculating the cost of the next perk.
 - progressVar:          The global variable that stores the player's progress towards the next perk (NOT the campfire, percentage-based one).
 - requiredProgressVar:  The global variable that indicates how much more progress needs to be made until a new perk will be available.
 - campfireProgressVar:  The (percentage-based) global variable used to incdicate the progress in the campfire perk tree menu.
 - availablePerksVar:    The global variable that determines the nubmer of perks in this tree that the player can currently purchase.
 - earnedPerksVar:       The global variable that determines the total number of perks in this tree that the player has purchased thus far.
 - perkEarnedMsg:        The message that will be shown to the player when they unlock the perk.}
    IncrementGlobalVariable(availablePerksVar)
    IncrementGlobalVariable(earnedPerksVar)
    requiredProgressVar.SetValue(requiredProgressVar.GetValue() * linearScale + constantScale)
    progressVar.SetValue(0)
    campfireProgressVar.SetValue(0)
    perkEarnedMsg.Show()
EndFunction
