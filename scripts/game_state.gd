extends Node

signal on_game_reset
signal on_stage_switch(stage: Stage)
signal on_player_lives_update(new_lives: int)
signal on_player_score_update(new_score: int)

enum Stage { MAIN, RUNNING, PAUSED, UPGRADING, DEAD }

var _init_time: int
var _player_lives: int = 0
var _player_score: int = 0
var _stage: Stage = Stage.MAIN

@onready var game_node := get_node("/root/Main/Game")


func init():
	assert(_stage == Stage.MAIN, "Tried to init GameState with non-main stage")
	print("initializing game state...")
	reset()


func reset():
	print("running game reset...")
	_player_score = 0
	_player_lives = 3

	var screen_size := DisplayServer.window_get_size()
	_init_time = Helpers.curtime()
	print("initial screen size: ", screen_size)
	print("init time: ", _init_time)

	get_tree().paused = false

	print("sending game_reset signal...")
	on_game_reset.emit()
	on_player_lives_update.emit(_player_lives)
	on_player_score_update.emit(_player_score)

	set_stage(Stage.RUNNING)


func toggle_pause():
	if _stage == Stage.RUNNING:
		get_tree().paused = true
		set_stage(Stage.PAUSED)
	elif _stage == Stage.PAUSED:
		get_tree().paused = false
		set_stage(Stage.RUNNING)


func hurt_player():
	_player_lives -= 1
	on_player_lives_update.emit(_player_lives)
	if _player_lives == 0:
		SoundManager.play(SoundManager.SoundType.PLAYER_DEATH)
		SoundManager.play(SoundManager.SoundType.GAME_OVER)
		set_stage(Stage.DEAD)
	else:
		SoundManager.play(SoundManager.SoundType.PLAYER_HURT)


func set_player_score(new_score: int):
	_player_score = new_score
	on_player_score_update.emit(_player_score)


func set_stage(stage: Stage):
	print("STAGE SWITCH TO ", stage)
	_stage = stage
	on_stage_switch.emit(_stage)
