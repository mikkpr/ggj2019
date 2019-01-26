extends KinematicBody2D

const LIGHT_DISTANCE = 10

var speed = 250
var velocity = Vector2()

onready var lightpivot = $Lightpivot
onready var light = $Lightpivot/Light
onready var glow = $Lightpivot/Glow


func _ready():
	for monster in $Lightpivot/Area2D.get_overlapping_bodies():
		_on_Flashlight_body_entered(monster)

func _physics_process(delta):
	var mouse_offset = get_local_mouse_position().normalized() * LIGHT_DISTANCE
	var light_normal = Vector2(1, 0)
	var angle = mouse_offset.dot(light_normal)
	
	lightpivot.look_at(get_global_mouse_position())
	
	get_input()
	move_and_collide(velocity * delta)
	
	var sprite_size = Vector2(32, 32)
	var world_limit_x = 1232
	var world_limit_y = 768
	
	#position.x = clamp(position.x, 0 + sprite_size.x / 2, world_limit_x - sprite_size.x / 2)
	#position.y = clamp(position.y, 0 + sprite_size.y / 2, world_limit_y - sprite_size.y / 2)


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _on_Flashlight_body_entered(body):
	body.detect(self)

func _on_Flashlight_body_exited(body):
	body.conceal()
