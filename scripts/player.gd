class_name Player extends CharacterBody2D

signal player_escape()
signal laser_shot(laser: Node2D)
signal player_hurt()

var laser_scene = preload("res://scenes/laser.tscn")

@export var rpm: float = 600
@export var acceleration: int = 1000
@export var max_speed: int = 400

@onready var muzzle1 := $Muzzle1
@onready var muzzle2 := $Muzzle2
@onready var muzzle := muzzle1
@onready var last_shot_ts: int = 0


func _process(_delta: float) -> void:
	var curtime := Time.get_ticks_msec()
	var is_shooting = Input.is_action_pressed("shoot")
	if is_shooting and curtime >= last_shot_ts + (1000 / (rpm / 60)):
		shoot_laser()
		last_shot_ts = curtime

	if Input.is_action_just_pressed("escape"):
		player_escape.emit()


func _physics_process(delta: float) -> void:
	var offset := PI / 2

	# rotate player body towards mouse position with 90 degree offset
	var mouse_pos := get_global_mouse_position()
	var rotation_dir := (mouse_pos - global_position).normalized()
	rotation = rotation_dir.angle() + offset

	# player movement
	var direction_vector := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_forward", "move_backward"),
	)
	velocity += direction_vector * acceleration * delta
	velocity = velocity.limit_length(max_speed)

	if direction_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)

	move_and_slide()

	# send player to other side of viewport if they go out of bounds
	var screen_size := get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0


func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	laser_shot.emit(l)

	# switch muzzle for next shot
	muzzle = muzzle1 if muzzle == muzzle2 else muzzle2	


func hurt_player():
	player_hurt.emit()
