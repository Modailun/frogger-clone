extends Node

# Score actuel du joueur
var score: int = 0
# Nombre de vies restantes
var lives: int = 3
var count: int = 0
# Multiplicateur de score (augmente toutes les 5 secondes)
var mul: int = 1
var sprite_size: int = 12
# Preload des scène d'ennemies
var bike_scene: PackedScene = preload("res://scenes/enemies/bike.tscn")
var bus_scene: PackedScene = preload("res://scenes/enemies/bus.tscn")
var big_car_scene: PackedScene = preload("res://scenes/enemies/big_car.tscn")
var truck_scene: PackedScene = preload("res://scenes/enemies/truck.tscn")
var car_scene: PackedScene = preload("res://scenes/enemies/car.tscn")

@onready var score_label: Label = $ScoreLabel
@onready var best_score_label: Label = $BestScoreLabel
@onready var lives_label: Label = $LivesLabel
@onready var game_over_timer: Timer = $GameOverTimer
@onready var bike_timer: Timer = $BikeTimer
@onready var bus_timer: Timer = $BusTimer
@onready var big_car_timer: Timer = $BigCarTime
@onready var truck_timer: Timer = $TruckTimer
@onready var car_timer: Timer = $CarTimer

func _ready() -> void:
	# Initialise les labels avec les valeurs de départ
	score_label.text = "Score: " + str(score)
	lives_label.text = "Lives: " + str(lives)
	best_score_label.text = "Best score: " + str(get_high_score())

# Ajoute des points au score
func add_point(points: int) -> void:
    # Ajoute les points au score
	#count += 1
	#if count%5 == 1 and count > 1:
	#	mul += 1
	score += points
    # Met à jour l'affichage du score
	score_label.text = "Score: " + str(score)
	best_score_label.text = "Best score: " + str(max(score, get_high_score()))

# Retire une vie au joueur
func lose_life() -> void:
	if lives > 1:
		lives -= 1  # Retire une vie
		mul = 1  # Réinitialise le multiplicateur
		# Met à jour l'affichage du score et des vies
		score_label.text = "Score: " + str(score)
		lives_label.text = "Lives: " + str(lives)
	else:
		# Si c'était la dernière vie, le joueur perd
		lives -= 1  # Retire une vie
		lives_label.text = "Lives: " + str(lives)
		Engine.time_scale = 0.5  # Ralentit le temps pour l'effet dramatique
		game_over_timer.start()  # Démarre le timer pour la fin de partie

func winner() -> void:
	game_over(true)

# Gère la fin de partie (victoire ou défaite)
func game_over(win: bool) -> void:
	# Enregistre le dernier score dans le gestionnaire de scènes
	ScenesManager.latest_score = score
	save_high_score()  # Sauvegarde le meilleur score
	ScenesManager.high_score = get_high_score()  # Récupère le meilleur score
	# Réinitialise les variables pour une nouvelle partie
	score = 0
	lives = 3
	mul = 1
	if not win:
		#print("Game Over")  # Affiche "Game Over" dans la console
		# Charge l'écran de fin de partie (défaite)
		ScenesManager.change_scene(ScenesManager.Scenes["END_SCREEN_LOSE"])
	else:
		#print("You Win!")  # Affiche "You Win!" dans la console
		# Charge l'écran de fin de partie (victoire)
		ScenesManager.change_scene(ScenesManager.Scenes["END_SCREEN_WIN"])

func save_high_score() -> void:
	var config = ConfigFile.new()
	config.load("user://savegame.cfg")
	if not config.has_section("HighScores"):
		config.set_value("HighScores", "score", score)
	else:
		var high_score = config.get_value("HighScores", "score", 0)
		if score > high_score:
			config.set_value("HighScores", "score", score)
	config.save("user://savegame.cfg")

func get_high_score() -> int:
	var config = ConfigFile.new()
	var error = config.load("user://savegame.cfg")
	if error == OK:
		if config.has_section("HighScores"):
			return config.get_value("HighScores", "score", 0)
	return 0

func _on_game_over_timer_timeout() -> void:
	Engine.time_scale = 1
	game_over(false)

func _on_bike_timer_timeout() -> void:
	# Instancie un nouvel bike
	var bike = bike_scene.instantiate()
	bike.position = Vector2(-sprite_size, 161)  # Position de départ (à gauche de l'écran)
	# Ajoute bike à la scène
	add_child(bike)
	bike_timer.wait_time = randf_range(1.0, 3.0)

func _on_bus_timer_timeout() -> void:
	# Instancie un nouvel bus
	var bus = bus_scene.instantiate()
	bus.position = Vector2(-5*sprite_size, 148)  # Position de départ (à gauche de l'écran)
	# Ajoute bus à la scène
	add_child(bus)
	bus_timer.wait_time = randf_range(2.0, 4.0)

func _on_car_timer_timeout() -> void:
	# Instancie un nouvel car
	var car = car_scene.instantiate()
	car.position = Vector2(320+2*sprite_size, 109)  # Position de départ (à gauche de l'écran)
	# Ajoute car à la scène
	add_child(car)
	car_timer.wait_time = randf_range(1.0, 3.0)

func _on_truck_timer_timeout() -> void:
	# Instancie un nouvel truck
	var truck = truck_scene.instantiate()
	truck.position = Vector2(320+3*sprite_size, 122)  # Position de départ (à gauche de l'écran)
	# Ajoute truck à la scène
	add_child(truck)
	truck_timer.wait_time = randf_range(2.0, 4.0)

func _on_big_car_time_timeout() -> void:
	# Instancie un nouvel big_car
	var big_car = big_car_scene.instantiate()
	big_car.position = Vector2(-2*sprite_size, 135)  # Position de départ (à gauche de l'écran)
	# Ajoute big_car à la scène
	add_child(big_car)
	big_car_timer.wait_time = randf_range(1.0, 3.0)
