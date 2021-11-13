extends RigidBody2D


var forced_scale = 1
export var speed = 350
export var damage = 5

#the code that define the defensive weapon behavior

#this is not the best way to do this, its not a good idea to overide the scale of rigid bodies
#it can make the physics engine go bananas according to the engine's docs
#but I couldn't find another way to do this correctly
#so it stayed and didn't give any crash nor bug yet
func _process(_delta):
	forced_scale += .1
	scale.y = forced_scale

func _ready():
	rotation = get_node("../Duck").rotation
	linear_velocity = Vector2(speed,0)
	linear_velocity = linear_velocity.rotated(rotation)
	get_node("../Duck/GunSound").stream = load("res://Sounds/Duck-0" + str(round(rand_range(1,2))) + ".mp3")
	get_node("../Duck/GunSound").play()
	
func _on_Travel_Timer_timeout():
	queue_free()

func _on_PunchWave_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(damage)

