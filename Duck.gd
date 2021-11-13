extends KinematicBody2D


var bullet_spread
export var health = 100
export var speed = 250
var velocity = Vector2()
var switching = false
var controller_mode
var projectile_randomness_angle
var joy_look_position
var weapons_inventory = []
var equipped_weapon = "0"
var game_is_over = false

export (PackedScene) var Projectile
export (PackedScene) var Shield = preload("res://PunchWave.tscn")

#used to change the player attack types with key strokes or when a new weapon get picked up
func change_weapon(type:String = "0"):
	
	match type:
		"0": type = "0"
		"1": type = "gun"
		"2": type = "laser"
	
	if type in weapons_inventory:
		if equipped_weapon != type:
			match type:
				"gun":
					Projectile = preload("res://Generic_Projectile.tscn")
					$FireRateTimer.wait_time = .10
					projectile_randomness_angle = PI/64
				"laser":
					Projectile = preload("res://Laser.tscn")
					$FireRateTimer.wait_time = 1
					projectile_randomness_angle = 0
			
			equipped_weapon = type
			switching_weapon()#plays an animation to make it clear to the player that the weapon is being changed and can't be used
			get_tree().call_group("gui", "update_weapon", type)

#used for the player defensive ability, winch can push enemies away, but causes very litle damage to them
func defend():
	if $ShieldRateTimer.is_stopped():
			$ShieldRateTimer.start()
			var shield = Shield.instance()
			owner.add_child(shield)
			shield.transform = $Muzzle.global_transform

#manages all attacks
#it reads the attack buttons and call the proper action
func manage_attacks():
	if !game_is_over:
		if Input.is_action_pressed("ui_attack"):
			shoot()
		elif Input.is_action_pressed("ui_defend"):
			defend()


#tells the weapon to shoot, not shoot if it's changing
#this is done by instancing the projectiles of each weapon
func shoot():
	if !switching and len(weapons_inventory) > 0:
		if $FireRateTimer.is_stopped():
			bullet_spread = rand_range(-projectile_randomness_angle, projectile_randomness_angle)
			$FireRateTimer.start()
			var projectile = Projectile.instance()
			owner.add_child(projectile)
			projectile.transform = $Muzzle.global_transform

#Manages the input events with the Input Map used to move the duck around
func manage_movement():
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1
	else:
		velocity.x = 0

#for some reason up is actualy -y in this engine, positive y = up for me would make more sense
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1
	else:
		velocity.y = 0

#velocity needs to be normalized so diagonal speed isn't greater than orthogonal
	velocity = velocity.normalized()

#this lines does the acutal moving by updating the Duck's position
	if !game_is_over:
		velocity = move_and_slide(velocity*speed)
	
	#decides winch animation to play based on duck's speed
	if !velocity:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
	else:
		$AnimatedSprite.play()

#make the duck look at the mouse or at joypad direction
func manage_direction():
	#the if works to hide the cursor if player start using the joystick
	if controller_mode == "mouse":
		var mouse_position = get_global_mouse_position()
		look_at(mouse_position)
	if controller_mode == "joypad":
		look_at(position + joy_look_position)

#most of whats here is actually outdated
func _ready():
	game_is_over = false
	get_tree().call_group("gui", "update_health", health)#initializes the GUI's health bar
	change_weapon()#initilizes the weapon inventory
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	manage_attacks()
	$Speech/SpeechBubble.global_rotation = 0
	#health = 100 #God Mode

#updates direciton and movement each frame
func _physics_process(_delta):
	manage_direction()
	manage_movement()


func _input(event):
	#change prefered controls between mouse and joypad
	if event is InputEventMouse or event is InputEventMouseButton:
		controller_mode = "mouse"
		get_tree().call_group("tutorial_mouse","show")
		get_tree().call_group("tutorial_joypad","hide")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		controller_mode = "joypad"
		get_tree().call_group("tutorial_joypad","show")
		get_tree().call_group("tutorial_mouse","hide")
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		joy_look_position = Vector2(Input.get_action_strength("joy_look_right") - Input.get_action_strength("joy_look_left"), Input.get_action_strength("joy_look_down") - Input.get_action_strength("joy_look_up"))
	
	#change weapons
	if !game_is_over:
		if Input.is_action_just_pressed("ui_select_weapon1"):
			change_weapon("1")
		if Input.is_action_just_pressed("ui_select_weapon2"):
			change_weapon("2")

#takes damage when coliding with enemies
func hit(damage_taken):
	$AnimatedSprite.self_modulate = Color(1, 0.5, 0.5)
	$DamagedTimer.start()
	
	health -= damage_taken
	
	$HurtSound.stream = load ("res://Sounds/player_hit-0" + str(round(rand_range(1,3))) + ".mp3")
	$HurtSound.play()
	
	get_tree().call_group("gui", "update_health", health)
	
	if health <= 0:
		game_over()

#disables its visibility, and enemies stop trying to kill
#show game over screen
func game_over():
	game_is_over = true
	$AnimatedSprite.hide()
	collision_layer = 0
	collision_mask = 0
	get_tree().call_group("enemy", "set_ai", "idle")
	get_tree().call_group("gui", "game_over")
	

#its a visual effect so the player knows the weapon is being switched and can't be used
func switching_weapon():
	$GunSound.stream = preload("res://Sounds/Reload.mp3")
	$GunSound.play()
	switching = true
	$Speech.show()
	$SwitchWeaponTimer.start()

#makes the weapon usable again
func _on_SwitchWeaponTimer_timeout():
	switching = false
	$Speech.hide()


func _on_DamagedTimer_timeout():
	$AnimatedSprite.self_modulate = Color(1, 1, 1)

#used for map transitions to set the player at the level entry point
func spawn(spawnpoint):
	global_position = spawnpoint

#used when picking up health potions
func recover_health(amount):
	health += amount
	
	if health>100:
		health=100
	
	$OrangeJuiceSound.play()
	get_tree().call_group("gui", "update_health", health)
