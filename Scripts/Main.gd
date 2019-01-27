extends Node

export (PackedScene) var monster
export (PackedScene) var home
export (PackedScene) var success
export (PackedScene) var game_over

const INITIAL_FEAR = 0
const MAX_FEAR = 100
const FEAR_INCREMENT = 5
const SPAWN_CHANCE = 5

var fear = INITIAL_FEAR
var goal_reached = false

onready var bar = $UILayer/BraveryBar

onready var player = find_node("Player")

func _ready():
	var test = $UILayer/Announcement
	
	var white = Color(1, 1, 1, 1)
	var pink = Color(1, 0.41, 0.71, 1)

#	_get_announcement_text_node().add_color_override("font_color", white)
#	_get_mother_text_node().add_color_override("font_color", pink)
   
#   announce("")
#   mother_say("")

	randomize()
	self.update_bravery_bar()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("debug_1"):
		self.update_fear(FEAR_INCREMENT)

	if Input.is_action_just_pressed("ui_pause"):
		if fear < MAX_FEAR and not goal_reached:
			toggle_pause_state()

	if player:
		if randi() % 100 < SPAWN_CHANCE:
			var mob = monster.instance()
			add_child(mob)
			mob.target = player
			mob.connect("induce_fear", self, "_on_Monster_induce_fear")
			mob.position = player.position + Vector2(500, 0).rotated(randi())

func update_bravery_bar():
	var bar = find_node('BraveryBar')
	if bar:
		bar.find_node('ProgressBar').value = fear
	
func update_fear(amount):
	fear = clamp(fear + amount, INITIAL_FEAR, MAX_FEAR)

	self.update_bravery_bar()

	if fear >= MAX_FEAR:
		print("You are too afraid to continue")
		_change_scene(game_over)

func toggle_pause_state():
	var paused_state = !get_tree().paused
	get_tree().paused = paused_state
	var home = find_node('Home')
	if home:
		if paused_state:
			home.stop_all_sounds()
		else:
			home.play_all_sounds()

func pause_game():
	get_tree().paused = true


func _on_Monster_induce_fear():
	update_fear(FEAR_INCREMENT)


func _on_Goal_goal_reached():
	print("Trash taken out")
	goal_reached = true

func _on_Home_goal_reached():
	if goal_reached:
		print("Good boy")
		_change_scene(success)
	else:
		print("Get back out there")
		_change_scene(home)

func _change_scene(scene):
	if not scene:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to(scene)

func _get_announcement_text_node():
	return find_node("Announcement")

func _get_mother_text_node():
	return find_node("Mother")
       
func announce(text):
	var label = _get_announcement_text_node()
	label.text = text
	_clear_label_after_seconds(label, 3)

func mother_say(text):
	var label = _get_mother_text_node()
	label.text = text
	_clear_label_after_seconds(label, 3)
       
func _clear_label_after_seconds(label, seconds):
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	label.text = ""
	t.queue_free()
