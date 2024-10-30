extends RigidBody2D

@export var speed := 750

var movement_vector := Vector2(0, -1)


func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_screen_exited)


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(movement_vector.rotated(rotation) * speed * delta)
	if collision != null:
		var obj := collision.get_collider()
		if obj is Asteroid:
			obj.explode()
			queue_free()


func _on_screen_exited() -> void:
	queue_free()
