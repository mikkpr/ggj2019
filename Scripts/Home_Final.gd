extends Node

func _on_Mom_body_entered(body):
	if body.is_in_group('player'):
		print("Good boy, now go to sleep")

func _on_Bed_body_entered(body):
	if body.is_in_group('player'):
		print("Going to sleep")
		get_tree().paused = true
		
		# TODO: go back to main menu
