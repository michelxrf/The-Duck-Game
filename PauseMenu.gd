extends Control




func _on_Quit_pressed():
	get_parent().get_node("MenuSound").play()
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")

#unpauses the game
func _on_Continue_pressed():
	get_parent().get_node("MenuSound").play()
	get_tree().paused = false
	hide()

#pauses the game and show the pause menu
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel") and !get_parent().get_node("GameOverScreen").visible:
		get_parent().get_node("MenuSound").play()
		if get_tree().paused == false:
			show()
			$MarginContainer/VBoxContainer/Continue.grab_focus()
			get_tree().paused = true
		else:
			get_tree().paused = false
			hide()
			get_parent().get_node("HelpScreen").hide()
	
	#secret map unlock
	elif Input.is_action_just_pressed("ui_select_weapon2") and is_visible_in_tree():
			$MarginContainer/VBoxContainer/Button.show()
			$MarginContainer/VBoxContainer/Label2.show()
			$MarginContainer/VBoxContainer/Label3.show()



func _on_Help_pressed():
	get_parent().get_node("MenuSound").play()
	hide()
	get_parent().get_node("HelpScreen").show()
	get_parent().get_node("HelpScreen/BackButton").grab_focus()

#secret map unlock
func _on_Button_pressed():
	get_parent().get_node("MenuSound").play()
	get_tree().call_group("map", "queue_free")
	get_parent().get_parent().test_map()
