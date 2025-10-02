extends Container

@onready var start_game: Button = $MarginContainer/HBoxContainer/VBoxContainer/MenuOptions/StartGame

func _ready() -> void:
	start_game.grab_focus.call_deferred()

func _on_start_game_pressed() -> void:
	#print("Start Game")
	start_game.release_focus()
	ScenesManager.change_scene(ScenesManager.Scenes["LEVEL_1"])

func _on_options_pressed() -> void:
	ScenesManager.change_scene(ScenesManager.Scenes["SETTINGS"])

func _on_credits_pressed() -> void:
	ScenesManager.change_scene(ScenesManager.Scenes["CREDITS"])

func _on_exit_pressed() -> void:
	get_tree().quit()


