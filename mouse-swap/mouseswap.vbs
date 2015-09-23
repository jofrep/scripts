
'Wscript.Echo "===================================================="
'Wscript.Echo "==       Swap mousse hand  v1.0              ===="
'Wscript.Echo "===================================================="
'Wscript.Echo

Dim oShell
Set oShell = WScript.CreateObject ("WScript.shell")

Function SwapMouseButtons
  oShell.Run "RUNDLL32.EXE SHELL32.dll,Control_RunDLL main.cpl @0,0"
  WScript.Sleep 200
  oShell.SendKeys "%S"
  oShell.SendKeys "{Enter}"
End Function

Function SetMouseLeftHanded
  x = oShell.RegRead("HKCU\Control Panel\Mouse\SwapMouseButtons")
  if x=1 then SwapMouseButtons
End Function

Function SetMouseRightHanded
  x = oShell.RegRead("HKCU\Control Panel\Mouse\SwapMouseButtons")
  if x=0 then SwapMouseButtons
End Function

SwapMouseButtons()