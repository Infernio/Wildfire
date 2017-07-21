ScriptName _WF_RelicTrackingScript Extends ReferenceAlias

Keyword         Property isRelic Auto
GlobalVariable  Property archaeologyDiscovered Auto
Message         Property archaeologyUnlockedMessage Auto
Activator       Property archaeologyNodeController Auto
GlobalVariable  Property archaeologyPerksAvailable Auto
GlobalVariable  Property archaeologyRelicsRequired Auto

Event OnInit()
    GlobalVariable CampfireAPIVersion = Game.GetFormFromFile(0x03F1BE, "Campfire.esm") as GlobalVariable
    If(CampfireAPIVersion.GetValueInt() < 4)
        Debug.MessageBox("Please update to the latest Campfire version, otherwise Wildfire might not work correctly.")
    EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    If(akBaseItem.HasKeyword(IsRelic))
        If(archaeologyDiscovered.GetValue() == 0)
            ; we discovered archaeology
            If(CampUtil.RegisterPerkTree(archaeologyNodeController))
                archaeologyUnlockedMessage.Show()
                NextPerk()
                archaeologyDiscovered.SetValue(1)
            Else
                ; something went very wrong
                Debug.MessageBox("Failed to register a perk tree. You may have too many Campfire perk tree mods installed.")
            EndIf
        EndIf
    EndIf
EndEvent

Function NextPerk()
    archaeologyPerksAvailable.SetValue(archaeologyPerksAvailable.GetValue() + 1)
    archaeologyRelicsRequired.SetValue(archaeologyRelicsRequired.GetValue() * 10)
EndFunction
