extends KinematicBody2D

const LIGHT_DISTANCE = 10

var speed = 250
var velocity = Vector2()

onready var lightpivot = $Lightpivot
onready var light = $Lightpivot/Light
onready var glow = $Lightpivot/Glow


func _physics_process(delta):
    var mouse_offset = get_local_mouse_position().normalized() * LIGHT_DISTANCE
    var light_normal = Vector2(1, 0)
    var angle = mouse_offset.dot(light_normal)
    
    var rotation = lightpivot.position.angle_to_point(mouse_offset) - PI
    lightpivot.rotation = rotation
    glow.rotation = -rotation
    
    get_input()
    move_and_collide(velocity * delta)
    
    var sprite_size = Vector2(32, 32)
    
    position.x = clamp(position.x, $Camera.limit_left + sprite_size.x / 2, $Camera.limit_right - sprite_size.x / 2)
    position.y = clamp(position.y, $Camera.limit_top + sprite_size.y / 2, $Camera.limit_bottom - sprite_size.y / 2)

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
    