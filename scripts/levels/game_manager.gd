extends Node

# Score actuel du joueur
var score: int = 0
# Nombre de vies restantes
var lives: int = 3
var count: int = 0
# Multiplicateur de score (augmente toutes les 5 secondes)
var mul: int = 1
# Scène de bike (préchargée pour instanciation)
var bike_scene: PackedScene = preload("res://scenes/enemies/bike.tscn")

@onready var score_label: Label = $ScoreLabel
@onready var best_score_label: Label = $BestScoreLabel
@onready var lives_label: Label = $LivesLabel
@onready var game_over_timer: Timer = $GameOverTimer
@onready var bike_timer: Timer = $BikeTimer

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
	bike.position = Vector2(-13, 161)  # Position de départ (à gauche de l'écran)
	# Ajoute bike à la scène
	add_child(bike)
	bike_timer.wait_time = randf_range(1.5, 3.0)
