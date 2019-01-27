extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#find_node("ScrollText").text = "asdf " \
	#+ "asdf!"

	_get_label().bbcode_text = "[center] THE END\n\nCongratulations! \nYou  returned home safely\n\n\nMade by:\nLeene\nMikk\nKarl\nTiit\nAare[/center]"
		
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
func _get_label():
	return find_node("RichTextLabel")