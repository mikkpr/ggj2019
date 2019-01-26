extends Node

const INITIAL_FEAR = 0
const MAX_FEAR = 100
const FEAR_INCREMENT = 5

var fear = INITIAL_FEAR
var goal_reached = false

onready var bar = $UILayer/BraveryBar

func _ready():
	self.update_bravery_bar()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("debug_1"):
		self.update_fear(FEAR_INCREMENT)

	if Input.is_action_just_pressed("ui_pause"):
		if fear < MAX_FEAR or not goal_reached:
			get_tree().paused = !get_tree().paused

func update_bravery_bar():
	var bar = $Node/UILayer/BraveryBar/Container/ProgressBar
	if bar:
		bar.value = fear
	
func update_fear(amount):
	fear = clamp(fear + amount, INITIAL_FEAR, MAX_FEAR)

	self.update_bravery_bar()

	if fear >= MAX_FEAR:
		print("You are too afraid to continue")
		pause_game()

func pause_game():
	get_tree().paused = true


func _on_Monster_induce_fear():
	update_fear(FEAR_INCREMENT)


func _on_Goal_goal_reached():
	goal_reached = true
	pause_game()
	print("Hooray! You did it!")
