extends Node2D




func _ready():
	get_tree().call_group("player", "spawn", $PlayerSpawnPoint.global_position)
