extends "res://scripts/enemies/enemy.gd"

@export var speed: int = 64  # Vitesse du big car
var sprite_size: int = 12  # Taille du sprite du big car (pour le positionnement)
var direction: int = -1  # Direction du mouvement (1 pour droite, -1 pour gauche)

func _ready() -> void:
	add_to_group("car")

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta
	if position.x < -2*sprite_size:  # Si le big car sort de l'écran à droite
		queue_free()  # Le détruit