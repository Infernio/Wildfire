ScriptName _WF_MCMScript Extends SKI_ConfigBase

int testToggleOID_1
int testToggleOID_2
int testToggleOID_3
bool testToggle1
bool testToggle2
bool testToggle3

int Function GetVersion()
    return 1
EndFunction

Event OnConfigInit()
    Pages = new String[1]
    Pages[0] = "Main"
EndEvent

Event OnVersionUpdate(int a_version)
    Debug.Trace("Updating MCM script to version " + a_version)
EndEvent

Event OnPageReset(string a_page)
    If(a_page == "")
        LoadCustomContent("interface/wildfire/logo.dds", 258, 95)
        Return
    Else
        UnloadCustomContent()
    EndIf

    If(a_page == "Main")
        SetCursorFillMode(TOP_TO_BOTTOM)

        AddHeaderOption("Test Toggles")
        testToggleOID_1 = AddToggleOption("Test Toggle 1", testToggle1)
        testToggleOID_2 = AddToggleOption("Test Toggle 2", testToggle2)
        testToggleOID_3 = AddToggleOption("Test Toggle 3", testToggle3)

        SetCursorPosition(1)
    EndIf
EndEvent

Event OnOptionSelect(int a_option)
    If(a_option == testToggleOID_1)
        testToggle1 = !testToggle1
        SetToggleOptionValue(a_option, testToggle1)
    ElseIf(a_option == testToggleOID_2)
        testToggle2 = !testToggle2
        SetToggleOptionValue(a_option, testToggle2)
    ElseIf(a_option == testToggleOID_3)
        testToggle3 = !testToggle3
        SetToggleOptionValue(a_option, testToggle3)
    EndIf
EndEvent

Event OnOptionHighlight(int a_option)
    If(a_option == testToggle1)
        SetTextOptionValue(a_option, "A simple testing toggle")
    ElseIf(a_option == testToggle2)
        SetTextOptionValue(a_option, "A second testing toggle")
    ElseIf(a_option == testToggle3)
        SetTextOptionValue(a_option, "Another testing toggle")
    EndIf
EndEvent
