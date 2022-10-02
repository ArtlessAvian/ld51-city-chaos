extends RichTextLabel

@onready var og_position = position

func push_message(message):
	
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", og_position + Vector2.LEFT * 3000, 0.5)
	tween.tween_property(self, "text", "[font_size=32]" + message, 0)
	tween.tween_property(self, "position", og_position, 0.5).from(og_position + Vector2.RIGHT * 3000)
