ScriptName _WF_PerkTreeManager Extends ReferenceAlias
{A central script used to track which perk trees the player has unlocked and which perks they have taken.}

import _WF_Utils

; GENERAL
Message             Property messageFailedRegistration Auto
{The message shown to the player when the perk tree registration fails.}

; PERK TREES
Message[]           Property treeUnlockedMessages Auto
{The messages that will be shown to the player when they unlock the tree with the corresponding ID.}
Message[]           Property skillAdvancedMessages Auto
{The messages that will be shown to the player when they advance the tree with the corresponding ID.}
Message[]           Property perkEarnedMessages Auto
{The messages that will be shown to the player when they earn a perk for the tree with the corresponding ID.}
Activator[]         Property nodeControllers Auto
{The node controllers for the corresponding trees.}
GlobalVariable[]    Property treeUnlockedVars Auto
{Whether or not each tree has been unlocked.}
GlobalVariable[]    Property currentProgressVars Auto
{The current progress in each tree.}
GlobalVariable[]    Property requiredProgressVars Auto
{The progress needed to earn a new perk in each tree.}
GlobalVariable[]    Property campfireProgressVars Auto
{The progress-based percentages shown in the Campfire menu (currentProgressVar divided by requiredProgressVar and rounded to two digits).}
GlobalVariable[]    Property perksAvailableVars Auto
{The numbers of perks available in each tree.}
GlobalVariable[]    Property perksEarnedVars Auto
{The numbers of perks the player has earned in each tree.}
GlobalVariable[]    Property perksTotalVars Auto
{The total numbers of perks in each tree.}

Function AdvanceWildfireSkill(int skill, int amount)
{Advances the specified skill and grants perks if applicable.
Arguments:
- amount: The amount of points to advance archaeology by.}
    ; TODO Make 5 and 10 configurable
    AdvanceSkillManual(amount, \
                       perksTotalVars[skill].GetValue() as int, \
                       5, \
                       10, \
                       currentProgressVars[skill], \
                       requiredProgressVars[skill], \
                       campfireProgressVars[skill], \
                       perksAvailableVars[skill], \
                       perksEarnedVars[skill], \
                       skillAdvancedMessages[skill], \
                       perkEarnedMessages[skill])
EndFunction

Function AdvanceSkillManual(int amount, int numPerks, int linearScale, int constantScale, GlobalVariable progressVar, GlobalVariable requiredProgressVar, GlobalVariable campfireProgressVar, GlobalVariable availablePerksVar, GlobalVariable earnedPerksVar, Message skillAdvancedMsg, Message perkEarnedMsg)
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

bool Function IsTreeUnlocked(int skill)
    {Returns true if the specified skill tree has already been unlocked.
    Arguments:
     - skill: The unique ID of the skill tree in question.
    Returns:
     true if the specified skill tree has already been unlocked.}
    return treeUnlockedVars[skill].GetValue() == 1
EndFunction

Function UnlockTree(int skill, bool grantPerk)
    {Unlocks the specified tree and grants a perk in it if the boolean is set to true.
    Arguments:
     - skill: The unique ID of the skill tree in question.
     - grantPerk: Whether or not to grant the player a perk as well.}
    If(CampUtil.RegisterPerkTree(nodeControllers[skill], "Wildfire.esp"))
        treeUnlockedVars[skill].SetValue(1)
        treeUnlockedMessages[skill].Show()
        If(grantPerk)
            ; TODO Make 5 and 10 configurable
            GrantPerk(5, \
                      10, \
                      currentProgressVars[skill], \
                      requiredProgressVars[skill], \
                      campfireProgressVars[skill], \
                      perksAvailableVars[skill], \
                      perksEarnedVars[skill], \
                      perkEarnedMessages[skill])
        EndIf
    Else
        ; something went very wrong
        messageFailedRegistration.Show()
    EndIf
EndFunction
