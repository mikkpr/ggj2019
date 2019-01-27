extends Node

func _on_Mom_body_entered(body):
	if body.is_in_group('player'):
		print("Don't be afraid and try again!")

func _on_SceneChanger_body_entered(body):
	if body.is_in_group('player'):
		get_tree().change_scene('res://Scenes/Ground.tscn')
