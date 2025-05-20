;
;	Sound Blaster Command Quick Output Switcher
;	Just compile with Aut2Exe v3
;
;	Keys :
;		+ : SHIFT
;		! : ALT
;		^ : CTRL
;		# : Windows
;		{*} : *
;		{}} : }
;
;	More at : https://www.autoitscript.com/autoit3/docs/functions/Send.htm
;


HotKeySet("+!^T", "SwitchOutput") ; CTRL + ALT + SHIFT + t (it's T because SHIFT)

Global $SOUNDBLASTER_WIN_TITLE = "[TITLE:Sound Blaster Command; REGEXPCLASS:HwndWrapper.*]"
Global $RUNNING = True

;no need to import library which use more RAM for 2 globals
Global $WIN_STATE_EXISTS = 1
Global $WIN_STATE_VISIBLE = 2

Opt("WinWaitDelay", 0)
AutoItSetOption("MouseCoordMode", 0)

While $RUNNING
    Sleep(99999)
WEnd

Func SwitchOutput()
	; Save current mouse position
	Local $aOriginalPos = MouseGetPos()
	Local $soundblasterWasVisible = BitAND(WinGetState($SOUNDBLASTER_WIN_TITLE), $WIN_STATE_VISIBLE)
	$saved_win_handle = WinGetHandle("[active]")
	WinSetState($saved_win_handle, "", @SW_MINIMIZE)

	If $soundblasterWasVisible == 0 Then
		Local $hidReady = False

		Run("C:\Program Files (x86)\Creative\Sound Blaster Command\Creative.SBCommand.exe")
		
		While Not $hidReady
			Sleep(100)
			If WinExists($SOUNDBLASTER_WIN_TITLE) And BitAND(WinGetState($SOUNDBLASTER_WIN_TITLE), $WIN_STATE_VISIBLE) Then
				$hidReady = True
			EndIf
		WEnd
	EndIf

	WinActivate($SOUNDBLASTER_WIN_TITLE)
	WinWaitActive($SOUNDBLASTER_WIN_TITLE)
	MouseClick("left", 53, 622, 1, 0)

	If $soundblasterWasVisible == 0 Then
		WinClose($SOUNDBLASTER_WIN_TITLE, "")
	Else
		WinSetState($SOUNDBLASTER_WIN_TITLE, "", @SW_MINIMIZE)
	EndIf

	WinActivate($saved_win_handle)
        ; Restore mouse position
        MouseMove($aOriginalPos[0], $aOriginalPos[1], 0)
EndFunc

Func Terminate()
    $RUNNING = False
EndFunc
