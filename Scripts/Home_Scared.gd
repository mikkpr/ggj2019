extends Node

func _on_Mom_body_entered(body):
	if body.is_in_group('player'):
		$UILayer.mother_say("Don't be afraid and try again! The trash can should be just straight down from the door.")

func _on_SceneChanger_body_entered(body):
	if body.is_in_group('player'):
		get_tree().change_scene('res://Scenes/Ground.tscn')
