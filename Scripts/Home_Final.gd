extends Node

func _ready():
	$UILayer.announce("Good boy!")

func _on_Mom_body_entered(body):
	if body.is_in_group('player'):
		$UILayer.mother_say("Good boy, now go to sleep")

func _on_Bed_body_entered(body):
	if body.is_in_group('player'):
		$UILayer.announce("Going to sleep...")
		get_tree().paused = true
		
		# TODO: go back to main menu
