extends MarginContainer

#kickstart the game, and gives options to look for more about my game
#and also to look at the credits


func _on_StartGame_pressed():
	$MenuSound.play()
	get_tree().change_scene("res://World.tscn")
	


func _on_Quit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _process(delta):
	$HBoxContainer/VBoxContainer2/Logo.rotation += PI/512

func _input(event):
	#change prefered controls between mouse and joypad
	if event is InputEventMouse or event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _ready():
	$HBoxContainer/VBoxContainer/Options/StartGame.grab_focus()


func _on_Credits_pressed():
	get_tree().change_scene("res://Credits.tscn")
