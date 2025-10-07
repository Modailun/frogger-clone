extends "res://scripts/enemies/enemy.gd"

@export var speed: int = 32  # Vitesse du bike
var sprite_size: int = 12  # Taille du sprite du bike (pour le positionnement)
var direction: int = 1  # Direction du mouvement (1 pour droite, -1 pour gauche)

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	if position.x > get_viewport_rect().size.x + sprite_size:  # Si le bike sort de l'écran à droite
		queue_free()  # Le détruit