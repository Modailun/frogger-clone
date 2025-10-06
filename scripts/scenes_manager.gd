extends Node2D

# Liste des chemins vers tes scènes
const Scenes := {
	"MAIN_MENU" = "res://scenes/ui/main_menu.tscn",
	"LEVEL_1" = "res://scenes/levels/level_1.tscn",
	"SETTINGS" = "res://scenes/ui/settings.tscn",
	"CREDITS" = "res://scenes/ui/credits.tscn",
	"END_SCREEN_WIN" = "res://scenes/ui/end_screen_win.tscn",
	"END_SCREEN_LOSE" = "res://scenes/ui/end_screen_lose.tscn"
}

var latest_score : int = 0
var high_score : int = 0

# Fonction pour changer de scène
func change_scene(new_scene_path: String) -> void:
	get_tree().change_scene_to_file(new_scene_path)
