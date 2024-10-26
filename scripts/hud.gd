extends Control


@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)
@onready var life_points = $LifePoints

var lp_scene = preload("res://scenes/life_point.tscn")


# update the # of lives to reflect the amount passed in as `amount`
func update_lives(amount: int):
	var children = life_points.get_children()
	if len(children) > amount:
		remove_life(len(children) - amount)
	else:
		add_life(amount - len(children))


func remove_life(amount: int):
	var children := life_points.get_children()
	children.reverse()
	for i in range(amount):
		children[i].queue_free()


func add_life(amount: int):
	for i in range(amount):
		life_points.add_child(lp_scene.instantiate())
