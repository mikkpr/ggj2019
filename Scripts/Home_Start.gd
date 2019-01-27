extends Node

var mom_dialog_seen = false

func _on_Mom_body_entered(body):
	if body.is_in_group('player'):
		if mom_dialog_seen:
			print('I told you, please take out the trash!')
		else:
			mom_dialog_seen = true
			print('Please be a good boy and take out the trash')
			$Door/CollisionShape2D.disabled = true


func _on_SceneChanger_body_entered(body):
	if body.is_in_group('player'):
		get_tree().change_scene('res://Scenes/Ground.tscn')
