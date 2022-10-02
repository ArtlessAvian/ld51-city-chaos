extends CharacterBody3D
class_name Player

@export var controller = "kb"
var swap_cooldown = 0
var tp_cooldown = 0
const swap_period = 0.1
var big_bullet_cooldown = 0
var facing_left = false

var top_speed = 6
var x_acc = 50

const bullet_scene = preload("res://Game/Characters/Bullet.tscn")
var projectiles = []
var projectile_count = 2
var charge_time = 1
var wave_theta = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	swap_cooldown -= delta
	tp_cooldown -= delta
	big_bullet_cooldown -= delta
	if Input.is_action_pressed(controller + "_in") and can_move_forward():
		swap_layer(-1)
	elif Input.is_action_pressed(controller + "_out") and can_move_backward():
		swap_layer(1)

	if is_on_floor():
		if Input.is_action_pressed(controller + "_jump"):
			self.velocity.y += 10
	
	var input_x = Input.get_axis(controller + "_left", controller + "_right")
	if input_x != 0:
		facing_left = input_x < 0
#	if input_x == 0 or sign(input_x * get_local_vel_x()) < -0.01:
#		set_local_vel_x(move_toward(get_local_vel_x(), 0, delta * 60))
#	else:
	set_local_vel_x(move_toward(get_local_vel_x(), input_x * top_speed, delta * x_acc))

	var gravity_acc = 20 if Input.is_action_pressed(controller + "_jump") else 40
	velocity += Vector3.DOWN * delta * gravity_acc
	move_and_slide()
	self.position.z = clamp(round(self.position.z), -2, 2)
	
	if any_shoot():
		for bullet in projectiles:
			if bullet == null:
				projectiles.erase(bullet)
		if len(projectiles) < projectile_count:
			var bullet = bullet_scene.instantiate()
			add_sibling(bullet)
			bullet.global_transform = global_transform
			bullet.position.y += 0.5
			bullet.position.z += sin(wave_theta) * 0.3
			wave_theta += 0.4
			projectiles.append(bullet)
			bullet.post_init(facing_left, big_bullet_cooldown <= 0, self)
			# if projectile_count >= 60:
				# can't shoot more, so shoot more damage.
			#	bullet.pierce = floor(projectile_count / 60)
			#	var fpart = projectile_count/60 - floor(projectile_count / 60)
			#	if fpart < randf():
			#		bullet.pierce += 1
			#	print(bullet.pierce)
			big_bullet_cooldown = charge_time
			
func take_damage():
	velocity.y = 15
	var tween = create_tween()
	tween.tween_property($Visual/Sprite3d, "modulate", Color.WHITE, 0.1).from(Color.RED)
	

# for plinking
func any_shoot():
	var accessiblity: Callable = Input.is_action_just_pressed
	if projectile_count > 5:
		accessiblity = Input.is_action_pressed
	if accessiblity.call(controller + "_shoot"):
		return true
	if accessiblity.call(controller + "_shoot2"):
		return true
	if accessiblity.call(controller + "_shoot3"):
		return true

func swap_layer(delta_z: int):
	self.position.z += delta_z
	swap_cooldown = swap_period
	
	$Visual.position.z -= delta_z

func _process(delta: float):
	$Visual.position.z = move_toward($Visual.position.z, 0, delta * 1.0/swap_period)
	$Visual.position.y = pow(sin($Visual.position.z * PI), 2) * 0.1 

	$Visual/Sprite3d.flip_h = facing_left
	
	if charge_time > 0:
		%Progress/Bar.scale.x = clamp((charge_time - big_bullet_cooldown)/charge_time, 0, 1)
	else:
		%Progress/Bar.scale.x = 1

func can_move_forward():
	if self.position.z <= -1.5:
		return false
	for cast in $ForwardRaycast.get_children():
		if cast.is_colliding():
			return false
	return swap_cooldown <= 0 

func can_move_backward():
	if self.position.z >= 1.5:
		return false
	for cast in $BackwardRaycast.get_children():
		if cast.is_colliding():
			return false
	return swap_cooldown <= 0 

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
