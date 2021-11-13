extends RigidBody2D

var ai_state = "idle"
export (PackedScene) var Small_Enemy
export var damage = 50
var health = 100
var max_health = 750
var is_dead = false
var spin_speed = .9
var hard_spawn_ticket = 1
var next_ticket_health
var ticket_step

#makes the boss rotate
func manage_movement():
	if !is_dead:
		angular_damp = 1
		angular_velocity = spin_speed
	else:
		angular_damp = 2

#define some of its starting conditions
func _ready():
	health = max_health
	ticket_step = round(max_health/3)
	next_ticket_health = max_health - ticket_step

#spawn enemies
func spawn(type):
	$Spawn.play()#sound effect
	match type:
		"big":#once it loses some amount of health it'll spawn some hard enemies
			if get_tree().get_nodes_in_group("boss_big_baby").size() < 4:#makes sure the player doesn't get overwhelmed by too many mobs
				for i in range(4):#spawn 4
					var enemy = Small_Enemy.instance()
					enemy.add_to_group("boss_big_baby")
					enemy.dificulty_level = "high"
					enemy.set_ai("hunt")#put the spawned enemies in hunt mode, they attack the player
					get_parent().add_child(enemy)
					enemy.transform = get_node("SpawnPoint" + str(i)).global_transform
		"small":#by defined intervals it'll spawn medium dificulty enemies
			if get_tree().get_nodes_in_group("boss_small_baby").size() < 5:#makes sure the player doesn't get overwhelmed by too many mobs
					for i in range(4):
						var enemy = Small_Enemy.instance()
						enemy.add_to_group("boss_small_baby")
						enemy.set_ai("hunt")#put the spawned enemies in hunt mode, they attack the player
						get_parent().add_child(enemy)
						enemy.transform = get_node("SpawnPoint" + str(i)).global_transform

#damages the player if in touched by it
func _on_Boss_body_entered(body):
	if body.is_in_group("player"):
		body.hit(damage)

#receives damage if it's face get shot
func hit(damage_taken):
	if !is_dead:
		health -= damage_taken
		
		#make it red to sinalize the taken damage
		$Sprite.self_modulate = Color(1, 0.5, 0.5)
		$DamagedTimer.start()
		
		
		
		if !$Pain.playing:
			$Pain.play()#play sound
		
		#dies when health get too low
		if health < 0:
			dead()
		
		#make it possible to spawn the hard enemies
		#it's calculated bassed on the boss health
		if health < next_ticket_health:
			next_ticket_health -= ticket_step
			hard_spawn_ticket +=1
			spin_speed += .2
			$AttackTimer.wait_time = 0.9*$AttackTimer.wait_time
			
		
		#spawns the enemies if reached the damage taken milestone
		if hard_spawn_ticket > 0:
			hard_spawn_ticket -= 1
			spawn("big")


func _on_DamagedTimer_timeout():
	$Sprite.self_modulate = Color(1, 1, 1)

#changes it's conditions so it stops fighting and start dying
func dead():
	is_dead = true
	$Sprite.animation = "Dying"
	$DieTimer.start()
	get_parent().get_node("InvisibleWall").queue_free()#unlocks the level exit
	$Dead.play()#play animation

#deletes itself after dead
func _on_DieTimer_timeout():
	queue_free()

func _physics_process(_delta):
	manage_movement()

#manages the area where the player needs to hit
func _on_Face_body_entered(body):
	if body.is_in_group("projectile"):
		hit(body.damage)

#spawns enemies around every 15 secs, but this varies as the boss takes damage it start spawning more frequently
func _on_AttackTimer_timeout():
	spawn("small")

#plays a intimidating roar at the start of the fight
func _on_RoarTimer_timeout():
	$Roar.play()
