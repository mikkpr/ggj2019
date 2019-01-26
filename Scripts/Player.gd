extends Node2D

const LIGHT_DISTANCE = 10

onready var light_pivot = $Lightpivot

func _ready():
	pass

func _physics_process(delta):
	var mouse_offset = get_local_mouse_position().normalized() * LIGHT_DISTANCE
	light_pivot.position = mouse_offset