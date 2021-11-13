extends Area2D

#creates a weapon spawn point
#use method weapon_type(type) to set weapon, if not set it'll be random


var spawned_weapon
export var spawn = "0"
var TOTAL_WEAPONS_IN_GAME = 2

func weapon_type(type:String = "0"):
	if type == "gun" or type == "1":
		spawned_weapon = "gun"
		$Label.text = "Paintball Gun"
		$Sprite.texture = preload("res://Sprites/Weapons/PaintballGun.png")
	elif type == "laser" or type == "2":
		spawned_weapon = "laser"
		$Label.text = "Laser Rifle"
		$Sprite.texture = preload("res://Sprites/Weapons/LaserRifle.png")
	else:
		weapon_type(str(round(rand_range(1,TOTAL_WEAPONS_IN_GAME))))
	

func _ready():
	weapon_type(spawn)


#if the player enters its pickup area, the player gets the weapon
func _on_WeaponSpawn_body_entered(body):
	if body.is_in_group("player"):
		body.weapons_inventory.append(spawned_weapon)
		body.change_weapon(spawned_weapon)
		queue_free()
