extends Area2D

func _ready() -> void:
	add_to_group("river")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_to_group("river")
		print("Entered river")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.remove_from_group("river")
		print("Exited river")
