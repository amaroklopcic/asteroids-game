extends Node2D

@export var asteroids_per_min: float = 10

@onready var lasers := $Lasers
@onready var player := $Player
@onready var asteroids := $Asteroids
@onready var hud := $UI/HUD
@onready var game_over := $UI/GameOver

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var last_asteroid_spawn_ts: float = 0

var player_lives: int
var player_score: int


func _ready() -> void:
	$MusicManager/BackgroundMusic.play()
	update_player_score(0)
	update_player_lives(3)
	player.connect("player_hurt", _on_player_hurt)
	player.connect("laser_shot", _on_player_laser_shot)
	game_over.visible = false

	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
		print(asteroid)


func _process(_delta: float) -> void:
	var screen_size := get_viewport_rect().size
	var curtime := Time.get_ticks_msec()

	if curtime >= last_asteroid_spawn_ts + (1000 / (asteroids_per_min / 60)):
		var random_pos = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
		spawn_asteroid(random_pos, Asteroid.AsteroidSize.LARGE)
		last_asteroid_spawn_ts = curtime


func _on_player_laser_shot(laser):
	lasers.add_child(laser)
	$SoundManager/PlayerShootAudio.play()


func _on_asteroid_exploded(pos, size):
	$SoundManager/AsteroidHitAudio.play()

	# player reward
	match size:
		Asteroid.AsteroidSize.LARGE:
			update_player_score(player_score + 100)
		Asteroid.AsteroidSize.MEDIUM:
			update_player_score(player_score + 75)
		Asteroid.AsteroidSize.SMALL:
			update_player_score(player_score + 25)

	# spawn child asteroids
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass


func update_player_lives(new_lives: int):
	player_lives = new_lives
	hud.update_lives(player_lives)


func update_player_score(new_score: int):
	player_score = new_score
	hud.update_score(player_score)


func spawn_asteroid(pos: Vector2, size: Asteroid.AsteroidSize):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.asteroid_size = size
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)


func reset():
	update_player_score(0)
	update_player_lives(3)

	player.velocity = Vector2(0, 0)
	player.process_mode = Node.PROCESS_MODE_INHERIT
	game_over.visible = false

	for asteroid in asteroids.get_children():
		asteroid.queue_free()


func _on_game_over_on_restart() -> void:
	reset()


func _on_player_hurt():
	if player_lives == 1:
		update_player_lives(0)
		game_over.visible = true
		player.process_mode = Node.PROCESS_MODE_DISABLED
		$SoundManager/PlayerDeathAudio.play()
		$SoundManager/GameOverAudio.play()
	else:
		update_player_lives(player_lives - 1)
		$SoundManager/PlayerHurtAudio.play()
