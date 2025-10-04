extends "res://scripts/enemies/enemy.gd"

@export var speed: int = 16  # Vitesse du bike
var sprite_size: int = 12  # Taille du sprite du bike (pour le positionnement)

func _ready() -> void:
	add_to_group("bike")

func _physics_process(delta: float) -> void:
	position.x += speed * delta
	if position.x > get_viewport_rect().size.x + sprite_size:  # Si le bike sort de l'écran à droite
		queue_free()  # Le détruit