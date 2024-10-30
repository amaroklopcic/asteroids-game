extends Control


func _ready() -> void:
	visible = false
	GameState.on_stage_switch.connect(_on_stage_switch)
	$CenterContainer/VBoxContainer/Restart.connect("pressed", _on_restart)


func _on_stage_switch(stage: GameState.Stage):
	visible = stage == GameState.Stage.DEAD


func _on_restart():
	GameState.reset()
