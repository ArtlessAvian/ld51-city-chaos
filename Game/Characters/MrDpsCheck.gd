extends CharacterBody3D
class_name Dps

const powerup_scene = preload("res://Game/Characters/Powerup.tscn")


var swap_cooldown = 0
const swap_period = 0.1
var facing_left = false
var health = 15 # 10/20, 0.5 seconds per shot, ~20 powerups minimum.
var random_walk = 0

var randommm
var guarding_box = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randommm = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	swap_cooldown -= delta
	var player = get_node_or_null("../Player")
	if player != null:
		chase_player(delta, player, randommm % 120 < 10)
	
	var gravity_acc = 40
	velocity += Vector3.DOWN * delta * gravity_acc
	ligma()
	self.position.z = clamp(round(self.position.z), -2, 2)

func ligma():
	move_and_slide()
	


func chase_player(delta, player, match_z = false):
	if is_on_floor():
		if randf() < 0.01:
			self.velocity.y += 10
	
	var input_x = sign(player.position.x - self.position.x)
	facing_left = input_x < 0
	if input_x == 0 or sign(input_x * get_local_vel_x()) < -0.01:
		set_local_vel_x(move_toward(get_local_vel_x(), 0, delta * 10))
	else:
		set_local_vel_x(move_toward(get_local_vel_x(), input_x * 5, delta * 80))

func take_damage():
	health -= 1
	print(health)
	
	if health <= 0:
		if randf() < 0.3:
			var powerup = powerup_scene.instantiate()
			add_sibling(powerup)
			powerup.global_transform = global_transform
		queue_free()
		return
	
	var tween = create_tween()
	tween.tween_property($Visual/Sprite3d, "modulate", Color.WHITE, 10/15.0).from(Color.RED)

func _process(delta: float):
	$Visual.position.z = move_toward($Visual.position.z, 0, delta * 1.0/swap_period)
	$Visual.position.y = pow(sin($Visual.position.z * PI), 2) * 0.1 

	$Visual/Sprite3d.flip_h = facing_left
	%Progress/Bar.scale.x = health / 10.0

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

func _on_area_3d_body_entered(body):
	body.take_damage()

# mr dps check
func _on_dps_check_forcefield_body_entered(body):
	if not body.infinite_pierce:
		body.velocity = -body.velocity.rotated(Vector3.FORWARD, randf() * 2 - 1)
