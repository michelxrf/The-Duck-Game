extends Control

var animated_health = 0

#the GUI code, used to show equipped weapon and animate the health bar changes

func update_weapon(weapon):
	match weapon:
		"gun": $HBoxContainer/CurrentWeapon/WeaponSprite.texture = preload("res://Sprites/Weapons/PaintballGun.png")
		"laser": $HBoxContainer/CurrentWeapon/WeaponSprite.texture = preload("res://Sprites/Weapons/LaserRifle.png")

func update_health(new_health):
	$Tween.interpolate_property(self, "animated_health", animated_health, new_health, .25)
	if !$Tween.is_active():
		$Tween.start()

func _process(_delta):
	$HBoxContainer/VBoxContainer/HealthBar.value = animated_health
	$HBoxContainer/VBoxContainer/HealthNumber.text = str(round(animated_health)) + "/100"
