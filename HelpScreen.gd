extends Control

#just to show how to play

func _on_Button_pressed():
	get_parent().get_node("MenuSound").play()
	hide()
	get_parent().get_node("PauseMenu").show()
	get_parent().get_node("PauseMenu/MarginContainer/VBoxContainer/Continue").grab_focus()
