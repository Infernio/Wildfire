ScriptName _WF_InspectRelic Extends ObjectReference
{This script prints a small message whenever the player activates this relic in their inventory.}

Message Property MessageToShow Auto
{The message that should be shown to the player when they activate the relic.}

Event OnEquipped(Actor actor)
    MessageToShow.Show()
EndEvent
