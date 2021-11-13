extends Node

export (PackedScene) var Map
export var level = 0

#this node is maybe the game's heart, it holds everything together during the game
#spawns maps, player, GUI, menus and music
#the enemies are spwaned by the maps when they are called though

func _ready():
	randomize()#initialises the random numbers used in game
	next_level()
	next_song()

#this instances new maps to the scene and deletes the previous one
#also spawns the loading screen
func next_level():
	$CanvasLayer/LoadingScreen.show()
	$CanvasLayer/PauseMenu.pause_mode = Node.PAUSE_MODE_STOP
	get_tree().paused = true
	$Duck.hide()
	$CanvasLayer/GUI.hide()
	get_tree().call_group("map","hide")
	
	level += 1
	
	if level < 9:
		yield(get_tree().create_timer(.2), "timeout")
		get_tree().call_group("map","queue_free")
		
		Map = load("res://Map" + str(level) + ".tscn")
		var map = Map.instance()
		add_child(map)
		yield(get_tree().create_timer(.3), "timeout")#
		get_tree().paused = false
		$CanvasLayer/LoadingScreen.hide()
		$Duck.show()
		$CanvasLayer/GUI.show()
		get_tree().call_group("map","show")
	else:
		yield(get_tree().create_timer(.5), "timeout")
		get_tree().change_scene("res://WinScreen.tscn")
	
	$CanvasLayer/PauseMenu.pause_mode = Node.PAUSE_MODE_PROCESS
	

func test_map():
		Map = preload("res://TestMap.tscn")
		var map = Map.instance()
		add_child(map)

func next_song():
	if level < 8:
		$BGM.stream = load("res://Music/bgm" + str(round(rand_range(1,4))) + ".mp3")
		$BGM.play()


func _on_BGM_finished():
	next_song()

func _input(event):
	#change prefered controls between mouse and joypad
	if event is InputEventMouse or event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
