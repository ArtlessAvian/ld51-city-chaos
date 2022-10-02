extends CharacterBody3D
class_name Powerup

var bounces = 1

func _ready():
	velocity.y += 3
	velocity.x += 3
	velocity.z += 3

func _physics_process(delta):
	var was_on_floor = true
	if not is_on_floor():
		velocity.y -= 10 * delta
		was_on_floor = false

	move_and_slide()

	self.position.x = clamp(self.position.x, -15, 15)
	self.position.z = clamp(self.position.z, -2, 2)
	
	for body in $Area3d.get_overlapping_bodies():
		body.top_speed += 2
		queue_free()
	
	if bounces > 0 and is_on_floor() and not was_on_floor:
		bounces -= 1
		velocity.y = 1
	elif is_on_floor():
		velocity = velocity.move_toward(Vector3.ZERO, delta * 10);
