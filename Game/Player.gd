extends CharacterBody3D
class_name Player

@export var controller = "ui"
var swap_cooldown = 0
var tp_cooldown = 0
const swap_period = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	swap_cooldown -= delta
	tp_cooldown -= delta
	if Input.is_action_pressed(controller + "_up") and can_move_forward():
		swap_layer(-1)
	elif Input.is_action_pressed(controller + "_down") and can_move_backward():
		swap_layer(1)

	if is_on_floor():
		if Input.is_action_pressed(controller + "_select"):
			self.velocity.y += 10
	
	var input_x = Input.get_axis(controller + "_left", controller + "_right")
	var top_speed = 10
	var x_acc = 50
#	if input_x == 0 or sign(input_x * get_local_vel_x()) < -0.01:
#		set_local_vel_x(move_toward(get_local_vel_x(), 0, delta * 60))
#	else:
	set_local_vel_x(move_toward(get_local_vel_x(), input_x * top_speed, delta * x_acc))

	var gravity_acc = 20 if Input.is_action_pressed(controller + "_select") else 40
	velocity += Vector3.DOWN * delta * gravity_acc
	move_and_slide()
	self.position.z = round(self.position.z)

func swap_layer(delta_z: int):
	self.position.z += delta_z
	swap_cooldown = swap_period
	
	$Visual.position.z -= delta_z

func _process(delta: float):
	$Visual.position.z = move_toward($Visual.position.z, 0, delta * 1.0/swap_period)

	$Label3d.text = str(is_on_floor())

func can_move_forward():
	if self.position.z <= 0.5:
		return false
	for cast in $ForwardRaycast.get_children():
		if cast.is_colliding():
			return false
	return swap_cooldown <= 0 

func can_move_backward():
	if self.position.z >= 2.5:
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
