extends "res://scripts/enemies/enemy.gd"

@export var speed: int = 64  # Vitesse du bus
var sprite_size: int = 12  # Taille du sprite du bus (pour le positionnement)
var direction: int = 1  # Direction du mouvement (1 pour droite, -1 pour gauche)

func _ready() -> void:
	add_to_group("bus")

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	if position.x > get_viewport_rect().size.x + 5*sprite_size:  # Si le bus sort de l'écran à droite
		queue_free()  # Le détruit