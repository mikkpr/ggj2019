extends Node2D

onready var bar = $Container/ProgressBar

func update_value(amount):
    bar.value = amount
