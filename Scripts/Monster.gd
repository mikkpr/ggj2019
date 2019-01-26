extends KinematicBody2D

export (String) var animation = "placeholder"
var attack_animation = animation + "_attack"

export (float) var aggro_range = 300.0
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
		_retreat(delta)
	elif attacking:
		pass # Wait for animation to end.
	elif aggro:
		_approach(delta)
	elif $AnimatedSprite.playing:
		$AnimatedSprite.stop() # idle

func _approach(delta):
	_moving_animation()
	if move_and_collide(_vec_to_target() * approach_speed * delta):
		attacking = true
		$AnimatedSprite.play(attack_animation)

func _retreat(delta):
	_moving_animation()
	move_and_collide(-_vec_to_target() * retreat_speed * delta)
	# TODO: despawn if out of map.

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
