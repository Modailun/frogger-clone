extends Area2D

class_name SafeZone

func _ready() -> void:
	add_to_group("safe_zone")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not body.is_in_group("safe_zone"):
		body.add_to_group("safe_zone")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body.is_in_group("safe_zone"):
		body.remove_from_group("safe_zone")