extends Sprite


#just makes the tail point to the correct direction and disapper after a few isntants

func _ready():
	rotation = get_node("../Laser").rotation

func _on_DisapperTimer_timeout():
	queue_free()
