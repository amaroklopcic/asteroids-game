extends Node2D

@export var asteroids_per_min: int = 10

var asteroid_scene = preload("res://scenes/asteroid.tscn")

var last_asteroid_spawn_ts: int


func _ready() -> void:
	pass


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
			GameState.player_score += 100
		Asteroid.AsteroidSize.MEDIUM:
			GameState.player_score += 75
		Asteroid.AsteroidSize.SMALL:
			GameState.player_score += 25

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
	if GameState.current_stage != GameState.Stage.RUNNING:
		return

	var screen_size := get_viewport_rect().size
	var curtime := Helpers.curtime()

	if curtime >= last_asteroid_spawn_ts + (1000.0 / (asteroids_per_min / 60.0)):
		var random_pos = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
		spawn_asteroid(random_pos, Asteroid.AsteroidSize.LARGE)
		last_asteroid_spawn_ts = curtime
