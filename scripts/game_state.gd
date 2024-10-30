extends Node

enum Stage { MAIN, RUNNING, PAUSED, UPGRADING, DEAD }

var init_time: int
var current_stage: Stage = Stage.MAIN
var player_score: int = 0
var player_lives: int = 0

# preload necessary scenes to start game
var laser_manager_scene = preload("res://scenes/lasers_manager.tscn")
var asteroid_manager_scene = preload("res://scenes/asteroids_manager.tscn")
var player_scene = preload("res://scenes/player.tscn")

@onready var game_node := get_node("/root/Main/Game")


func init():
	assert(current_stage == Stage.MAIN, "Tried to init GameState with non-main stage")
	print("initializing game state...")
	reset()


func reset():
	print("game reset...")
	player_score = 0
	player_lives = 3

	# clear all nodes from Game object and recreate them
	# for child in get_node("/root/Main/Game").get_children():
	# 	child.queue_free()

	# create the necessary nodes and entity managers to start the game
	var screen_size := DisplayServer.window_get_size()
	init_time = Time.get_ticks_msec()
	print("initial screen size: ", screen_size)
	print("init time: ", init_time)
	
	# var asteroid_manager = asteroid_manager_scene.instantiate()
	# root.add_child(asteroid_manager)

	# var lasers_manager = laser_manager_scene.instantiate()
	# root.add_child(lasers_manager)

	# var player = player_scene.instantiate()
	# player.global_position = Vector2(screen_size.x / 2.0, screen_size.y / 2.0)
	# root.add_child(player)

	set_stage(Stage.RUNNING)


func hurt_player():
	player_lives -= 0
	if player_lives == 0:
		SoundManager.play(SoundManager.SoundType.PLAYER_DEATH)
		SoundManager.play(SoundManager.SoundType.GAME_OVER)
		set_stage(Stage.DEAD)
	else:
		SoundManager.play(SoundManager.SoundType.PLAYER_HURT)


func set_stage(stage: Stage):
	current_stage = stage

	print("STAGE SWITCH TO ", stage)

	match stage:
		Stage.MAIN:
			pass
		Stage.RUNNING:
			pass
