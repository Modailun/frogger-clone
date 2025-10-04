extends CharacterBody2D

var sprite_size: int = 12
var initial_position: Vector2 = Vector2(167, 174)
var is_alive: bool = true

@onready var game_manager: Node = %GameManager
@onready var screen_shake: Camera2D = %ScreenShake
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	position = initial_position  # Start position
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	# Move tile by tile up, down, left or right
	var input_vector = Vector2.ZERO
	if Input.is_action_just_pressed("right") and position.x < viewport_size.x - sprite_size and is_alive:
		input_vector.x += 13
	if Input.is_action_just_pressed("left") and position.x > sprite_size and is_alive:
		input_vector.x -= 13
	if Input.is_action_just_pressed("down") and position.y < viewport_size.y - sprite_size and is_alive:
		input_vector.y += 13
	if Input.is_action_just_pressed("up") and position.y > 2*sprite_size and is_alive:
		input_vector.y -= 13
	position.x += input_vector.x
	position.y += input_vector.y

func died() -> void:
	if game_manager.lives > 1:
		screen_shake.apply_shake(2.0)
		position = initial_position
	else:
		is_alive = false
		collision_shape_2d.queue_free()
		screen_shake.apply_shake(30.0)
	game_manager.lose_life()
