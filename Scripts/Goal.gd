extends StaticBody2D

signal goal_reached

func _ready():
	pass


func _on_Goal_body_entered(body):
	if body.is_in_group('player'):
		emit_signal('goal_reached')
