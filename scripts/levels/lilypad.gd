extends CharacterBody2D

var vel = Vector2.ZERO

func _ready() -> void:
	add_to_group("lilypad")
	add_to_group("active")