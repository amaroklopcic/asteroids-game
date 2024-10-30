extends Control

signal game_start
signal music_volume_change(value: float)
signal sound_volume_change(value: float)


func _ready() -> void:
	print("initializing escape menu...")
	var game_start_button = $CenterContainer/VBoxContainer/VBoxContainer/RestartGame
	game_start_button.connect("pressed", _on_game_start)
	var game_quit_button = $CenterContainer/VBoxContainer/VBoxContainer/Quit
	game_quit_button.connect("pressed", _on_game_quit)
	var music_volume_slider = $CenterContainer/VBoxContainer/Settings/MusicVolume
	music_volume_slider.connect("value_changed", _on_music_volume_changed)
	var sound_volume_slider = $CenterContainer/VBoxContainer/Settings/SoundVolume
	sound_volume_slider.connect("value_changed", _on_sound_volume_changed)


func _on_game_start() -> void:
	print("starting game...")

	# hide asteroids floating around in main_menu and disable their physics
	for child in get_node("/root/Main/MainMenuBackground").get_children():
		if child is Asteroid:
			child.visible = false
			child.set_physics_process(false)

	# hide this main menu UI and initialize game state
	visible = false
	GameState.reset()

	game_start.emit()


func _on_game_quit() -> void:
	get_tree().quit()


func _on_sound_volume_changed(value: float) -> void:
	sound_volume_change.emit(value)
	SoundManager.volume = value


func _on_music_volume_changed(value: float) -> void:
	music_volume_change.emit(value)
	MusicManager.volume = value


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		visible = !visible
