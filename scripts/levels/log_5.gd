extends CharacterBody2D

@export var speed: int = 32  # Vitesse du big car
@export var vel: Vector2 = Vector2.ZERO
var sprite_size: int = 12  # Taille du sprite du big car (pour le positionnement)
var direction: int = 1  # Direction du mouvement (1 pour droite, -1 pour gauche)

func _ready() -> void:
	add_to_group("log")
	vel = Vector2(direction * speed, 0)

func _physics_process(_delta: float) -> void:
	set_velocity(vel)
	move_and_slide()
	if position.x < -5*sprite_size:  # Si le big car sort de l'écran à droite
		queue_free()  # Le détruit