extends CharacterBody3D
class_name Bullet

#var pierce = 1
var pierced = {} # dictionary as set :pensive:
var infinite_pierce = false
var go_left = false
var life = 0.25
var ownerr = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func post_init(go_left, strong, owner):
	self.go_left = go_left
	set_local_vel_x(15 * (-1 if go_left else 1))
	infinite_pierce = strong
	life = 1 if strong else 0.5
	scale = Vector3.ONE * (2 if strong else 1)
	
	if strong:
		$Area3d.collision_mask |= (1 << 13)
	
	self.ownerr = owner

func _physics_process(delta):
	life -= delta
	move_and_slide()
	
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

func _on_area_3d_body_entered(body):
	if is_queued_for_deletion():
		return
	if body != ownerr and body.has_method("take_damage") and not body in pierced:
		body.take_damage()
		body.position.x += -0.1 if go_left else 0.1
		pierced[body] = 0
		if not infinite_pierce: # and len(pierced) >= pierce:
			queue_free()
