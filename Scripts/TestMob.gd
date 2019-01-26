extends KinematicBody2D

const MOTION_SPEED = 300 # Pixels/second

func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)
		
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)
	
	print("X: " + str(position.x) + "; Y: " + str(position.y))
	
	if position.x > 655:
		position.x = -635
	if position.x < -635:
		position.x = 655
	if position.y > 380:
		position.y = -460
	if position.y < -460:
		position.y = 380
	

	
