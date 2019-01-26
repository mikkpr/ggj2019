extends Area2D

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

func _process(delta):
	if state == AGGRO:
		_approach(delta)
	elif state == ATTACKING:
		_attack(delta)
	else: # REVEALED
		_retreat(delta)

func _approach(delta):
	vec = target.global_position - global_position
	global_position += vec.normalized() * approach_speed * delta

func _attack(delta):
	pass

func _retreat(delta):
	vec = global_position - target.global_position
	global_position += vec.normalized() * retreat_speed * delta

func _on_Aggro_body_entered(body):
	state = AGGRO
	target = body

func _on_Aggro_body_exited(body):
	state = IDLE
	target = null

func _on_Monster_area_entered(area):
	state = REVEALED

func _on_Monster_area_exited(area):
	state = AGGRO

func _on_Monster_body_entered(body):
	state = ATTACKING

func _on_Monster_body_exited(body):
	state = AGGRO
