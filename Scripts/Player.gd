extends KinematicBody2D

const LIGHT_DISTANCE = 10
const SPEED = 250


onready var lightpivot = $Lightpivot
onready var light = $Lightpivot/Light
onready var glow = $Lightpivot/Glow

enum states {
	STANDING,
	WALKING
}

var state = STANDING
var current_speed = 0

var velocity = Vector2()
var last_move_direction = Vector2(0, 1)

func _ready():
	
	var white = Color(1, 1, 1, 1)
	_get_announcement_text_node().add_color_override("font_color", white)
	_get_mother_text_node().add_color_override("font_color", white)
	
	announce("")
	mother_say("")
	
#	_get_announcement_text_node().get("res://Assets/ARCADECLASSIC").set_size(100)
			
	for monster in $Lightpivot/Area2D.get_overlapping_bodies():
		_on_Flashlight_body_entered(monster)

func _physics_process(delta):
	var mouse_offset = get_local_mouse_position().normalized() * LIGHT_DISTANCE
	var light_normal = Vector2(1, 0)
	var angle = mouse_offset.dot(light_normal)
	
	lightpivot.look_at(get_global_mouse_position())
	
	get_input()
	move_and_slide(velocity)


func get_input():
	if (
		Input.is_action_pressed('ui_right') or 
		Input.is_action_pressed('ui_left') or 
		Input.is_action_pressed('ui_down') or 
		Input.is_action_pressed('ui_up')
	):
		velocity = Vector2()
		if Input.is_action_pressed('ui_right'):
			velocity.x = 1
		if Input.is_action_pressed('ui_left'):
			velocity.x = -1
		if Input.is_action_pressed('ui_down'):
			velocity.y = 1
		if Input.is_action_pressed('ui_up'):
			velocity.y = -1
		_set_state(WALKING)
		last_move_direction = _get_cardinal_direction(velocity.angle())
	else:
		_set_state(STANDING)
	
	velocity = velocity.normalized() * current_speed


func _get_cardinal_direction(angle):
	if ((angle > 0 and angle < PI/4) or (angle <= 0 and angle > -PI/4)):
		return Vector2(1, 0)
	elif (angle >= PI/4 and angle <= 3*PI/4):
		return Vector2(0, 1)
	elif (angle <= -PI/4 and angle >= -3*PI/4):
		return Vector2(0, -1)
	else:
		return Vector2(-1, 0)
#

func _on_Flashlight_body_entered(body):
	body.detect(self)

func _on_Flashlight_body_exited(body):
	body.conceal()

func _set_state(s):
	if s == STANDING:
		current_speed = 0
		var animation = _get_standing_animation()
		$Sprite.stop()
		$Sprite.animation = animation
		if animation == "idle_side":
			$Sprite.flip_h = true if _get_side() == -1 else false
		else:
			$Sprite.flip_h = false
		$Sprite.frame = 0

	if state == s:
		return

	state = s
	
	if state == WALKING:
		current_speed = SPEED
		$Sprite.play(_get_walking_animation())
		
func _get_standing_animation():
	print("standing")
	var mouse_angle = get_local_mouse_position().normalized().angle()	
	var mouse_direction = _get_cardinal_direction(mouse_angle)
	print(last_move_direction, mouse_direction)

	if (mouse_direction == Vector2(0, 1)):
		return "idle_front"
	elif (mouse_direction == Vector2(0, -1)):
		return "idle_back"
	elif (mouse_direction == Vector2(1, 0) or mouse_direction == Vector2(-1, 0)):
		return "idle_side"
		
func _get_side():
	var mouse_angle = get_local_mouse_position().normalized().angle()	
	var mouse_direction = _get_cardinal_direction(mouse_angle)
	if (mouse_direction == Vector2(1, 0)):
		return 1
	else:
		return -1

func _get_walking_animation():
	var mouse_angle = get_local_mouse_position().normalized().angle()	
	var mouse_direction = _get_cardinal_direction(mouse_angle)
	print("mouse direction: %s" % [mouse_direction])
	if (mouse_direction == Vector2(0, 1)):
		return "walk_front"
	elif (mouse_direction == Vector2(0, -1)):
		return "walk_back"
	elif (mouse_direction == Vector2(1, 0) or mouse_direction == Vector2(-1, 0)):
		return "walk_side"

func _get_announcement_text_node():
	return get_node("Announcement")

func _get_mother_text_node():
	return get_node("Mother")
	
func announce(text):
	var label = _get_announcement_text_node()
	label.text = text

func mother_say(text):
	var label = _get_mother_text_node()
	label.text = text	


