extends CharacterBody3D
class_name Bullet

#var pierce = 3
var pierced = []
var pierces = false
var go_left = false
var life = 0.25
var ownerr = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func post_init(go_left, strong, owner):
	set_local_vel_x(15 * (-1 if go_left else 1))
	#pierce = 3 if strong else 1
	pierces = strong
	life = 1 if strong else 0.5
	scale = Vector3.ONE * (2 if strong else 1)
	
	self.ownerr = owner

func _physics_process(delta):
	life -= delta
	move_and_slide()
	
	for body in $Area3d.get_overlapping_bodies():
		if body != ownerr and not body in pierced:
			if body.has_method("take_damage"):
				body.take_damage()
			if pierces:
				pierced.append(body)
			else:
				queue_free()
	
	if life < 0 or is_on_wall() or abs(position.x) >= 15:
		queue_free()

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
