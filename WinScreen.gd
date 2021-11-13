extends Control

func _ready():
	$MainMenu.grab_focus()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
