extends CharacterBody3D
class_name Powerup

var bounces = 1
const types = [
	preload("res://Game/PowerupType/TopSpeed.tres"),
	preload("res://Game/PowerupType/ProjectileCount.tres"),
	preload("res://Game/PowerupType/ChargeTimee.tres"),
	]
var type = types[0]

func _ready():
	#var theta = randf() * 2 * PI
	var y = randf() / 4 + 0.75
	velocity = Vector3.ZERO
	set_local_vel_x(sqrt(1-y*y) * (-1 if randf() < 0.5 else 1))
	velocity.y += y
	#velocity.z += cos(theta) * sqrt(1-y*y)
	velocity *= 6 
	
	type = types[randi() % len(types)]
	$Visual/Sprite3d.texture = type.texture

func _physics_process(delta):
	var was_on_floor = true
	if not is_on_floor():
		velocity.y -= 10 * delta
		was_on_floor = false

	move_and_slide()

	self.position.x = clamp(self.position.x, -15, 15)
	self.position.z = clamp(self.position.z, -2, 2)
	
	for body in $Area3d.get_overlapping_bodies():
		if body is Player:
			body.set(type.property, body.get(type.property) + type.delta)
			body.find_child("Popups").popup(type.display_name)
			queue_free()
	
	if bounces > 0 and is_on_floor() and not was_on_floor:
		bounces -= 1
		velocity.y = 3
	elif is_on_floor():
		velocity = velocity.move_toward(Vector3.ZERO, delta * 10);


func get_local_right():
	return Vector3.RIGHT.rotated(Vector3.UP, global_rotation.y)

func get_local_vel_x_vec():
	return velocity.project(get_local_right())

func get_local_vel_x():
	var proj = get_local_right()
	# proj y is zero
	return velocity.x * proj.x + velocity.y * proj.y + velocity.z * proj.z

func set_local_vel_x(signed_mag):
	velocity += get_local_right() * signed_mag - get_local_vel_x_vec()
