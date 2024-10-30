extends Node

var asteroid_scene := preload("res://scenes/asteroid.tscn")


func _ready() -> void:
	GameState.on_stage_switch.connect(_on_stage_switch)


func _on_stage_switch(stage: GameState.Stage):
	if stage != GameState.Stage.MAIN:
		for child in get_children():
			if child is Asteroid:
				child.queue_free()
	else:
		for i in range(4):
			var a = asteroid_scene.instantiate()
			add_child(a)
