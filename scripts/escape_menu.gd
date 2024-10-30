extends Control


func _ready() -> void:
	print("initializing escape menu...")
	visible = false
	var game_resume_button = $CenterContainer/VBoxContainer/VBoxContainer/Resume
	game_resume_button.connect("pressed", _on_game_resume)
	var game_restart_button = $CenterContainer/VBoxContainer/VBoxContainer/RestartGame
	game_restart_button.connect("pressed", _on_game_restart)
	var game_quit_button = $CenterContainer/VBoxContainer/VBoxContainer/Quit
	game_quit_button.connect("pressed", _on_game_quit)
	var music_volume_slider = $CenterContainer/VBoxContainer/Settings/MusicVolume
	music_volume_slider.connect("value_changed", _on_music_volume_changed)
	var sound_volume_slider = $CenterContainer/VBoxContainer/Settings/SoundVolume
	sound_volume_slider.connect("value_changed", _on_sound_volume_changed)
	GameState.on_stage_switch.connect(_on_stage_switch)


func _on_game_resume():
	GameState.toggle_pause()


func _on_stage_switch(stage: GameState.Stage):
	visible = stage == GameState.Stage.PAUSED


func _on_game_restart() -> void:
	print("restarting game...")
	GameState.reset()


func _on_game_quit() -> void:
	get_tree().quit()


func _on_sound_volume_changed(value: float) -> void:
	SoundManager.volume = value


func _on_music_volume_changed(value: float) -> void:
	MusicManager.volume = value


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		GameState.toggle_pause()
