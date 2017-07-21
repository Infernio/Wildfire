ScriptName _WF_InspectRelic Extends ObjectReference
{This script prints a small message whenever the player activates this relic in their inventory.}

bool        Property _hasCustomMessage = false Auto
{Whether or not this relic has a custom message that should be shown. False by default.}
Message     Property _customMessage Auto
{The custom message to show. Only used if hasCustomMessage is set to true.}
int         Property relicType Auto
{The type of this relic. 0 is minor, 1 is normal, 2 is ancient.}
Message     Property messageRelicMinor Auto
{The message that will be shown for minor relics.}
Message     Property messageRelicNormal Auto
{The message that will be shown for normal relics.}
Message     Property messageRelicAncient Auto
{The message that will be shown for ancient relics.}

Event OnEquipped(Actor actor)
    If(_hasCustomMessage)
        _customMessage.Show()
    Else
        If(relicType == 0)
            messageRelicMinor.Show()
        ElseIf(relicType == 1)
            messageRelicNormal.Show()
        ElseIf(relicType == 2)
            messageRelicAncient.Show()
        EndIf
    EndIf
EndEvent
