extends Control

signal restart_game()
signal quit_to_main_menu()
signal music_volume_change(value: float)
signal sound_volume_change(value: float)


func _on_restart_game_pressed() -> void:
	restart_game.emit()


func _on_quit_pressed() -> void:
	quit_to_main_menu.emit()


func _on_sound_volume_value_changed(value: float) -> void:
	sound_volume_change.emit(value)


func _on_music_volume_value_changed(value: float) -> void:
	music_volume_change.emit(value)
