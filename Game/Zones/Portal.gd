extends Area3D

@export var my_zone = null
@export var goto_portal = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if my_zone == null:
		my_zone = $"../.."
	if goto_portal == null:
		goto_portal = self

func _physics_process(delta):
	$Label3d.text = str(get_overlapping_bodies())
	
	var entities = get_tree().get_nodes_in_group("Entity")
	for body in get_overlapping_bodies():
		if body in entities and body.tp_cooldown <= 0:
				if Input.is_action_pressed(body.controller + "_up"):
					var local = body.position
					body.get_parent().remove_child(body)
					goto_portal.my_zone.add_child(body)
					
					body.position = local.round()
					body.position.x *= -1
					body.velocity = Vector3.ZERO
					
					body.tp_cooldown = 1
					
