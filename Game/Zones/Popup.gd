extends Label3D

func popup(text):
	var label : Label3D = duplicate()
	label.text = text
	label.show()
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(label, "position", Vector3.UP * 3, 1)
	tween.parallel().tween_property(label, "modulate", Color(1, 1, 1, 0), 1)
	tween.parallel().tween_property(label, "outline_modulate", Color(0, 0, 0, 0), 1)
	tween.tween_callback(label.queue_free)
	
	add_sibling(label)
