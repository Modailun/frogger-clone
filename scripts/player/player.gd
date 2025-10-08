extends Node2D

var sprite_size: int = 12
var initial_position: Vector2 = Vector2(167, 174)
var is_alive: bool = true
var active_collision_count : int = 0
var is_drowning: bool = false
var is_dying: bool = false
var is_moving: bool = false  # Pour éviter les mouvements superposés
var tween : Tween
var vel := Vector2.ZERO
var home : bool = false

@onready var game_manager: Node = %GameManager
@onready var screen_shake: Camera2D = %ScreenShake

func _ready() -> void:
	position = initial_position  # Start position
	add_to_group("player")

func _process(delta):
	if is_alive:
		if tween == null or not tween.is_running():
			if is_drowning or is_dying:
				died()
				active_collision_count = 0
		position += vel * delta
	else:
		position = initial_position

func _physics_process(_delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	# Move tile by tile up, down, left or right
	var input_vector = Vector2.ZERO

	if is_moving or not is_alive:
		return  # On ne traite pas les inputs pendant un mouvement en cours

	if Input.is_action_just_pressed("right") and position.x < viewport_size.x - sprite_size:
		input_vector.x += 13
	if Input.is_action_just_pressed("left") and position.x > sprite_size and is_alive:
		input_vector.x -= 13
	if Input.is_action_just_pressed("down") and position.y < viewport_size.y - sprite_size:
		input_vector.y += 13
	if Input.is_action_just_pressed("up") and position.y > 2*sprite_size and is_alive:
		input_vector.y -= 13

	if input_vector != Vector2.ZERO:
		move_to_position(position + input_vector)

func move_to_position(target_position: Vector2) -> void:
	is_moving = true
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	is_moving = false

func died() -> void:
	is_alive = false
	position = initial_position
	if game_manager.lives > 1:
		is_alive = true
		screen_shake.apply_shake(2.0)
	else:
		screen_shake.apply_shake(30.0)
	is_drowning = false
	is_dying = false
	game_manager.lose_life()

func _on_log_coll_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		is_dying = true
	elif area.is_in_group("river") and active_collision_count <= 0 and is_alive:
		is_drowning = true

func _on_log_coll_body_entered(body: Node2D) -> void:
	active_collision_count += 1
	if body.is_in_group("log") or body.is_in_group("turtle"):
		vel = body.vel
	else:
		vel = Vector2.ZERO

func _on_log_coll_body_exited(_body: Node2D) -> void:
	active_collision_count -= 1
	# Si plus aucune collision active et que le joueur est dans l'eau
	if active_collision_count == 0 and position.y < 86 and is_alive and not home:
		print(position.y)
		print("Drowning")
		is_drowning = true
		vel = Vector2.ZERO

func reset_player() -> void:
	is_drowning = false
	is_dying = false
	active_collision_count = 0
	position = initial_position
	vel = Vector2.ZERO

func _on_lil_coll_body_entered(body: Node2D) -> void:
	if body.is_in_group("lilypad") and body.is_in_group("active") and is_alive:
		is_alive = false
		home = true
		position = initial_position
		print(position)
		game_manager.add_point(100)
		var player_sprite = get_child(0)  # Supposons que le sprite est le premier enfant
		var new_sprite = player_sprite.duplicate()  # Duplique le nœud
		body.add_child(new_sprite)
		body.remove_from_group("active")
		is_alive = true