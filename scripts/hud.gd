extends Control

var life_point_scene = preload("res://scenes/life_point.tscn")


func _ready() -> void:
	visible = false
	GameState.on_stage_switch.connect(_on_stage_switch)
	GameState.on_player_lives_update.connect(_on_player_lives_update)
	GameState.on_player_score_update.connect(_on_player_score_update)
	$Score.text = "SCORE: " + str(0)


func _on_stage_switch(stage: GameState.Stage):
	visible = stage == GameState.Stage.RUNNING


func _on_player_score_update(score: int):
	$Score.text = "SCORE: " + str(score)


func _on_player_lives_update(lives: int):
	var children = $LifePoints.get_children()
	for child in children:
		child.queue_free()
	for i in range(lives):
		$LifePoints.add_child(life_point_scene.instantiate())
