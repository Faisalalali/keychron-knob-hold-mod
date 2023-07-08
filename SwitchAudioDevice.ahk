#Persistent ; keep this script running until the user explicitly exits it
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.

SetBatchLines -1 ; run at max speed

holdDuration := 500 ; milliseconds

; Script logic
muteKeyDown := false ; whether the mute key is currently held down

global holdDownBehavior := false

$Volume_Mute::
  SetTimer, CheckHeldDown, % holdDuration ; run CheckHeldDown after holdDuration milliseconds
  FileAppend, Volume_Mute is pressed, *
return

$Volume_Mute Up::
  SetTimer, CheckHeldDown, Off ; turn off the timer
  if (!muteKeyDown) {
    if (!holdDownBehavior){
      Send {Volume_Mute} ; simulate a key press to toggle the mute state
    } else {
      EndVoiceControl()
    }
  }
  muteKeyDown := false
return

CheckHeldDown:
  StartVoiceControl()
  muteKeyDown := true
return

; Logic after holding down
StartVoiceControl() {
  holdDownBehavior := true
  Send, #^{v}
}

EndVoiceControl() {
  holdDownBehavior := false
  Send, {Enter}
  Send, {Esc}
}

$Volume_Up::
  FileAppend, holdDownBehavior is %holdDownBehavior%, *
  if (holdDownBehavior) {
    Send {Down}
  } else {
    Send {Volume_Up}
  }
return

$Volume_Down Up::
  FileAppend, holdDownBehavior is %holdDownBehavior%, *
  if (holdDownBehavior) {
    Send {Up}
  } else {
    Send {Volume_Down}
  }
return
