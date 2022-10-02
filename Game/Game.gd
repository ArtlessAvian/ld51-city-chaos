@tool
extends Node3D

@export var dirty = false
@export var spacing = 10.0

const box_scene = preload("res://Game/Characters/Box.tscn")
const enemy_scene = preload("res://Game/Characters/Enemy.tscn")

var zone_colors = {
	"Park" : "[color=#474]Park[/color]",
	"Overpass" : "[color=#aaa]Overpass[/color]",
	"Beach" : "[color=#bb3]Beach[/color]"
}

var events = [
	self.add_mooks
]
var event_timer : float = 10
var event_count = 0

func _ready():
	setup()

func _process(delta):
	if dirty:
		dirty = false
		setup()
	
	%Secs.text = str(floor(event_timer))
	%Millisecs.text = "." + str(1000 + int(floor(event_timer * 100)) % 1000).substr(1)
	%Progrses.value = event_timer

func _physics_process(delta):
	event_timer -= delta
	if event_timer <= 0:
		event_timer += 10
		event_count += 1
		if event_count < 18:
			events[randi() % len(events)].call()
		elif event_count == 18:
			end_game()
		elif event_count == 19:
			end_game_again()
		else:
			end_game_for_real()
		add_box()
		add_box()
		add_box()
		add_box()
		add_box()

func add_box():
	var zone = $Zones.get_child(randi() % $Zones.get_child_count())
	var instance = box_scene.instantiate()
	zone.add_child(instance)
	instance.position = Vector3.UP * 10
	instance.position.x += (randf() * 2 - 1) * 15
	instance.position.z += (randf() * 4 - 2)
	instance.rotation = Vector3.ZERO

func add_mooks():
	var zone = $Zones.get_child(randi() % $Zones.get_child_count())
	%Notif.push_message("Enemies spotted at the " + zone_colors[zone.name] + "!")

	for _i in range(event_count + 5):
		var instance = enemy_scene.instantiate()
		zone.add_child(instance)
		instance.position = Vector3.UP * 10
		instance.position.x += (randf() * 2 - 1) * 15
		instance.position.z += (randf() * 4 - 2)
		instance.rotation = Vector3.ZERO

func end_game():
	%Notif.push_message("[color=#faa]The end is near.[/color]")

func end_game_again():
	%Notif.push_message("This is the end.")

func end_game_for_real():
	pass

func setup():
	var zones = get_node("Zones").get_child_count()
		
	for i in range(zones):
		var zone : Node3D = get_node("Zones").get_child(i)
		zone.position = Vector3.FORWARD.rotated(Vector3.UP, 2 * PI/zones * i) * -spacing
		var rounded_rotate = PI/2 * round(4.0 / zones * i)
		#zone.rotation = Vector3.UP * rounded_rotate
		zone.rotation = Vector3.UP * 2 * PI/zones * i

	for i in range(zones):
		var right = get_node("Zones").get_child(i).get_node("Portals/Right")
		var next_left = get_node("Zones").get_child((i + 1) % zones).get_node("Portals/Left")
		right.goto_portal = next_left
		next_left.goto_portal = right

		#var nav_link = right.get_node("Link")
		#var nav_link_other = next_left.get_node("Link")
		#nav_link.end_location = nav_link_other.global_position * nav_link.global_transform
		# its bidirecitonal
		# nav_link_other.get_parent().remove_child(nav_link_other)

	# get_node("Zones").bake_navigation_mesh()
