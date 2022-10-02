extends Node3D

enum AIState {IDLE_RIGHT, IDLE_LEFT, IDLE_THING, IDLE_HANG_AROUND, RETALIATE}
var state = AIState.IDLE_RIGHT;
var state_time = 0
var target_pos = null

func _ready():
	var action_prefix = get_parent().controller
	if (not InputMap.has_action(action_prefix + "up")):
		InputMap.add_action(action_prefix + "_up")
		InputMap.add_action(action_prefix + "_down")
		InputMap.add_action(action_prefix + "_left")
		InputMap.add_action(action_prefix + "_right")
		InputMap.add_action(action_prefix + "_select")
	
	state = AIState.IDLE_RIGHT if randf() < 0.5 else AIState.IDLE_LEFT

func _physics_process(_delta):
	change_state()
	choose_target()
	press_actions()
	state_time += 1

func change_state():
	match state:
		AIState.IDLE_RIGHT, AIState.IDLE_LEFT:
			if state_time > 60:
				state = AIState.IDLE_HANG_AROUND
				state_time = 0
		AIState.IDLE_HANG_AROUND:
			if state_time > 5:
				state = AIState.IDLE_RIGHT if randf() < 0.5 else AIState.IDLE_LEFT
				state_time = 0
				

func choose_target():
	var target = null
	match state:
		AIState.IDLE_RIGHT:
			target = get_node_or_null("../../Portals/Right") 
		AIState.IDLE_LEFT:
			target = get_node_or_null("../../Portals/Left")
		AIState.IDLE_HANG_AROUND:
			#target_pos.x = clamp(target_pos.x + randf() - 0.5, -10, 10)
			target = get_node("..")
	
	if target != null:
		target_pos = target.global_position
	$NavigationAgent3d.set_target_location(target_pos)

func press_actions():
	var action_prefix = get_parent().controller
	var global_next = $NavigationAgent3d.get_next_location()
	var local_next = global_next * get_parent().global_transform

	$Label3d.global_position = global_next
	$Label3d.text = str(local_next.round())

	if local_next.x > 0.5:
		Input.action_press(action_prefix + "_right")
	else:
		Input.action_release(action_prefix + "_right")
	if local_next.x < -0.5:
		Input.action_press(action_prefix + "_left")
	else:
		Input.action_release(action_prefix + "_left")
	if local_next.y > 0.4:
		Input.action_press(action_prefix + "_select")
	else:
		Input.action_release(action_prefix + "_select")
	if local_next.z > 0.6:
		Input.action_press(action_prefix + "_down")
	else:
		Input.action_release(action_prefix + "_down")
	if local_next.z < -0.6 or $"Portal".has_overlapping_areas():
		Input.action_press(action_prefix + "_up")
	else:
		Input.action_release(action_prefix + "_up")
