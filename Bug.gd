extends RigidBody2D

export var REPEL_POWER = 25
export var HUNT_POWER = 15
export var IDLE_POWER = 1
var target = Vector2()
var ai_state = "idle"
export var health = 100
export var damage = 10
var set_new_target_flag = true
var forced_stop_flag = false
var force = Vector2()
var normal_color = Color(1,1,1)
export var dificulty_level = "low"
var hunt_entered = false

#used to change this enemy ai state
func set_ai(state):
	if ai_state !="dead":
		ai_state = state

#initialises its behavior
func _ready():
	set_dificulty(dificulty_level)

#updates its move target
#when idle its randomly set around the map so it just wanders
#when in "hunt" mode it set the target to player location
func new_target():
	if ai_state == "idle" and set_new_target_flag == true:
		var movement_range = $Vision/VisionCollision.shape.radius
		target = global_position + Vector2(rand_range(-movement_range, movement_range), rand_range(-movement_range, movement_range))
		set_new_target_flag = false
		$NewTarget.start()
	elif ai_state == "hunt":
		target = get_node("/root/World/Duck").global_position

#gives the enemy body actual movement and direction using physics
func manage_movement():
	var direction = (target - position).normalized()
	
	match ai_state:
		"idle": force = direction*IDLE_POWER
		"hunt": force = direction*HUNT_POWER
		"dead": force = Vector2()
	
	look_at(target)
	apply_central_impulse(force)

#deifnes its animation based on its state and speed
func manage_animation():
	if ai_state == "dead":
		$AnimatedSprite.animation = "Dying"
	elif linear_velocity.length() > 100:
		$AnimatedSprite.animation = "Moving"
	else:
		$AnimatedSprite.animation = "Idle"

#called by the physics engine every frame
func _physics_process(_delta):
	manage_movement()

#called every frame
func _process(_delta):
	new_target()#update target
	manage_animation()#update animation

#when it dies disable its collision so doesn't block bullet nor other enemies
#initially I liked the idea of the dead body hanging around the map for a few seconds before deleting itslef
#but I had to eliminate that, it was interfering with the gunfight. So now its body just floats into space
func dead():
	collision_layer = 0
	collision_mask = 0
	set_ai("dead")
	$DeadTimer.start()
	

#receives damage when colide with a projectile
func hit(damage_taken):
	if ai_state != "dead":
		$AnimatedSprite.self_modulate = Color(1,.5,.5)
		$DamagedTimer.start()
		health -= damage_taken
		set_ai("hunt")
		if health <= 0:
			dead()


#used to make it redish so its visible when takes damage
func _on_DamagedTimer_timeout():
	$AnimatedSprite.self_modulate = normal_color

#deletes itself after a few seconds
func _on_DeadTimer_timeout():
	queue_free()

#damages the player when colide with it
func _on_BasicBug_body_entered(body):
	if body.is_in_group("player") and ai_state != "dead":
		body.hit(damage)
		apply_central_impulse(-force*REPEL_POWER)
	pass

#allows this enemy to adquire a new target when wandering
func _on_NewTarget_timeout():
	set_new_target_flag = true

#when player enters this "vision" area around the enemy, the enemy enters "hunt" mode, tarqeting the player
func _on_Vision_body_entered(body):
	if body.is_in_group("player") and ai_state != "dead":
		set_ai("hunt")
		if !hunt_entered:
			$AudioStreamPlayer2D.play()
			hunt_entered = true

#sets the level of the enemy, only used for initalisation, does not change afterwards
func set_dificulty(_danger_level:String = "low"):
	dificulty_level = _danger_level
	match _danger_level:
		"dummy":
			$Vision/VisionCollision.shape.radius = 250
			normal_color = Color(1, 1, 1)
			IDLE_POWER = .5
			HUNT_POWER = 5
			damage = 1
			health = 45
		"low":
			$Vision/VisionCollision.shape.radius = 350
			normal_color = Color(1 , 1, 5)
			IDLE_POWER = 1
			HUNT_POWER = 10
			damage = 2
			health = 60
		"high":
			$Vision/VisionCollision.shape.radius = 450
			normal_color = Color(1, 0, 1)
			IDLE_POWER = 2
			HUNT_POWER = 20
			damage = 5
			health = 75
	
	$AnimatedSprite.self_modulate = normal_color

#this is a coll feature. The first model ended up orbitating the player dues its physics based movement
#had to implement that so when the enemy got to a certain distance it would stop, aim at player and throw itlsef at it again
#that ended up making these enemies look more alive in my opinion
func _on_Brake_Zone_body_exited(body):
	if body.is_in_group("player") and ai_state == "hunt":
		apply_central_impulse(Vector2())
		linear_velocity = Vector2(0,0)
