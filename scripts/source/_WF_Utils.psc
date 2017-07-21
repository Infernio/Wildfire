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
