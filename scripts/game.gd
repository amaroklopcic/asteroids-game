extends Node2D

@export var asteroids_per_min: float = 10

@onready var lasers := $Lasers
@onready var player := $Player
@onready var asteroids := $Asteroids
@onready var hud := $UI/HUD

var asteroid_scene = preload("res://scenes/asteroid.tscn")

var player_lives: int = 3
var player_score: int = 0:
	set(value):
		player_score = value
		hud.score = value
var last_asteroid_spawn_ts: float = 0


func _ready() -> void:
	player_lives = 3
	player_score = 0
	player.connect("player_hurt", _on_player_hurt)
	player.connect("laser_shot", _on_player_laser_shot)

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


func _on_player_hurt(lives_left: int):
	player_lives = lives_left
	hud.update_lives(lives_left)


func _on_player_laser_shot(laser):
	lasers.add_child(laser)


func _on_asteroid_exploded(pos, size):
	# player reward
	match size:
		Asteroid.AsteroidSize.LARGE:
			player_score += 100
		Asteroid.AsteroidSize.MEDIUM:
			player_score += 75
		Asteroid.AsteroidSize.SMALL:
			player_score += 25

	# spawn child asteroids
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass


func spawn_asteroid(pos: Vector2, size: Asteroid.AsteroidSize):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.asteroid_size = size
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)
