extends RigidBody2D

export (PackedScene) var Mob 
var ai_state = "idle"
export var health = 400
export var spawn_timer_dificulty = 1
var torque = 0
export var MAX_TORQUE = 500
export var MIN_TORQUE = 100
export var spawned_dificulty = "low"
var this_spawner_id
var children_max = 2

export var extra_bugs = false
var normal_color = Color(1,1,1)

func _ready():
	#it tracks who are its children, this was needed to limit the amount of spwaned enemies
	#also used to add a feature winch makes all of its spawns die when the spawner dies
	#also used to make the spawns protect its mother in case it get damaged or touched by the player
	this_spawner_id = "mother" + str(get_instance_id())
	Mob = preload("res://BasicBug.tscn")
	
	#these lines are used to define its spin direction, just to give them some movement variety
	var positive_or_negative = round(rand_range(0,1))
	if positive_or_negative == 0:
		positive_or_negative = -1
	torque = rand_range(MIN_TORQUE, MAX_TORQUE)*positive_or_negative
	
	#these are used to desync all the spawner on map so they don't start spawning in sync
	$ChangeStateTimer.wait_time = rand_range(1, 5)
	$ChangeStateTimer.start()
	set_dificulty(spawned_dificulty)

#receives damage when shot
func hit(damage_taken):
	if ai_state != "dead" and ai_state != "cooldown":
		$DamagedTimer.start()
		$AnimatedSprite.self_modulate = Color(1,.5,.5)
		health -= damage_taken
		
		#call its children for protection
		get_tree().call_group(this_spawner_id, "set_ai", "hunt")
		
		if health <= 0:
			dead()
		

#keeps this enemy spinning
func _physics_process(_delta):
	if angular_velocity < 10:
		apply_torque_impulse(torque)

#dies, simply goes invisible and deletes itself
func dead():
	collision_layer = 0
	collision_mask = 0
	$AnimatedSprite.animation = "Spawn"
	ai_state = "dead"
	get_tree().call_group(this_spawner_id, "dead")
	$DeadTimer.start()
	$AudioStreamPlayer2D.play()


func _on_DeadTimer_timeout():
	queue_free()

#this is used for dificulty variety, some of its dificulty levels spawn 4 enemies at once instead of 1
func set_extra_spawns(enable:bool = false):
	if enable == true:
		extra_bugs = true
	else:
		extra_bugs = false
	

#this is the most important part of this enemy code. It works like a state machine
#transitioning between states depending on a few conditions: time and children population
func next_ai_state():
	match ai_state:
		"idle": 
			ai_state = "spawning"
			$ChangeStateTimer.wait_time = 1/spawn_timer_dificulty
			$ChangeStateTimer.start()
			$AnimatedSprite.animation = "Spawn"
			$AnimatedSprite.frame = 0
			$AnimatedSprite.play()
		"spawning": 
			ai_state = "cooldown"
			hide()
			spawn_enemy()
			$ChangeStateTimer.wait_time = 3/spawn_timer_dificulty
			$ChangeStateTimer.start()
			collision_mask = 0
			collision_layer = 0
		"cooldown": 
			var children_pop = get_parent().get_tree().get_nodes_in_group(this_spawner_id).size()
			if children_pop < children_max:
				ai_state = "comingback"
				show()
				$ChangeStateTimer.wait_time = 1/spawn_timer_dificulty
				$ChangeStateTimer.start()
				$AnimatedSprite.animation = "ComeBack"
				$AnimatedSprite.frame = 0
				$AnimatedSprite.play()
				collision_mask = 1
				collision_layer = 1
			else:
				$ChangeStateTimer.wait_time = 1/spawn_timer_dificulty
				$ChangeStateTimer.start()
		"comingback": 
			ai_state = "idle"
			$ChangeStateTimer.wait_time = 2/spawn_timer_dificulty
			$ChangeStateTimer.start()
			$AnimatedSprite.animation = "Idle"

#when it leaves one of its states it spawns a batch of enemies
#number and dificulty of the spawned depends on its own dificulty level
func spawn_enemy():
	if !extra_bugs:
		var enemy = Mob.instance()
		enemy.add_to_group(this_spawner_id)
		get_parent().add_child(enemy)
		enemy.transform = global_transform
		enemy.set_dificulty(spawned_dificulty)
	else:
		for i in range(4):
			var enemy = Mob.instance()
			enemy.add_to_group(this_spawner_id)
			get_parent().add_child(enemy)
			enemy.transform = get_node("ExtraSpawnPoint" + str(i)).global_transform
			enemy.set_dificulty(spawned_dificulty)



func _on_DamagedTimer_timeout():
	$AnimatedSprite.self_modulate = normal_color

#used in the timer that make it change the state
func _on_ChangeStateTimer_timeout():
	if ai_state != "dead":
		next_ai_state()

#configures its stats for each dificuly level
func set_dificulty(_danger_level:String = "low"):
	spawned_dificulty = _danger_level
	match _danger_level:
		"low":
			normal_color = Color(1, 1, 1)
			extra_bugs = false
			spawn_timer_dificulty = 1
			spawned_dificulty = "low"
			children_max = 2
		"medium":
			normal_color = Color(1 , 1, 2)
			extra_bugs = false
			spawn_timer_dificulty = 2
			spawned_dificulty = "low"
			children_max = 4
		"high":
			normal_color = Color(.5, .5, 5)
			extra_bugs = true
			spawn_timer_dificulty = 1
			spawned_dificulty = "low"
			children_max = 4
		"extreme":
			normal_color = Color(1, 0, 1)
			extra_bugs = true
			spawn_timer_dificulty = 1
			spawned_dificulty = "high"
			children_max = 2
	
	#it has a diferent color for each dificuly level
	$AnimatedSprite.self_modulate = normal_color

#if the player tries to push this enemy around the map, its children will come to aid
func _on_BugSpawner_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group(this_spawner_id, "set_ai", "hunt")
