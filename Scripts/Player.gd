extends KinematicBody2D

const LIGHT_DISTANCE = 10

var speed = 250
var velocity = Vector2()

onready var light_pivot = $Lightpivot
onready var light = $Lightpivot/Light

func _physics_process(delta):
    var mouse_offset = get_local_mouse_position().normalized() * LIGHT_DISTANCE
    var light_normal = Vector2(1, 0)
    var angle = mouse_offset.dot(light_normal)
    light.rotation = light.position.angle_to_point(mouse_offset) - PI
    
    get_input()
    move_and_collide(velocity * delta)

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
    