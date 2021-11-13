extends RigidBody2D

export var speed = 500
export var damage = 15

#defines the behavior of the paintball shots
#with initial speed and colision code

func _ready():
	rotation = get_node("../Duck").rotation + get_node("../Duck").bullet_spread
	linear_velocity = Vector2(speed,0)
	linear_velocity = linear_velocity.rotated(rotation)
	get_node("../Duck/GunSound").stream = preload("res://Sounds/Paintball_shot.mp3")
	get_node("../Duck/GunSound").play()
	
func _on_Travel_Timer_timeout():
	queue_free()

#if bullet hits something it'll delete itself and call the hit() method if it hit an enemy
func _on_Generic_Projectile_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(damage)
	queue_free()
