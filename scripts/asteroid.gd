class_name Asteroid extends Area2D

signal exploded(pos: Vector2, size: AsteroidSize)

@onready var sprite := $Sprite2D
@onready var collision_body := $CollisionShape2D

enum AsteroidSize { LARGE, MEDIUM, SMALL }
@export var asteroid_size = AsteroidSize.LARGE

var direction_vector := Vector2(0, -1)

var speed: float = 10

func _ready() -> void:
	rotation = randf_range(0, PI * 2)

	match asteroid_size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			sprite.texture = preload("res://assets/textures/meteorGrey_big4.png")
			collision_body.shape = preload("res://resources/asteroid_collision_shape_large.tres")
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 200)
			sprite.texture = preload("res://assets/textures/meteorGrey_med2.png")
			collision_body.shape = preload("res://resources/asteroid_collision_shape_med.tres")
		AsteroidSize.SMALL:
			speed = randf_range(200, 300)
			sprite.texture = preload("res://assets/textures/meteorGrey_tiny1.png")
			collision_body.shape = preload("res://resources/asteroid_collision_shape_small.tres")


func _physics_process(delta: float) -> void:
	global_position += direction_vector.rotated(rotation) * speed * delta	

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
	queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hurt_player()
