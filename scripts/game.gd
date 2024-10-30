extends Node2D

@onready var lasers_manager := $LasersManager
@onready var asteroids_manager := $AsteroidsManager


func _ready() -> void:
	$Player.connect("shot_laser", _on_player_shot_laser)


func _on_player_shot_laser(laser: Node2D):
	lasers_manager.add_child(laser)
	SoundManager.play(SoundManager.SoundType.PLAYER_SHOOT)
