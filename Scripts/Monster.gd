extends KinematicBody2D

export (String) var animation = "placeholder"

export (float) var aggro_range = 300.0
export (float) var approach_speed = 150.0
export (float) var retreat_speed = 200.0

enum states {
	IDLE,
	AGGRO,
	ATTACKING, # Monster has reached the target.
	REVEALED
}
var state = IDLE
var target = null # Who are we attacking?

signal induce_fear

func _ready():
	_set_state(IDLE)
	$Aggro/CollisionShape2D.shape.radius = aggro_range
	var bodies = $Aggro.get_overlapping_bodies()
	if len(bodies) > 0:
		_on_Aggro_body_entered(bodies[0])

func _process(delta):
	if state == AGGRO:
		_approach(delta)
	elif state == REVEALED:
		_retreat(delta)

func _approach(delta):
	var vec = target.global_position - global_position
	if move_and_collide(vec.normalized() * approach_speed * delta):
		_set_state(ATTACKING)

func _retreat(delta):
	var vec = global_position - target.global_position
	move_and_collide(vec.normalized() * retreat_speed * delta)

func _on_Aggro_body_entered(body):
	target = body
	_set_state(AGGRO)

func _on_Aggro_body_exited(body):
	target = null
	_set_state(IDLE)

func _on_AnimatedSprite_animation_finished():
	if state == ATTACKING:
		emit_signal('induce_fear')
		_set_state(AGGRO)

func _set_state(s):
	if state == s:
		return
	state = s
	if state == IDLE:
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = animation
		$AnimatedSprite.frame = 0
	elif state == AGGRO:
		$AnimatedSprite.play(animation)
	elif state == ATTACKING:
		$AnimatedSprite.play(animation + "_attack")