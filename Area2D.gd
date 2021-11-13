extends Area2D


#Makes the Duck recover health when entered the juice's area
func _on_OrangeJuice_body_entered(body):
	if body.is_in_group("player"):
		
		body.recover_health(50)
		queue_free()
