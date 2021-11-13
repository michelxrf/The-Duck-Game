extends Control

#this piece of code its just to link the owners of all the asset I've used that weren't made by myself
#they're all CC0
#probably could have made this in a smarter way, hardcoding each link took a lot of time

func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer3/Button.grab_focus()

func _on_Font1_pressed():
	OS.shell_open("https://www.fontspace.com/random-boys-font-f52152")


func _on_Font2_pressed():
	OS.shell_open("https://www.fontspace.com/legendum-font-f8002")


func _on_Music1_pressed():
	OS.shell_open("https://freesound.org/people/deleted_user_4397472/")


func _on_Music2_pressed():
	OS.shell_open("https://freesound.org/people/Doctor_Dreamchip/")


func _on_Music3_pressed():
	OS.shell_open("https://freesound.org/people/levelclearer/")


func _on_Sound1_pressed():
	OS.shell_open("https://freesound.org/people/NenadSimic/")


func _on_Sound2_pressed():
	OS.shell_open("https://freesound.org/people/Atlas72/")


func _on_Sound3_pressed():
	OS.shell_open("https://freesound.org/people/deleted_user_2104797/")	


func _on_Sound4_pressed():
	OS.shell_open("https://freesound.org/people/Clusman/")


func _on_Sound5_pressed():
	OS.shell_open("https://freesound.org/people/thisusernameis/")


func _on_Sound6_pressed():
	OS.shell_open("https://freesound.org/people/TolerableDruid6/")


func _on_Sound7_pressed():
	OS.shell_open("https://freesound.org/people/AugustSandberg/")


func _on_Sound8_pressed():
	OS.shell_open("https://freesound.org/people/webmatex/")


func _on_Sound9_pressed():
	OS.shell_open("https://freesound.org/people/SamsterBirdies/")


func _on_Sound10_pressed():
	OS.shell_open("https://freesound.org/people/themusicalnomad/")


func _on_Sound11_pressed():
	OS.shell_open("https://freesound.org/people/plasterbrain/")


func _on_Sound12_pressed():
	OS.shell_open("https://freesound.org/people/yunikon/")


func _on_Sound13_pressed():
	OS.shell_open("https://freesound.org/people/qubodup/")


func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
