extends RigidBody2D

export var speed = 2500
export var damage = 100
export (PackedScene) var Tail = preload("res://LaserTail.tscn")

#just like the paintball shots
#defines its initial speed and colision code
#the laser also have a particle effect, its tail, it follows the head for visuals
#this had to be done because the laser would disappear all at once when it hits a wall or exit the screen
#this way its tail remains for a few instants

func _ready():
	rotation = get_node("../Duck").rotation + get_node("../Duck").bullet_spread
	linear_velocity = Vector2(speed,0)
	linear_velocity = linear_velocity.rotated(rotation)
	get_node("../Duck/GunSound").stream = load("res://Sounds/Tirinho!-0" + str(round(rand_range(1,4))) + ".mp3")
	get_node("../Duck/GunSound").play()
	
	

func _on_Laser_body_entered(body):
	if body.is_in_group("wall"):
		queue_free()


func _on_SpearHead_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(damage)
	elif body.is_in_group("wall"):
		queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _process(_delta):
	var tail = Tail.instance()
	tail.global_position = global_position
	get_parent().add_child(tail)
