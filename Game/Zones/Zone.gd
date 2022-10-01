extends Node3D
class_name Zone

func _physics_process(delta):
	for child in get_children():
		if child is CharacterBody3D:
			if child.position.x < -15:
				child.position.x = -15
				child.set_local_vel_x(0)
			if child.position.x > 15:
				child.position.x = 15
				child.set_local_vel_x(0)
