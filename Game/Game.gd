@tool
extends Node3D

const ZONES = 6

@export var dirty = false
@export var spacing = 10.0

func _ready():
	setup()

func _process(delta):
	if dirty:
		dirty = false
		setup()

func setup():	
	for i in range(ZONES):
		var zone : Node3D = get_node("Zones").get_child(i)
		zone.position = Vector3.FORWARD.rotated(Vector3.UP, 2 * PI/ZONES * i) * -spacing
		var rounded_rotate = PI/2 * round(4.0 / ZONES * i)
		#zone.rotation = Vector3.UP * rounded_rotate
		zone.rotation = Vector3.UP * 2 * PI/ZONES * i

	for i in range(ZONES):
		var right = get_node("Zones").get_child(i).get_node("Portals/Right")
		var next_left = get_node("Zones").get_child((i + 1) % ZONES).get_node("Portals/Left")
		right.goto_portal = next_left
		next_left.goto_portal = right

		#var nav_link = right.get_node("Link")
		#var nav_link_other = next_left.get_node("Link")
		#nav_link.end_location = nav_link_other.global_position * nav_link.global_transform
		# its bidirecitonal
		# nav_link_other.get_parent().remove_child(nav_link_other)

	# get_node("Zones").bake_navigation_mesh()
