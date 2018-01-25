ScriptName _WF_Compatibility Extends ReferenceAlias
{The main compatibility script used to handle compatibility with other mods.}

; General
Actor   Property PlayerRef Auto
{The player reference.}

; Internals
bool    Property IsDone = false Auto Hidden
{Whether or not the compatibility checks have run.}

; Messages
Message Property MessageChecksStarted Auto
{The message shown to the player when the compatibility checks have started running.}
Message Property MessageChecksFinished Auto
{The message shown to the player when the compatibility checks have finished running.}
Message Property MessageMissingWildfire Auto
{The warning shown to the player when Wildfire.esp could not be found.}
Message Property MessageMissingCampfire Auto
{The message shown to the player when their Campfire esm has somehow gone missing.}
Message Property MessageOutdatedCampfire Auto
{The message shown to the player when their Campfire version is insufficient to run Wildfire.}

; Mod Information
bool    Property SKSELoaded = false Auto Hidden

Event OnInit()
    RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
    ; Ensure that we are ingame before running the compatibility checks
    If(PlayerRef.Is3DLoaded())
        RunAllChecks(true)
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndEvent

Event OnPlayerLoadGame()
    Debug.Trace("[Wildfire] Game load detected - running checks.")
    RunAllChecks(false)
    Debug.Trace("[Wildfire] Game load checks completed")
EndEvent

Function RunAllChecks(bool showMessages)
    {Runs all compatibility checks and logs appropriately.}
    IsDone = false
    Debug.Trace("[Wildfire] Starting compatibility checks - errors are normal and expected.")
    If(showMessages)
        MessageChecksStarted.Show()
    EndIf

    ; Make sure that Wildfire's esp and version are available
    CheckWildfire()

    ; Check if SKSE is available
    CheckSKSE()

    ; Check for other mods and enable automatic compatibility
    ; TODO Add these here

    If(showMessages)
        MessageChecksFinished.Show()
    EndIf
    Debug.Trace("[Wildfire] Compatibility checks done.")
    IsDone = true
EndFunction

; ----- WILDFIRE ----- ;
Function CheckWildfire()
    {Makes sure that Wildfire's esp is available (i.e. has not been merged into a different esp) and that its version number can be found.}
    If(!Game.GetFormFromFile(0x084BD4, "Wildfire.esp") as GlobalVariable)
        ; If the warning property was filled (a newer version might have changed its name), use that
        If(MessageMissingWildfire)
            MessageMissingWildfire.Show()
        Else
            ; Otherwise, we'll have to use this method
            Debug.MessageBox("Wildfire.esp could not be found. This is a SEVERE error - Wildfire will not able to continue running.\n\nLikely reasons are:\n - An incomplete, corrupt or outdated installation of Wildfire.\n - Wildfire has been merged into a different esp file.\n\nPlease make sure that you have the latest version of Wildfire installed and that it is NOT merged into a different esp before reporting this issue.")
        EndIf
    EndIf
EndFunction

; ----- SKSE ----- ;
Function CheckSKSE()
    {Checks whether or not SKSE is loaded.}
    SKSELoaded = SKSE.GetVersionRelease() > 0
EndFunction

; ---- NEXT MOD NAME HERE ---- ;
