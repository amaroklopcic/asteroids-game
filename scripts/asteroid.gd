class_name Asteroid extends RigidBody2D

signal exploded(pos: Vector2, size: AsteroidSize)

@onready var sprite := $Sprite2D
@onready var collision_body := $CollisionShape2D
@onready var explosion_effect: GPUParticles2D = $ExplosionEffect

enum AsteroidSize { LARGE, MEDIUM, SMALL }
@export var asteroid_size = AsteroidSize.LARGE

var direction_vector := Vector2(0, -1)

var speed: float = 10


func _ready() -> void:
	rotation = randf_range(0, PI * 2)
	explosion_effect.finished.connect(_on_explosion_effect_end)

	match asteroid_size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			sprite.texture = preload("res://assets/textures/meteorGrey_big4.png")
			collision_body.shape = preload("res://resources/asteroid_collision_shape_large.tres")
			explosion_effect.amount = 16
			explosion_effect.scale = Vector2(1, 1)
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 200)
			sprite.texture = preload("res://assets/textures/meteorGrey_med2.png")
			collision_body.shape = preload("res://resources/asteroid_collision_shape_med.tres")
			explosion_effect.amount = 8
			explosion_effect.scale = Vector2(0.5, 0.5)
		AsteroidSize.SMALL:
			speed = randf_range(200, 300)
			sprite.texture = preload("res://assets/textures/meteorGrey_tiny1.png")
			collision_body.shape = preload("res://resources/asteroid_collision_shape_small.tres")
			explosion_effect.amount = 4
			explosion_effect.scale = Vector2(0.2, 0.2)

	linear_velocity = direction_vector.rotated(rotation) * speed


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(linear_velocity * delta)
	if collision != null:
		var obj = collision.get_collider()
		if obj is Player:
			obj.hurt_player()

	var radius: float = collision_body.shape.radius

	# send asteroid to other side of viewport if they go out of bounds
	var screen_size := get_viewport_rect().size
	if global_position.y + radius < 0:
		global_position.y = screen_size.y + radius
	elif global_position.y - radius > screen_size.y:
		global_position.y = -radius
	if global_position.x + radius < 0:
		global_position.x = screen_size.x + radius
	elif global_position.x - radius > screen_size.x:
		global_position.x = -radius


func explode() -> void:
	exploded.emit(global_position, asteroid_size)
	explosion_effect.emitting = true
	sprite.visible = false
	process_mode = PROCESS_MODE_DISABLED


func _on_explosion_effect_end():
	queue_free()
