#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\favicon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Author: Ngo Van Viet
;Phone: 0935147435
;Xin dung crack. Thank you
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <Date.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <_IMGSearch.au3>
#include <_ScreenShotBMP.au3>

Global $IdC[52]
$IdC[0] = "3 BÍCH"
$IdC[1] = "3 CHUỒN"
$IdC[2] = "3 RÔ"
$IdC[3] = "3 CƠ"
$IdC[4] = "4 BÍCH"
$IdC[5] = "4 CHUỒN"
$IdC[6] = "4 RÔ"
$IdC[7] = "4 CƠ"
$IdC[8] = "5 BÍCH"
$IdC[9] = "5 CHUỒN"
$IdC[10] = "5 RÔ"
$IdC[11] = "5 CƠ"
$IdC[12] = "6 BÍCH"
$IdC[13] = "6 CHUỒN"
$IdC[14] = "6 RÔ"
$IdC[15] = "6 CƠ"
$IdC[16] = "7 BÍCH"
$IdC[17] = "7 CHUỒN"
$IdC[18] = "7 RÔ"
$IdC[19] = "7 CƠ"
$IdC[20] = "8 BÍCH"
$IdC[21] = "8 CHUỒN"
$IdC[22] = "8 RÔ"
$IdC[23] = "8 CƠ"
$IdC[24] = "9 BÍCH"
$IdC[25] = "9 CHUỒN"
$IdC[26] = "9 RÔ"
$IdC[27] = "9 CƠ"
$IdC[28] = "10 BÍCH"
$IdC[29] = "10 CHUỒN"
$IdC[30] = "10 RÔ"
$IdC[31] = "10 CƠ"
$IdC[32] = "J BÍCH"
$IdC[33] = "J CHUỒN"
$IdC[34] = "J RÔ"
$IdC[35] = "J CƠ"
$IdC[36] = "Q BÍCH"
$IdC[37] = "Q CHUỒN"
$IdC[38] = "Q RÔ"
$IdC[39] = "Q CƠ"
$IdC[40] = "K BÍCH"
$IdC[41] = "K CHUỒN"
$IdC[42] = "K RÔ"
$IdC[43] = "K CƠ"
$IdC[44] = "A BÍCH"
$IdC[45] = "A CHUỒN"
$IdC[46] = "A RÔ"
$IdC[47] = "A CƠ"
$IdC[48] = "2 BÍCH"
$IdC[49] = "2 CHUỒN"
$IdC[50] = "2 RÔ"
$IdC[51] = "2 CƠ"
Global 	$GUIMsg, $GUI, $position[4]
Global 	$height = 190, $Random10, $Random5
$GUI 		= GUICreate("XENG.CLUB", 130, 250, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
$start 		= GUICtrlCreateButton("START", 4, 4, 120, 41, 0x0001)
Global $tolerance = GUICtrlCreateInput("100", 4, 48, 60, 20, $ES_NUMBER)
Global $tolerance2 = GUICtrlCreateInput("55", 64, 48, 60, 20, $ES_NUMBER)
$idListview = GUICtrlCreateListView(" Name | #", 4, 72, 120, 135)
For $i = 0 To UBound($IdC)-1
	If $i < 9 Then
		$new = "0" & $i + 1
	Else
		$new = $i + 1
	EndIf
   GUICtrlCreateListViewItem($IdC[$i]& "|" &$new, $idListview)
Next
$screenshot = GUICtrlCreateButton("CHANGE", 4, 208, 120, 25)
GUICtrlCreateLabel("Author: 0935147435", 15, 234, 120, 20)
$Random10 =  _RandomAlphaNum(30)
$Random5  =  _RandomAlphaNum(20)
$ping 	  =  Ping("www.google.com.vn")
Sleep(1000)
_ProcessSuspend("Wireshark.exe")
_ProcessSuspend("Charles.exe")
If @error Or $ping = 0 Then
	GUISetState($GUI, @SW_HIDE)
	MsgBox(0,"Error","Please connect internet!")
	Exit
Else
	If _GetKey() <> "30a53adfc93996da16ecddc85028af1a" Or _GetKey() = 0 Then
		GUISetState($GUI, @SW_HIDE)
		InputBox("Active key", "Please active key. "& @CRLF & "Contact 0935147435. "& @CRLF & "Your key:", $Random5 & _Base64Encode(_GetMACFromIP()) & $Random10)
		Exit
	Else
		GUISetState(@SW_SHOW)
		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					Exit
				Case $start
					If $position[0] <> "" Or $position[1] <> "" Or $position[2] <> "" Or $position[3] <> "" Then
						_Start()
					Else
						GUISetState(@SW_HIDE,$GUI)
						$position	= GetPosition()
						_Start()
					EndIf
				Case $screenshot
					$aItem = _GUICtrlListView_GetItemTextArray($idListview)
					GUISetState(@SW_HIDE,$GUI)
					_Capture($aItem[2])
					GUISetState(@SW_SHOW,$GUI)
			EndSwitch
			Sleep(10)
		WEnd
	EndIf
EndIf

Func _Start()
	GUICtrlSetData($start, "STARTING...")
	GUICtrlSetState($start, $GUI_DISABLE)
	Local $Result[3],$Result2[3], $imgThumnails2[0], $x, $hTimer = TimerInit(), $fDiff = 0, $iFileExists = 0
	For $i = 1 To 52 Step 1
		If $i < 10 Then
			$x = "0"&$i
		Else
			$x = $i
		EndIf
		$Result  = _IMGSearch_Area(@scriptdir&"\img\thumnails\" & $x &".bmp", $position[0], $position[1], $position[2], $position[3], GUICtrlRead($tolerance))
		If $Result[0] <> 1 Then
			$Result2 = _IMGSearch_Area(@scriptdir&"\img\thumnails2\" & $x &".bmp", $position[0], $position[1], $position[2], $position[3], GUICtrlRead($tolerance2))
			If $Result2[0] <> 1 Then
				_ArrayAdd($imgThumnails2, $x)
			EndIf
		EndIf
	Next

 	If UBound($imgThumnails2) > 13 Then
  		For $i = 0 To UBound($imgThumnails2) - 1
  			If _elementExists($imgThumnails2, $i) Then
				$Result  = _IMGSearch_Area(@scriptdir&"\img\thumnails3\" & $imgThumnails2[$i] &".bmp", $position[0], $position[1], $position[2], $position[3], GUICtrlRead($tolerance))
				If $Result[0] = 1 Then
					_ArrayDelete($imgThumnails2, $i)
				Else
					$Result2 = _IMGSearch_Area(@scriptdir&"\img\thumnails4\" & $imgThumnails2[$i] &".bmp", $position[0], $position[1], $position[2], $position[3], GUICtrlRead($tolerance2))
					If $Result2[0] = 1 Then
						_ArrayDelete($imgThumnails2, $i)
					EndIf
				EndIf
  			EndIf
  		Next
  	EndIf

	If UBound($imgThumnails2) > 13 Then
  		For $i = 0 To UBound($imgThumnails2) - 1
  			If _elementExists($imgThumnails2, $i) Then
				$iFileExists = FileExists(@scriptdir&"\img\thumnails5\" & $imgThumnails2[$i] &".bmp")
				If $iFileExists Then
					$Result = _IMGSearch_Area(@scriptdir&"\img\thumnails5\" & $imgThumnails2[$i] &".bmp", $position[0], $position[1], $position[2], $position[3], GUICtrlRead($tolerance2))
					If $Result[0] = 1 Then
						_ArrayDelete($imgThumnails2, $i)
					EndIf
				EndIf
  			EndIf
  		Next
  	EndIf

	$fDiff = TimerDiff($hTimer)
	GUISetState(@SW_SHOW,$GUI)
	GUICtrlSetData($start, "START")
	GUICtrlSetState($start, $GUI_ENABLE)
	_ShowImg($imgThumnails2, $fDiff)

EndFunc

Func _ShowImg($array, $time)
	Local $w = 10, $nMsgShow
	For $i = 0 To UBound($array) - 1
		$w = $w + 62
	Next
	Local $GUIRESULT = GUICreate("KẾT QUẢ: " & UBound($array) & " CON BÀI, THỜI GIAN: " & Round($time/1000) & " GIÂY.", $w + 10, 110, -1, @DesktopHeight - $height, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
	$w = 10
	For $i = 0 To UBound($array) - 1
		GUICtrlCreatePic(@scriptdir&"\img\full\" & $array[$i] &".jpg", $w, 5, 60, 100)
		$w = $w + 62
	Next
	If $height > @DesktopHeight - 150 Then
		$height = 190
	Else
		$height = $height + 130
	EndIf
	GUISetState(@SW_SHOW,$GUIRESULT)
	Winactivate($GUIRESULT)
	While 1
        $nMsgShow = GUIGetMsg()
        Switch $nMsgShow
			Case $GUI_EVENT_CLOSE
                GUIDelete($GUIRESULT)
                ExitLoop
			Case $start
				_Start()
			Case $screenshot
				$aItem = _GUICtrlListView_GetItemTextArray($idListview)
				GUISetState(@SW_HIDE,$GUI)
				_Capture($aItem[2])
				GUISetState(@SW_SHOW,$GUI)
        EndSwitch
    WEnd
EndFunc

Func _GetMACFromIP($sIP = @IPAddress1, $sSeparator = "")
    Local $MAC, $MACSize
    Local $i, $s, $r, $iIP
    $MAC = DllStructCreate("byte[6]")
    $MACSize = DllStructCreate("int")
    DllStructSetData($MACSize, 1, 6)
    $r = DllCall("Ws2_32.dll", "int", "inet_addr", "str", $sIP)
    $iIP = $r[0]
    $r = DllCall("iphlpapi.dll", "int", "SendARP", "int", $iIP, "int", 0, "ptr", DllStructGetPtr($MAC), "ptr", DllStructGetPtr($MACSize))
    $s = ""
    For $i = 0 To 5
        If $i Then $s = $s & $sSeparator
        $s = $s & Hex(DllStructGetData($MAC, 1, $i + 1), 2)
    Next
    $MAC = 0
    $MACSize = 0
    If $s = "00:00:00:00:00:00" Then Return SetError(1, 0, "")
    Return _Base64Encode($s)
EndFunc

Func _elementExists($array, $element)
    If $element > UBound($array)-1 Then Return False
    Return True
EndFunc

Func _GetKey()
	Local $Mac_address 	= _GetMACFromIP()
	Local $Host 		= "http://autodetect.xyz/"
	Local $ip 			= "166.62.27.191"
	Local $File 		= "server1/f64ccb3c2605785c2b9fe2456a39735b.php?token=" & $Random5 & _Base64Encode($Mac_address) & $Random10 & "&key="&_RandomAlphaNum(74)
	Local $URL 			= $Host & $File
	Local $Result, $domain = "autodetect.xyz"
	TCPStartup()
	OnAutoItExitRegister("OnAutoItExit")
	Local $ipAddress = TCPNameToIP($domain)
	If @error Or $ipAddress <> $ip Then
		Return 0
	Else
		Dim $obj = ObjCreate ("WinHttp.WinHttpRequest.5.1")
		$obj.Open("GET", $URL, false)
		$obj.Send()
		If (@error) Or $obj.Status <> "200" Then
			Return 0
		Else
			$Result = _StringExplode($obj.ResponseText, "|", 0)
			Return $Result[1]
		EndIf
	EndIf
EndFunc

Func OnAutoItExit()
	TCPShutdown()
EndFunc

Func _Base64Encode($input)

    $input = Binary($input)

    Local $struct = DllStructCreate("byte[" & BinaryLen($input) & "]")

    DllStructSetData($struct, 1, $input)

    Local $strc = DllStructCreate("int")

    Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
            "ptr", DllStructGetPtr($struct), _
            "int", DllStructGetSize($struct), _
            "int", 1, _
            "ptr", 0, _
            "ptr", DllStructGetPtr($strc))

    If @error Or Not $a_Call[0] Then
        Return SetError(1, 0, "") ; error calculating the length of the buffer needed
    EndIf

    Local $a = DllStructCreate("char[" & DllStructGetData($strc, 1) & "]")

    $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
            "ptr", DllStructGetPtr($struct), _
            "int", DllStructGetSize($struct), _
            "int", 1, _
            "ptr", DllStructGetPtr($a), _
            "ptr", DllStructGetPtr($strc))

    If @error Or Not $a_Call[0] Then
        Return SetError(2, 0, ""); error encoding
    EndIf

    Return DllStructGetData($a, 1)

EndFunc   ;==>_Base64Encode


Func _Base64Decode($input_string)

    Local $struct = DllStructCreate("int")

    $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
            "str", $input_string, _
            "int", 0, _
            "int", 1, _
            "ptr", 0, _
            "ptr", DllStructGetPtr($struct, 1), _
            "ptr", 0, _
            "ptr", 0)

    If @error Or Not $a_Call[0] Then
        Return SetError(1, 0, "") ; error calculating the length of the buffer needed
    EndIf

    Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")

    $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
            "str", $input_string, _
            "int", 0, _
            "int", 1, _
            "ptr", DllStructGetPtr($a), _
            "ptr", DllStructGetPtr($struct, 1), _
            "ptr", 0, _
            "ptr", 0)

    If @error Or Not $a_Call[0] Then
        Return SetError(2, 0, ""); error decoding
    EndIf

    Return DllStructGetData($a, 1)

EndFunc   ;==>_Base64Decode

Func _RandomAlphaNum($len)
	Dim $OP,$Alpha[27] = ["a", "b", "c", "d", "e", "f", "g", _
					  "h", "i", "j", "k", "l", "m", "n", _
					  "o", "p", "q", "r", "s", "t", "u", _
					  "v", "w", "x", "y", "z"]

	Do
		Switch Random(1,4,1)
			case 1
				$OP &= $Alpha[Random(0,26,1)]
			case 2
				$OP &= StringUpper($Alpha[Random(0,26,1)])
			case 3
				$OP &= Random(0,10,1)
		EndSwitch
	Until StringLen($OP) >= $len
	Return $OP
EndFunc

Func _ProcessSuspend($process)
	$processid = ProcessExists($process)
	If $processid Then
		$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
		$i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		ProcessClose($process)
	Endif
EndFunc