ScriptName _WF_Utils Hidden
{Utility functions used in many Wildfire scripts.}

float Function GetTotalMagicSkills(Actor player) Global
    {Returns the total number of skill points the player has in all magic skills.
    The magic skills are: Alteration, Conjuration, Destruction, Illusion, Restoration.
    None of these functions include Enchanting, Alchemy and Smithing.
    Arguments:
     - player: The player instance.
    Returns:
     The total number of skill points the player has in all magic skills (except Enchanting).}
    return player.GetActorValue("Alteration") + player.GetActorValue("Conjuration") + player.GetActorValue("Destruction") + player.GetActorValue("Illusion") + player.GetActorValue("Restoration")
EndFunction

float Function GetTotalStealthSkills(Actor player) Global
    {Returns the total number of skill points the player has in all stealth skills.
    The stealth skills are: Light Armor, Pickpocketing, Lockpicking, Sneaking and Speechcraft.
    None of these functions include Enchanting, Alchemy and Smithing.
    Arguments:
     - player: The player instance.
    Returns:
     The total number of skill points the player has in all stealth skills (except Alchemy).}
    return player.GetActorValue("LightArmor") + player.GetActorValue("Pickpocket") + player.GetActorValue("Lockpicking") + player.GetActorValue("Sneak") + player.GetActorValue("Speechcraft")
EndFunction

float Function GetTotalCombatSkills(Actor player) Global
    {Returns the total number of skill points the player has in all combat skills.
    The combat skills: One Handed, Two Handed, Archery, Blocking and Heavy Armor.
    None of these functions include Enchanting, Alchemy and Smithing.
    Arguments:
     - player: The player instance.
    Returns:
     The total number of skill points the player has in all combat skills (except Smithing).}
    return player.GetActorValue("OneHanded") + player.GetActorValue("TwoHanded") + player.GetActorValue("Marksman") + player.GetActorValue("Block") + player.GetActorValue("HeavyArmor")
EndFunction
