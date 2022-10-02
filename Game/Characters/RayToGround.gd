extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var child = get_child(0)
	child.global_position = get_collision_point()
	child.global_position.y += 0.01
