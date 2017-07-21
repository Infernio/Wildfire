ScriptName _WF_Utils hidden
{Utility functions used in many Wildfire scripts.}

Function CheckCampfireVersion() global
{Checks that the user has the required campfire version installed and shows an error if they don't.}
    GlobalVariable CampfireAPIVersion = Game.GetFormFromFile(0x03F1BE, "Campfire.esm") as GlobalVariable
    If(!CampfireAPIVersion || CampfireAPIVersion.GetValueInt() < 4)
        Debug.MessageBox("Please update to the latest Campfire version, otherwise Wildfire will not work correctly.")
    EndIf
EndFunction

Function IncrementGlobalVariable(GlobalVariable var) global
{Increments the specified global variable.}
    var.SetValue(var.GetValue() + 1)
EndFunction

Function DecrementGlobalVariable(GlobalVariable var) global
{Decrements the specified global variable.}
    var.SetValue(var.GetValue() - 1)
EndFunction

float Function GetTotalMagicSkills(Actor player) global
{Returns the total number of skill points the player has in all magic skills.
The magic skills are: Alteration, Conjuration, Destruction, Illusion, Restoration.
None of these functions include Enchanting, Alchemy and Smithing.}
    return player.GetActorValue("Alteration") + player.GetActorValue("Conjuration") + player.GetActorValue("Destruction") + player.GetActorValue("Illusion") + player.GetActorValue("Restoration")
EndFunction

float Function GetTotalStealthSkills(Actor player) global
{Returns the total number of skill points the player has in all stealth skills.
The stealth skills are: Light Armor, Pickpocketing, Lockpicking, Sneaking and Speechcraft.
None of these functions include Enchanting, Alchemy and Smithing.}
    return player.GetActorValue("LightArmor") + player.GetActorValue("Pickpocket") + player.GetActorValue("Lockpicking") + player.GetActorValue("Sneak") + player.GetActorValue("Speechcraft")
EndFunction

float Function GetTotalCombatSkills(Actor player) global
{Returns the total number of skill points the player has in all combat skills.
The combat skills: One Handed, Two Handed, Archery, Blocking and Heavy Armor.
None of these functions include Enchanting, Alchemy and Smithing.}
    return player.GetActorValue("OneHanded") + player.GetActorValue("TwoHanded") + player.GetActorValue("Marksman") + player.GetActorValue("Block") + player.GetActorValue("HeavyArmor")
EndFunction

int Function GetResearchAmount(Form item, Keyword minor, Keyword normal, Keyword ancient) global
{Returns a fitting amount of research progress based on the keyword the specified item has.}
    ; TODO Change the amount the player gets here
    If(item.HasKeyword(minor))
        return 1
    ElseIf(item.HasKeyword(normal))
        return 10
    ElseIf(item.HasKeyword(ancient))
        return 100
    EndIf
EndFunction
