extends KinematicBody2D

export (float) var aggro_range = 100.0
export (float) var approach_speed = 1.0
export (float) var retreat_speed = 1.0

enum states {
	IDLE,
	AGGRO,
	ATTACKING, # Monster has reached the target.
	REVEALED
}
var state = IDLE
var target = null # Who are we attacking?

func _ready():
	$Aggro/CollisionShape2D.shape.radius = aggro_range
	bodies = $Aggro.get_overlapping_bodies()
	if len(bodies) > 0:
		_on_Aggro_body_entered(bodies[0])

func _process(delta):
	if state == AGGRO:
		_approach(delta)
	elif state == ATTACKING:
		_attack(delta)
	elif state == REVEALED:
		_retreat(delta)

func _approach(delta):
	var vec = target.global_position - global_position
	if move_and_collide(vec.normalized() * approach_speed * delta):
		state = ATTACKING

func _attack(delta):
	pass

func _retreat(delta):
	var vec = global_position - target.global_position
	move_and_collide(vec.normalized() * retreat_speed * delta)

func _on_Aggro_body_entered(body):
	state = AGGRO
	target = body

func _on_Aggro_body_exited(body):
	state = IDLE
	target = null
