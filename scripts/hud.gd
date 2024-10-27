extends Control

var life_point_scene = preload("res://scenes/life_point.tscn")


func update_score(new_score: int):
	$Score.text = "SCORE: " + str(new_score)


# update the # of lives to reflect the amount passed in as `amount`
func update_lives(amount: int):
	var children = $LifePoints.get_children()
	for child in children:
		child.queue_free()
	for i in range(amount):
		$LifePoints.add_child(life_point_scene.instantiate())
