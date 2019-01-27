extends KinematicBody2D

export (float) var aggro_range = 300.0
export (float) var despawn_range = 1000.0
export (float) var approach_speed = 150.0
export (float) var retreat_speed = 200.0

signal induce_fear

var monsters = ["monster1"]
var animation = monsters[randi() % monsters.size()]
var attack_animation = animation + "_attack"

const AMBIENT_SAMPLES = ['koll 3', 'koll 4', 'koll 6']
const ATTACK_SAMPLES = ['koll 2', 'koll 5']
const RETREAT_SAMPLES = ['koll 1']

func play_random_sample(type):
	var samples_arr = null
	if type == 'attack':
		samples_arr = ATTACK_SAMPLES
	elif type == 'retreat':
		samples_arr = RETREAT_SAMPLES
	elif type == 'ambient':
		samples_arr = AMBIENT_SAMPLES
	
	if not samples_arr: return
	
	var rand_nb = randi() % samples_arr.size()
	var audiostream = load('res://Assets/Sounds/' + samples_arr[rand_nb] + '.ogg')
	$Audio.set_stream(audiostream)
	$Audio.playing = true

var aggro = false
var revealed = false
var attacking = false
var target = null # Who are we attacking or retreating from?

func detect(player):
	revealed = true
	target = player

func conceal():
	if randi() % 10:
		play_random_sample('retreat')
	revealed = false

func _ready():
	$AnimatedSprite.animation = animation
	$Aggro/CollisionShape2D.shape.radius = aggro_range
	var bodies = $Aggro.get_overlapping_bodies()
	if len(bodies) > 0:
		_on_Aggro_body_entered(bodies[0])

func _process(delta):
	if attacking:
		return # Wait for animation to end.
	if revealed:
		_move(-retreat_speed * delta)
	elif aggro:
		_move(approach_speed * delta)
	else: # idle
		if randi() % 1000 == 1:
			play_random_sample('ambient')

		if $AnimatedSprite.playing:
			$AnimatedSprite.stop()
		if target:
			var dist = global_position.distance_to(target.global_position)
			if dist > despawn_range:
				queue_free()
				
	

func _move(speed):
	_moving_animation()
	var vec = _vec_to_target() * speed
	$AnimatedSprite.flip_h = vec.x < 0
	if move_and_collide(vec) and speed > 0:
		attacking = true
		$AnimatedSprite.play(attack_animation)
		if randi() % 10:
			play_random_sample('attack')

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
