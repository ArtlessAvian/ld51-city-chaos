extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = $"../../..".global_position
	position /= 4
