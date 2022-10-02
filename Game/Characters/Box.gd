extends CharacterBody3D
class_name Box

var life = 22
var health = 3
var rotational_vel = Quaternion.IDENTITY

const powerup_scene = preload("res://Game/Characters/Powerup.tscn")

func _physics_process(delta):
	life -= delta
	if life < 0:
		queue_free()
	
	velocity += Vector3.DOWN * 18 * delta

	move_and_slide()
	self.position.x = clamp(self.position.x, -15, 15)
	self.position.z = clamp(self.position.z, -2, 2)

func _process(delta):
	if life < 2:
		$Visual.visible = fpart(life * 15) < 0.5
	
	if is_on_floor():
		$Visual/MeshInstance3d.rotation = Vector3.ZERO
		rotational_vel = Quaternion.IDENTITY
	else:
		if rotational_vel == Quaternion.IDENTITY:
			rotational_vel = pick_random_rotation()
		$Visual/MeshInstance3d.quaternion += rotational_vel * delta

func take_damage():
	health -= 1
	velocity.y = 8
	
	if health >= 0:
		var powerup = powerup_scene.instantiate()
		add_sibling(powerup)
		powerup.global_transform = global_transform
	if health <= 0:
		queue_free()
	
func pick_random_rotation():
	var z = randf() * 2 - 1
	var theta = randf() * 2 * PI
	var x = sqrt(1 - z * z) * sin(theta)
	var y = sqrt(1 - z * z) * cos(theta)
	return Quaternion(Vector3(x, y, z).normalized(), 5)

func fpart(x):
	return x - floor(x)
