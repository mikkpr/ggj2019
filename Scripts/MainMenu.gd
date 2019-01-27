extends Node

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Home_Start.tscn")

func _on_Exit_pressed():
	get_tree().quit()
