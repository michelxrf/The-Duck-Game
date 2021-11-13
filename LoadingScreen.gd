extends Control
var dot_counter = 0

#this is actually not necessary as the game takes only a few miliseconds to load anything
#but the map transitions were too abrupt so I added this to make it smooth

func _on_Timer_timeout():
	dot_counter += 1
	if dot_counter > 3:
		dot_counter = 0
	
	$Label.text = "Loading" + ".".repeat(dot_counter)
