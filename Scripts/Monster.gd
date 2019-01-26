extends KinematicBody2D

export (String) var animation = "placeholder"
var attack_animation = animation + "_attack"

export (float) var aggro_range = 300.0
export (float) var despawn_range = 1000.0
export (float) var approach_speed = 150.0
export (float) var retreat_speed = 200.0

signal induce_fear

var aggro = false
var revealed = false
var attacking = false
var target = null # Who are we attacking or retreating from?

func detect(player):
	revealed = true
	target = player

func conceal():
	revealed = false

func _ready():
	$AnimatedSprite.animation = animation
	$Aggro/CollisionShape2D.shape.radius = aggro_range
	var bodies = $Aggro.get_overlapping_bodies()
	if len(bodies) > 0:
		_on_Aggro_body_entered(bodies[0])

func _process(delta):
	if revealed:
		attacking = false
		_move(approach_speed * delta)
	elif attacking:
		pass # Wait for animation to end.
	elif aggro:
		_move(-retreat_speed * delta)
	else: # idle
		if $AnimatedSprite.playing:
			$AnimatedSprite.stop()
		if target:
			var dist = global_position.distance_to(target.global_position)
			if dist > despawn_range:
				queue_free()

func _move(speed):
	_moving_animation()
	var vec = _vec_to_target() * speed
	$AnimatedSprite.flip_h = vec.x > 0
	if move_and_collide(vec) and speed > 0:
		attacking = true
		$AnimatedSprite.play(attack_animation)

func _moving_animation():
	if $AnimatedSprite.animation != animation or !$AnimatedSprite.playing:
		$AnimatedSprite.play(animation)

func _on_Aggro_body_entered(body):
	aggro = true
	target = body

func _on_Aggro_body_exited(body):
	aggro = false

func _on_AnimatedSprite_animation_finished():
	if attacking: # Attack animation finished.
		attacking = false
		if test_move(transform, _vec_to_target()):
			emit_signal('induce_fear') # Still in range.

func _vec_to_target():
	return (target.global_position - global_position).normalized()
