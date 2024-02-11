#SingleInstance, force
SetTitleMatchMode, 2 

CoordMode, Mouse, Screen

sec_per_round := 26.8
num_rounds := 510
vstatus := 0

init_progress_gui(){
	global num_rounds
	global sec_per_round
	global vstatus
	delta_time := round(num_rounds * sec_per_round)
	res := A_Now
	FormatTime, now, %A_Now%, Time
	res += delta_time, Seconds
	FormatTime, res, %res%, Time
	
	Gui, Color, DDDDDD
	Gui, -Caption +AlwaysOnTop +Border +Owner +LastFound,

	Gui,Add, Text, x10 y10 w60 Left, Round: 
	Gui,Add, Text, x10 y26 w60 Left, Start Time: 
	Gui,Add, Text, x10 y40 w60 Left, Finish Time: 
	
	Gui,Add, Text, vstatus x80 y10 w60 Left, 0 / %num_rounds%
	Gui,Add, Text, x80 y26 w60 Left, %now%
	Gui,Add, Text, x80 y40 w60 Left, %res%
	
	Gui,Show, x1000 y800 w150 h60,AlwaysOnTop Window 
	WinSet, Transparent, 200, ahk_class AutoHotkeyGUI
}
updateProgress(current_round){
	global num_rounds
	GuiControl,,status, %current_round% / %num_rounds%
}
closeNightlyInstances(){
	MouseClick, left, 1950, 10, , 0
	Sleep 200
}
launchNightly(){
    Run, "C:\Program Files\Firefox Nightly\firefox.exe"h
	WinActivate, ahk_exe firefox.exe
	WinWaitActive, ahk_exe firefox.exe
	return
}
startProfiler(){
	WinActivate, ahk_exe firefox.exe
	WinWaitActive, ahk_exe firefox.exe
	Send ^+1
	return
}
loadURL(url, title){
	clipboard := url
	Send ^l
	Send ^v
	Sleep 20
	Send {Enter}
	Loop
    {	 
        WinGetTitle, currentTitle, A
		if (InStr(currentTitle, title)){
            Sleep 50
			return	
        }
    }
	return
}
stopProfiler(){
	WinActivate, ahk_exe firefox.exe
	WinWaitActive, ahk_exe firefox.exe
	Send ^+2
	return
}
saveProfile(){
	MouseClick, left, 1700, 100, , 0
	Sleep 200
	
	Loop, 3{
		Send {Tab}
		Sleep 20
		Send {Space}
		Sleep 500
	}
	Loop, 3{
		Send {Tab}
		Sleep 50
	}
	Sleep 200
	Send {Enter}
}
experimentalRun(){	
	global num_rounds
	global status
	init_progress_gui()
	Loop, %num_rounds%{
		updateProgress(A_Index)
		launchNightly()
		Sleep 5000
		startProfiler()
		loadURL("http://192.168.0.115:8080/webserver/woff/", "WOFF - No optimizations")
		Sleep 30
		stopProfiler()
		Sleep 3000
		saveProfile()
		Sleep 1500
		closeNightlyInstances()
		Sleep 5000
	}
	MsgBox, Experiment Finished
}

RButton::
	experimentalRun()
	return
