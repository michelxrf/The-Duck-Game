extends Node2D

#this actually have some light effects I was testing to implement
#but decided not to put in the game as it didn't match the mood
#but I left it at this secret map just for fun sake


func _ready():
	get_tree().call_group("player", "spawn", $PlayerSpawnPoint.global_position)
	get_parent().get_node("Duck/Light2D").show()
	$CanvasModulate.show()
