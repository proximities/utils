g := Gui()
g.OnEvent("Close", close)
g.SetFont("s16")

g.AddText(, "ahk control panel")
; f1 := g.AddCheckbox("Checked", "F1 -> LButton")
g.AddText(, "click delay")

delay := g.AddSlider("", 40)
delay.OnEvent("Change", click_changed)

g.Show()

SetCapsLockState("AlwaysOff")

RShift & t::
{
    ; focus terminals
    if WinExist("ahk_exe WindowsTerminal.exe") {
        WinActivate("ahk_exe WindowsTerminal.exe")
    } else if WinExist("ahk_exe mintty.exe") {
        WinActivate("ahk_exe mintty.exe")
    }
}
RShift & c::
{
    ; focus code
    if WinExist("ahk_exe Code.exe") {
        WinActivate("ahk_exe Code.exe")
    }
}
RShift & e::
{
    ; focus edge
    if WinExist("ahk_exe msedge.exe") {
        WinActivate("ahk_exe msedge.exe")
    }
}
RShift & v::
{
    if WinExist("ahk_exe devenv.exe") {
        WinActivate("ahk_exe devenv.exe")
    }
}

; F2:: {
;     MsgBox(delay.Value)
; }

#HotIf not WinActive("ahk_exe javaw.exe")
F1::LButton
#HotIf

#HotIf WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe chrome.exe")
; ctrl+p -> ctrl+shift+a
^p::
{
    Send("^+a")
}
; ` -> move mouse to center of screen and left click (gets out of weird vimium softlocks)
`::
{
    MouseMove(1280, 720)
    Send("{LButton}")
    ; sleep 100 and press esc
    Sleep(100)
    Send("{Esc}")
}
#HotIf

#HotIf WinActive("ahk_exe blender.exe")
; win -> middle mouse
LWin::MButton
#HotIf

; in vscode, f9 -> ctrl+shift+f9, then wait 1 second and press f9
#HotIf WinActive("ahk_exe Code.exe")
F9::
{
    Send("^+{F9}")
    Sleep(50)
    Send("{F9}")
}

; caps lock -> ctrl+shift+f9
CapsLock::
{
    Send("^+{F9}")
}
#HotIf


#HotIf WinActive("ahk_exe VALORANT-Win64-Shipping.exe") or WinActive("ahk_exe Overwatch.exe") or WinActive("ahk_exe javaw.exe")
z::
{
    Send("{w down}")
}
#HotIf

#HotIf WinActive("ahk_exe Overwatch.exe")
x::
{
    Send("{LButton down}")
}
#HotIf

#HotIf WinActive("ahk_exe javaw.exe")
SetTimer(Auto, delay.Value)
SetTimer(AutoRight, 100)
click_changed(*) {
    SetTimer(Auto, delay.Value)
}

active := false

`::
; type /play duels_combo_duel in chat
{
    Send("t")
    Sleep(100)
    SendText("/play duels_combo_duel")
    Sleep(100)
    Send("{Enter}")
}
XButton2::
{
    global active
    active := !active
    return
}

Auto()
{
    global active
    if active {
        Click()
    }
}

AutoRight()
{
    if GetKeyState("XButton1") {
        MouseClick("right")
    }
}
x::
{
    Send(3)
    Send("{RButton down}")
    Sleep(1750)
    Send(4)
    Sleep(200)
    Send(2)
    Sleep(1800)
    Send("{RButton up}")
    Sleep(200)
    Send("f")
    return
}


#HotIf

close(*) {
    ExitApp()
}

#Requires AutoHotkey v2.0
ShellRun(prms*)
{
    shellWindows := ComObject("Shell.Application").Windows
    desktop := shellWindows.FindWindowSW(0, 0, 8, 0, 1) ; SWC_DESKTOP, SWFO_NEEDDISPATCH

    ; Retrieve top-level browser object.
    tlb := ComObjQuery(desktop,
        "{4C96BE40-915C-11CF-99D3-00AA004AE837}", ; SID_STopLevelBrowser
        "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser

    ; IShellBrowser.QueryActiveShellView -> IShellView
    ComCall(15, tlb, "ptr*", sv := ComValue(13, 0)) ; VT_UNKNOWN

    ; Define IID_IDispatch.
    NumPut("int64", 0x20400, "int64", 0x46000000000000C0, IID_IDispatch := Buffer(16))

    ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
    ComCall(15, sv, "uint", 0, "ptr", IID_IDispatch, "ptr*", sfvd := ComValue(9, 0)) ; VT_DISPATCH

    ; Get Shell object.
    shell := sfvd.Application

    ; IShellDispatch2.ShellExecute
    shell.ShellExecute(prms*)
}

; This is the key combo.
#HotIf WinActive("ahk_exe explorer.exe")
`::
{
    ; Cache the current clipboard contents.
    clipboard := A_Clipboard

    ; Clear the clipboard & copy selected files.
    A_Clipboard := ""
    Send("^c")

    ; increase wait time if clipboard data is not ready
    ClipWait(0.1)

    hwnd := WinGetID("A")

    for window in ComObject("Shell.Application").Windows {
        if (window && window.hwnd && window.hwnd == hwnd) {
            ; Get the current folder's path.
            path := window.Document.Folder.Self.Path
        }
    }

    ShellRun("C:\Users\pblpbl\AppData\Local\Programs\Microsoft VS Code\code.exe", path)
    ; Run("C:\Users\pblpbl\AppData\Local\Programs\Microsoft VS Code\code.exe", path)
}
#HotIf