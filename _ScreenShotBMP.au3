#NoTrayIcon
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

Global Const $SYSTEMROOT = EnvGet('systemdrive')
Global $iX1, $iY1, $iX2, $iY2, $aPos, $sMsg, $sBMP_Path, $dc, $hPic, $hBitmap_GUI
Global $editValue = False
Global $OS = @OSVersion
Global $Qmark = Chr(34)
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
; Create GUI
$hMain_GUI = GUICreate("Snipping Tool", 510, 50)
;GUISetOnEvent($GUI_EVENT_CLOSE, "mGUI_Close", "Snipping Tool")

$hRect_Button = GUICtrlCreateButton("Capture", 10, 10, 80, 30)
GUICtrlSetOnEvent($hMain_GUI, "_Capture")
$hEmail_Button = GUICtrlCreateButton("Email", 310, 10, 80, 30)
GUICtrlSetOnEvent($hMain_GUI, "_Email")
GUICtrlSetState($hEmail_Button, $GUI_DISABLE)
$hCancel_Button = GUICtrlCreateButton("Cancel", 410, 10, 80, 30)
GUICtrlSetOnEvent($hMain_GUI, "mGUI_Close")
$hEdit_Button = GUICtrlCreateButton("Edit", 110, 10, 80, 30)
GUICtrlSetState($hEdit_Button, $GUI_DISABLE)
GUICtrlSetOnEvent($hMain_GUI, "_Edit")
$hSave_Button = GUICtrlCreateButton("Save", 210, 10, 80, 30)
GUICtrlSetOnEvent($hMain_GUI, "_Save")
GUICtrlSetState($hSave_Button, $GUI_DISABLE)

GUISetState(@SW_HIDE,$hMain_GUI)

Func _Setimg()
    Local $editWin = WinExists("[CLASS:MSPaintApp]", "")
    Local $cWin = WinExists("Captured Image", "")
    Local $eState = GUICtrlGetState($hEdit_Button)
    If $editWin = 0 And $eState = "144" And $cWin = 1 Then
        $editValue = False
        GUICtrlSetData($hEdit_Button, "Edit")
        GUICtrlSetState($hEdit_Button, $GUI_ENABLE)
        GUICtrlSetImage($hPic, @ScriptDir & "\temp.bmp")
        WinActivate("Captured Image", "")
    EndIf
EndFunc   ;==>_Setimg

Func GetPosition()

    Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp, $data[4]
    Local $UserDLL = DllOpen("user32.dll")

    Global $hRectangle_GUI = GUICreate("", @DesktopWidth * 3, @DesktopHeight * 3, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
    _GUICreateInvRect($hRectangle_GUI, 0, 0, 1, 1)
    GUISetBkColor(0)
    WinSetTrans($hRectangle_GUI, "", 75)
    GUISetState(@SW_SHOW, $hRectangle_GUI)
    GUISetCursor(3, 1, $hRectangle_GUI)

    ; Wait until mouse button pressed
    While Not _IsPressed("01", $UserDLL)
        Sleep(10)
    WEnd

    ; Get first mouse position
    $aMouse_Pos = MouseGetPos()
    $iX1 = $aMouse_Pos[0]
    $iY1 = $aMouse_Pos[1]

    ; Draw rectangle while mouse button pressed
    While _IsPressed("01", $UserDLL)

        $aMouse_Pos = MouseGetPos()

        ; Set in correct order if required
        If $aMouse_Pos[0] < $iX1 Then
            $iX_Pos = $aMouse_Pos[0]
            $iWidth = $iX1 - $aMouse_Pos[0]
        Else
            $iX_Pos = $iX1
            $iWidth = $aMouse_Pos[0] - $iX1
        EndIf
        If $aMouse_Pos[1] < $iY1 Then
            $iY_Pos = $aMouse_Pos[1]
            $iHeight = $iY1 - $aMouse_Pos[1]
        Else
            $iY_Pos = $iY1
            $iHeight = $aMouse_Pos[1] - $iY1
        EndIf

        _GUICreateInvRect($hRectangle_GUI, $iX_Pos, $iY_Pos, $iWidth, $iHeight)

        Sleep(10)

    WEnd

    ; Get second mouse position
    $iX2 = $aMouse_Pos[0]
    $iY2 = $aMouse_Pos[1]

	$data[0] = $iX1
	$data[1] = $iY1
	$data[2] = $iX2
	$data[3] = $iY2

    GUIDelete($hRectangle_GUI)
    DllClose($UserDLL)

	Return $data
EndFunc ;==>GetPosition

Func Mark_Rect()

    Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
    Local $UserDLL = DllOpen("user32.dll")

    Global $hRectangle_GUI = GUICreate("", @DesktopWidth * 3, @DesktopHeight * 3, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
    _GUICreateInvRect($hRectangle_GUI, 0, 0, 1, 1)
    GUISetBkColor(0)
    WinSetTrans($hRectangle_GUI, "", 75)
    GUISetState(@SW_SHOW, $hRectangle_GUI)
    GUISetCursor(3, 1, $hRectangle_GUI)

    ; Wait until mouse button pressed
    While Not _IsPressed("01", $UserDLL)
        Sleep(10)
    WEnd

    ; Get first mouse position
    $aMouse_Pos = MouseGetPos()
    $iX1 = $aMouse_Pos[0]
    $iY1 = $aMouse_Pos[1]

    ; Draw rectangle while mouse button pressed
    While _IsPressed("01", $UserDLL)

        $aMouse_Pos = MouseGetPos()

        ; Set in correct order if required
        If $aMouse_Pos[0] < $iX1 Then
            $iX_Pos = $aMouse_Pos[0]
            $iWidth = $iX1 - $aMouse_Pos[0]
        Else
            $iX_Pos = $iX1
            $iWidth = $aMouse_Pos[0] - $iX1
        EndIf
        If $aMouse_Pos[1] < $iY1 Then
            $iY_Pos = $aMouse_Pos[1]
            $iHeight = $iY1 - $aMouse_Pos[1]
        Else
            $iY_Pos = $iY1
            $iHeight = $aMouse_Pos[1] - $iY1
        EndIf

        _GUICreateInvRect($hRectangle_GUI, $iX_Pos, $iY_Pos, $iWidth, $iHeight)

        Sleep(10)

    WEnd

    ; Get second mouse position
    $iX2 = $aMouse_Pos[0]
    $iY2 = $aMouse_Pos[1]

    ; Set in correct order if required
    If $iX2 < $iX1 Then
        $iTemp = $iX1
        $iX1 = $iX2
        $iX2 = $iTemp
    EndIf
    If $iY2 < $iY1 Then
        $iTemp = $iY1
        $iY1 = $iY2
        $iY2 = $iTemp
    EndIf

    GUIDelete($hRectangle_GUI)
    DllClose($UserDLL)

EndFunc   ;==>Mark_Rect

Func _GUICreateInvRect($hWnd, $iX, $iY, $iW, $iH)

    $hMask_1 = _WinAPI_CreateRectRgn(0, 0, @DesktopWidth * 3, $iY)
    $hMask_2 = _WinAPI_CreateRectRgn(0, 0, $iX, @DesktopHeight * 3)
    $hMask_3 = _WinAPI_CreateRectRgn($iX + $iW, 0, @DesktopWidth * 3, @DesktopHeight * 3)
    $hMask_4 = _WinAPI_CreateRectRgn(0, $iY + $iH, @DesktopWidth * 3, @DesktopHeight * 3)

    _WinAPI_CombineRgn($hMask_1, $hMask_1, $hMask_2, 2)
    _WinAPI_CombineRgn($hMask_1, $hMask_1, $hMask_3, 2)
    _WinAPI_CombineRgn($hMask_1, $hMask_1, $hMask_4, 2)

    _WinAPI_DeleteObject($hMask_2)
    _WinAPI_DeleteObject($hMask_3)
    _WinAPI_DeleteObject($hMask_4)

    _WinAPI_SetWindowRgn($hWnd, $hMask_1, 1)

EndFunc   ;==>_GUICreateInvRect

Func _Capture($name = "Captured")
    If WinExists("Captured Image", "") = 1 Then GUIDelete("Captured Image")
    FileDelete(@ScriptDir & "\temp.bmp")
    GUISetState(@SW_HIDE, $hMain_GUI)
    Mark_Rect()
    ; Capture selected area
    $sBMP_Path = @ScriptDir & "\temp.bmp"
    _ScreenCapture_Capture($sBMP_Path, $iX1, $iY1, $iX2, $iY2, False)
    GUICtrlSetState($hSave_Button, $GUI_ENABLE)
    GUICtrlSetState($hEdit_Button, $GUI_ENABLE)
    GUICtrlSetState($hEmail_Button, $GUI_ENABLE)
    ; Display image
    $hBitmap_GUI = GUICreate("Captured Image", $iX2 - $iX1 + 50, $iY2 - $iY1 + 50, Default, Default)
    GUISetBkColor(0x525252, "Captured Image")
    ;GUISetOnEvent($GUI_EVENT_CLOSE, "cGUI_Close", "Captured Image")
    $hPic = GUICtrlCreatePic(@ScriptDir & "\temp.bmp", 25, 25, $iX2 - $iX1 + 1, $iY2 - $iY1 + 1)
    Local $cIpos=WinGetPos("Captured Image", "")
    ;GUISetState()
    ;GUISetState(@SW_SHOW, $hMain_GUI)
    ;WinMove("Snipping Tool", "", $cIpos[0], $cIpos[1]-85)
	;GUISetState($hMain_GUI,@SW_HIDE)
	GUISetState(@SW_HIDE,$hMain_GUI)
	GUISetState(@SW_HIDE,$hBitmap_GUI)
	;GUISetState(@SW_HIDE,$hRectangle_GUI)
	GUIDelete($hMain_GUI)
	;GUIDelete($hRectangle_GUI)
	GUIDelete($hBitmap_GUI)
	_Save($name)

EndFunc   ;==>_Capture

Func _ExitBmp()
	GUIDelete($hRectangle_GUI)
EndFunc

Func _Edit()
    $editValue = True
    GUICtrlSetState($hEdit_Button, $GUI_DISABLE)
    If $OS = "WIN_XP" Then
        Local $Paint = Run("mspaint " & $Qmark & @ScriptDir & "\temp.bmp" & $Qmark)
        Sleep(3000)
    Else
        Local $Paint = Run("mspaint " & @ScriptDir & "\temp.bmp")
    EndIf
    Sleep(1000)

    Do
        Local $editWin = WinExists("[CLASS:MSPaintApp]", "")
        Sleep(10)
    Until $editWin = 1
    AdlibRegister("_SetImg", 200)
    Do
        Local $editWin = WinExists("[CLASS:MSPaintApp]", "")
        Do
            Local $editWinAct = WinActive("[CLASS:MSPaintApp]", "")
            If $editWinAct > 0 Then Send("^s")
            Sleep(1000)
        Until $editWinAct = 0
    Until $editWin = 0

EndFunc   ;==>_Edit

Func _Save($name = "Captured")
    Local $scPath = @ScriptDir & "\img\"
    If Not FileExists($scPath) Then DirCreate($scPath)
    Local $savePath = FileSaveDialog("Save your screen capture", $scPath, "bmp (*.bmp)", 16, $name, "Captured Image")
    FileCopy(@ScriptDir & "\temp.bmp", $savePath, 1)
	Sleep(100)
	FileDelete(@ScriptDir & "\temp.bmp")
	GUIDelete($hMain_GUI)
	GUIDelete($hRectangle_GUI)
	GUIDelete($hBitmap_GUI)
EndFunc   ;==>_Save

Func _Email()
    Local $OLtest = MsgBox(4, "Checking for Outlook", "Is Microsoft Outlook installed and configured on this pc?" & @CRLF & "If not you will be able to use this programs built-in mail client")
    If $OLtest = 6 Then
        Local $lPath = _GetAppropriatePath("C:\Program*\Microsoft*\Office*\OUTLOOK.EXE", 0)
        Run($lPath & " /a " & @ScriptDir & "\temp.bmp")
        If @error Then
            MsgBox(0, "Error", "Outlook is indeed NOT installed and configured on this pc")
        EndIf
    ElseIf $OLtest = 7 Then
        _mail_win()
    EndIf
EndFunc   ;==>_Email

Func _mail_win()
    GUISetState(@SW_HIDE, $hMain_GUI)
    GUISetState(@SW_HIDE, $hBitmap_GUI)
    Sleep(100)
    _mGUI()
EndFunc   ;==>_mail_win

Func _mGUI()
    Local $fT = FileExists(@ScriptDir & "\temp.bmp")
    If $fT = 1 Then
        Local $aF = StringReplace(@ScriptDir & "\temp.bmp", "Snip", "...")
    Else
        MsgBox(0, "Error", "Snip failed to attached the captured image." & @CRLF & "Contact an administrator to resolve this issue.")
        Local $aF = "File not found"
    EndIf
    Global $SSmGUI = GUICreate("Snip Mail", 377, 663, 192, 124)
    GUISetOnEvent($GUI_EVENT_CLOSE, "SSmGUI_Close", "Snip Mail")
    Global $mGroup1 = GUICtrlCreateGroup("  Snip Built-in Mail Client  ", 10, 8, 357, 593, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
    GUICtrlSetFont(-1, 12, 800, 4, "Calibri")
    Global $mGroup2 = GUICtrlCreateGroup(" Enter your email address ", 24, 32, 331, 67)
    GUICtrlSetFont(-1, 12, 400, 0, "Calibri")
    Global $mInput1 = GUICtrlCreateInput("", 42, 62, 155, 27, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT))
    Global $mLabel1 = GUICtrlCreateLabel("@gmail.com", 206, 64, 130, 23)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    Global $mGroup3 = GUICtrlCreateGroup(" Enter the recipients email address ", 24, 114, 331, 89, BitOR($GUI_SS_DEFAULT_GROUP, $BS_RIGHT))
    GUICtrlSetFont(-1, 12, 400, 0, "Calibri")
    Global $mInput2 = GUICtrlCreateInput("", 42, 156, 155, 27, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT))
    Global $mLabel2 = GUICtrlCreateLabel("@gmail.com", 206, 158, 130, 23)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    Global $mGroup4 = GUICtrlCreateGroup(" Attached File ", 24, 208, 331, 47)
    GUICtrlSetFont(-1, 12, 400, 0, "Calibri")
    Global $Label3 = GUICtrlCreateLabel($aF, 46, 230)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    Global $mGroup5 = GUICtrlCreateGroup(" Settings ", 24, 496, 331, 89, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
    GUICtrlSetFont(-1, 12, 400, 0, "Calibri")
    Global $mGroup6 = GUICtrlCreateGroup(" Server ", 34, 516, 161, 57)
    Global $mInput3 = GUICtrlCreateInput("", 40, 540, 149, 27, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    Global $mGroup7 = GUICtrlCreateGroup(" PORT ", 200, 516, 145, 57, BitOR($GUI_SS_DEFAULT_GROUP, $BS_RIGHT))
    Global $mInput4 = GUICtrlCreateInput("", 234, 540, 73, 27, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    Global $mGroup8 = GUICtrlCreateGroup(" Comments ", 24, 260, 331, 233, BitOR($GUI_SS_DEFAULT_GROUP, $BS_RIGHT))
    GUICtrlSetFont(-1, 12, 400, 0, "Calibri")
    Global $mEdit1 = GUICtrlCreateEdit("", 32, 282, 313, 201, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    Global $mButton1 = GUICtrlCreateButton("SEND", 32, 608, 157, 45)
    GUICtrlSetOnEvent(-1, "_SSmail")
    Global $mButton2 = GUICtrlCreateButton("CANCEL", 198, 608, 157, 45)
    GUICtrlSetOnEvent(-1, "SSmGUI_Close")
    GUISetState()
EndFunc   ;==>_mGUI

Func _SSmail()

    Local $SmtpServer = GUICtrlRead($mInput3)
    Local $FromName = GUICtrlRead($mInput1)
    Local $FromAddress = GUICtrlRead($mInput1) & GUICtrlRead($mLabel1)
    Local $ToAddress = GUICtrlRead($mInput2) & GUICtrlRead($mLabel1)
    Local $Subject = "Snippet sent from Snipping Tool"
    Local $AttachFiles = @ScriptDir & "\temp.bmp"
    Local $CcAddress = ""
    Local $BccAddress = ""
    Local $Importance = "Normal"
    Local $Username = ""
    Local $Password = ""
    Local $IPPort = Number(GUICtrlRead($mInput4))
    Local $ssl = 0
    Local $Body = GUICtrlRead($mEdit1)

    $rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
    Sleep(1000)
    If @error Then
        MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
    Else
        SSmGUI_Close()
    EndIf
EndFunc   ;==>_SSmail

Func mGUI_Close()
    DllClose($dc)
    FileDelete(@ScriptDir & "\temp.bmp")
    Return
EndFunc   ;==>mGUI_Close

Func cGUI_Close()
    $editValue = False
    GUICtrlSetData($hEdit_Button, "Edit")
    GUICtrlSetState($hSave_Button, $GUI_DISABLE)
    GUICtrlSetState($hEdit_Button, $GUI_DISABLE)
    GUICtrlSetState($hEmail_Button, $GUI_DISABLE)
    FileDelete(@ScriptDir & "\temp.bmp")
    GUIDelete("Captured Image")
EndFunc   ;==>cGUI_Close

Func SSmGUI_Close()
    GUIDelete("Snip Mail")
    Sleep(100)
    GUISetState(@SW_SHOW, $hMain_GUI)
    GUISetState(@SW_SHOW, $hBitmap_GUI)
EndFunc   ;==>SSmGUI_Close

Func _GetAppropriatePath($sPath, $iLevel = 0)

    Local $hSearch, $tPath, $File, $Item, $Path, $Ret, $Dir = '', $Suf = '', $Result = ''

    $tPath = DllStructCreate('wchar[1024]')
    $Ret = DllCall('kernel32.dll', 'dword', 'GetFullPathNameW', 'wstr', $sPath, 'dword', 1024, 'ptr', DllStructGetPtr($tPath), 'ptr', 0)
    If (@error) Or (Not $Ret[0]) Then
        Return ''
    EndIf
    $sPath = DllStructGetData($tPath, 1)
    If StringRight($sPath, 1) = '\' Then
        $Dir = '\'
    EndIf
    $Item = StringSplit(StringRegExpReplace($sPath, '\\\Z', ''), '\')
    Select
        Case $iLevel + 1 = $Item[0]
            If FileExists($sPath) Then
                Return $sPath
            Else
                Return ''
            EndIf
        Case $iLevel + 1 > $Item[0]
            Return ''
    EndSelect
    For $i = 1 To $iLevel + 1
        $Result &= $Item[$i] & '\'
    Next
    $Result = StringRegExpReplace($Result, '\\\Z', '')
    If Not FileExists($Result) Then
        Return ''
    EndIf
    $hSearch = FileFindFirstFile($Result & '\*')
    If $hSearch = -1 Then
        Return ''
    EndIf
    For $i = $iLevel + 3 To $Item[0]
        $Suf &= '\' & $Item[$i]
    Next
    While 1
        $File = FileFindNextFile($hSearch)
        If @error Then
            $Result = ''
            ExitLoop
        EndIf
        If (Not @extended) And ($Dir) And ($iLevel + 2 = $Item[0]) Then
            ContinueLoop
        EndIf
        $Ret = DllCall('shlwapi.dll', 'int', 'PathMatchSpecW', 'wstr', $File, 'wstr', $Item[$iLevel + 2])
        If (Not @error) And ($Ret[0]) Then
            $Path = _GetAppropriatePath($Result & '\' & $File & $Suf & $Dir, $iLevel + 1)
            If $Path Then
                $Result = $Path
                ExitLoop
            EndIf
        EndIf
    WEnd
    FileClose($hSearch)
    Return $Result
EndFunc   ;==>_GetAppropriatePath

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance = "Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
    Local $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
        $objEmail.HTMLBody = $as_Body
    Else
        $objEmail.Textbody = $as_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
;~          ConsoleWrite('@@ Debug : $S_Files2Attach[$x] = ' & $S_Files2Attach[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
            If FileExists($S_Files2Attach[$x]) Then
                ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
                SetError(1)
                Return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 Then $IPPort = 25
    $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    ;Update tings
    $objEmail.Configuration.Fields.Update
    ;  Email Importance
    Switch $s_Importance
        Case "High"
            $objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "High"
        Case "Normal"
            $objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Normal"
        Case "Low"
            $objEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Low"
    EndSwitch
    $objEmail.Fields.Update
    ; Sent the Message
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
    $objEmail = ""
EndFunc   ;==>_INetSmtpMailCom
;
;
; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>MyErrFunc