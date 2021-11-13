extends Control

#this gives the player the option to start the level over or go back to main menu

func game_over():
	show()
	$VBoxContainer/Continue.grab_focus()
	$AudioStreamPlayer.play()


func _on_MainMenu_pressed():
	InputMap.load_from_globals()
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Continue_pressed():
	var duck = get_parent().get_parent().get_node("Duck")
	
	#undo gameover effects on the duck
	duck.recover_health(1000)
	duck.game_is_over = false
	duck.get_node("AnimatedSprite").show()
	duck.collision_layer = 1
	duck.collision_mask = 1
	
	#reload map
	get_parent().get_parent().level -= 1
	get_parent().get_parent().next_level()
	hide()
