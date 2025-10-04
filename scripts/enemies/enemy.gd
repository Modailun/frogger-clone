extends Area2D

class_name Enemy

func _ready() -> void:
	add_to_group("enemies")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.died()