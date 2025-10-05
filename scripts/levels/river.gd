extends Area2D

func _ready() -> void:
	add_to_group("river")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.died()
