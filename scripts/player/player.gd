extends CharacterBody2D

var sprite_size: int = 12

func _physics_process(_delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	# Move tile by tile up, down, left or right
	var input_vector = Vector2.ZERO
	if Input.is_action_just_pressed("right") and position.x < viewport_size.x - sprite_size:
		input_vector.x += 13
	if Input.is_action_just_pressed("left") and position.x > sprite_size:
		input_vector.x -= 13
	if Input.is_action_just_pressed("down") and position.y < viewport_size.y - sprite_size:
		input_vector.y += 13
	if Input.is_action_just_pressed("up") and position.y > 2*sprite_size:
		input_vector.y -= 13
	position.x += input_vector.x
	position.y += input_vector.y
