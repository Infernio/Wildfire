ScriptName _WF_Compatibility Extends ReferenceAlias
{Performs compatibility checks when the mod is first installed.}

; GENERAL
Actor   Property playerRef Auto
{The player reference.}
bool    Property isDone Auto Hidden
{Whether or not the compatibility checks have run.}
Message Property messageStartingChecks Auto
{The message shown to the player when the compatibility checks have started running.}
Message Property messageFinishedChecks Auto
{The message shown to the player when the compatibility checks have finished running.}

; CAMPFIRE
Message Property messageCampfireMissing Auto
{The message shown to the player when their Campfire esm has somehow gone missing.}
Message Property messageCampfireOutdated Auto
{The message shown to the player when their Campfire version is insufficient to run Wildfire.}

Event OnInit()
    RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
    ; Make sure we're in-game
    If(playerRef.Is3DLoaded())
        RunChecks()
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndEvent

Function RunChecks()
    {Runs all compatibility checks.}
    Debug.Trace("[Wildfire] Running compatibility checks - errors are expected and normal")
    messageStartingChecks.Show()

    ; Check that the Campfire version is sufficient
    CheckCampfire()

    Debug.Trace("[Wildfire] Finished running compatibility checks")
    messageFinishedChecks.Show()
EndFunction

Function CheckCampfire()
    {Ensures that the installed Campfire version is sufficient to run Wildfire.}
    GlobalVariable CampfireAPIVersion = Game.GetFormFromFile(0x03F1BE, "Campfire.esm") as GlobalVariable
    If(!CampfireAPIVersion)
        ; What the hell
        messageCampfireMissing.Show()
    ElseIf(CampfireAPIVersion.GetValueInt() < 4)
        ; Tell the user to update Campfire
        messageCampfireOutdated.Show()
    EndIf
EndFunction
