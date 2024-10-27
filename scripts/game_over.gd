extends Control

signal on_restart()


func _on_restart_button_up() -> void:
	on_restart.emit()
