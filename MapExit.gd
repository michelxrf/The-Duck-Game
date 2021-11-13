extends Area2D

#call the world to change the current map once the player reaches its endpoint

func _on_MapExit_body_entered(body):
	if body.is_in_group("player"):
		get_parent().get_parent().next_level()
