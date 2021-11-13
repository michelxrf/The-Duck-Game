extends Node2D


func _ready():
	var bgm = get_parent().get_node("BGM")
	get_tree().call_group("player", "spawn", $PlayerSpawnPoint.global_position)
	bgm.stop()
	bgm.stream = preload ("res://Music/Boss.mp3")
	bgm.play()
	
