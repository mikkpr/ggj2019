extends Area2D

signal goal_reached

func _on_Goal_body_entered(body):
	if body.is_in_group('player'):
		$Audio.playing = true
		emit_signal('goal_reached')
