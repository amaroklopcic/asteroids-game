extends Node2D

@export var asteroids_per_min: int = 10

var asteroid_scene = preload("res://scenes/asteroid.tscn")

var last_asteroid_spawn_ts: int


func _ready() -> void:
	GameState.on_game_reset.connect(_on_game_reset)


func _on_game_reset():
	for child in get_children():
		child.queue_free()


func spawn_asteroid(pos: Vector2, size: Asteroid.AsteroidSize):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.asteroid_size = size
	a.connect("exploded", _on_asteroid_exploded)
	call_deferred("add_child", a)


func _on_asteroid_exploded(pos: Vector2, size: Asteroid.AsteroidSize):
	SoundManager.play(SoundManager.SoundType.ASTEROID_HIT)

	# player reward
	match size:
		Asteroid.AsteroidSize.LARGE:
			GameState.set_player_score(GameState._player_score + 100)
		Asteroid.AsteroidSize.MEDIUM:
			GameState.set_player_score(GameState._player_score + 75)
		Asteroid.AsteroidSize.SMALL:
			GameState.set_player_score(GameState._player_score + 25)

	# spawn child asteroids
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass


func _process(_delta: float) -> void:
	var screen_size := get_viewport_rect().size
	var curtime := Helpers.curtime()

	if curtime >= last_asteroid_spawn_ts + (1000.0 / (asteroids_per_min / 60.0)):
		var random_pos = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		if random_pos.x >= 0:
			random_pos.x += screen_size.x
		if random_pos.y >= 0:
			random_pos.y += screen_size.y
		spawn_asteroid(random_pos, Asteroid.AsteroidSize.LARGE)
		last_asteroid_spawn_ts = curtime
