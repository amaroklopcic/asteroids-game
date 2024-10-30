extends Control

signal game_start
signal music_volume_change(value: float)
signal sound_volume_change(value: float)


func _ready() -> void:
	print("initializing main menu...")
	var game_start_button = $CenterContainer/VBoxContainer/VBoxContainer/StartGame
	game_start_button.connect("pressed", _on_game_start)
	var game_quit_button = $CenterContainer/VBoxContainer/VBoxContainer/Quit
	game_quit_button.connect("pressed", _on_game_quit)
	var music_volume_slider = $CenterContainer/VBoxContainer/Settings/MusicVolume
	music_volume_slider.connect("value_changed", _on_music_volume_changed)
	var sound_volume_slider = $CenterContainer/VBoxContainer/Settings/SoundVolume
	sound_volume_slider.connect("value_changed", _on_sound_volume_changed)


func _on_game_start() -> void:
	print("starting game...")

	# hide this main menu UI and initialize game state
	visible = false
	GameState.init()

	game_start.emit()


func _on_game_quit() -> void:
	get_tree().quit()


func _on_sound_volume_changed(value: float) -> void:
	sound_volume_change.emit(value)
	SoundManager.volume = value


func _on_music_volume_changed(value: float) -> void:
	music_volume_change.emit(value)
	MusicManager.volume = value
