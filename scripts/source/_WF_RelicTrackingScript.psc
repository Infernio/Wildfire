ScriptName _WF_RelicTrackingScript Extends ReferenceAlias
{Tracks the relics that a player picks up and grants perks based on that.}

import _WF_Utils

Keyword         Property isRelic Auto
{The keyword that indicates whether or not an item is a relic.}
GlobalVariable  Property archaeologyUnlocked Auto
{The global variable that determines whether or not archaeology has been unlocked already.}
Message         Property archaeologyUnlockedMessage Auto
{The message that will be shown to the player when they unlock archaeology.}
Message         Property archaeologySkillAdvancedMessage Auto
{The message that will be shown to the player when they find relics but don't have enough for a perk yet.}
Activator       Property archaeologyNodeController Auto
{The node controller that controls the archaeology perk tree.}
GlobalVariable  Property archaeologyPerksAvailable Auto
{The global variable that stores the number of available archaeology perks.}
GlobalVariable  Property archaeologyPerkProgress Auto
{The progress towards the next perk, in the range [0 - 1].}
GlobalVariable  Property archaeologyPerksEarned Auto
{The global variable that stores the number of archaeology perks that have already been earned.}
GlobalVariable  Property archaeologyPerksTotal Auto
{The global variable that stores the total number of perks in the archaeology tree.}
Message         Property archaeologyPerkEarnedMessage Auto
{The message that will be shown to the player when they gain a perk.}
GlobalVariable  Property archaeologyRelicsFound Auto
{The global variable that stores the number of relics that have been found towards the next perk.}
GlobalVariable  Property archaeologyRelicsRequired Auto
{The global variable that stores the number of relics required for the next perk.}

Event OnInit()
    CheckCampfireVersion()
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    If(akBaseItem.HasKeyword(IsRelic))
        If(archaeologyUnlocked.GetValue() == 0)
            ; we discovered archaeology
            If(CampUtil.RegisterPerkTree(archaeologyNodeController, "Wildfire.esp"))
                archaeologyUnlockedMessage.Show()
                GrantPerk()
                archaeologyUnlocked.SetValue(1)
            Else
                ; something went very wrong
                Debug.MessageBox("Failed to register a perk tree. You may have too many Campfire perk tree mods installed.")
            EndIf

        ; if there are still perks to unlock, increase the 'relics found' counter
        ElseIf(archaeologyPerksEarned.GetValue() < archaeologyPerksTotal.GetValue())
            int i = 0
            bool showSkillAdvancedMsg = false
            While(i < aiItemCount)
                IncrementGlobalVariable(archaeologyRelicsFound)
                archaeologyPerkProgress.SetValue(archaeologyRelicsFound.GetValue() / archaeologyRelicsRequired.GetValue())

                ; if that put us over the 'required relics' mark, grant a perk
                If(archaeologyRelicsFound.GetValue() >= archaeologyRelicsRequired.GetValue())
                    GrantPerk()
                Else
                    showSkillAdvancedMsg = true
                EndIf

                i += 1
            EndWhile

            ; show this 'skill advanced' message only once to limit spam
            If(showSkillAdvancedMsg)
                archaeologySkillAdvancedMessage.Show()
            EndIf
        EndIf
    EndIf
EndEvent

Function GrantPerk()
{Grants a perk and advances the relevant global variables.}
    IncrementGlobalVariable(archaeologyPerksAvailable)
    archaeologyRelicsRequired.SetValue(archaeologyRelicsRequired.GetValue() * 5 + 10)
    archaeologyRelicsFound.SetValue(0)
    archaeologyPerkProgress.SetValue(0)
    archaeologyPerkEarnedMessage.Show()
EndFunction
