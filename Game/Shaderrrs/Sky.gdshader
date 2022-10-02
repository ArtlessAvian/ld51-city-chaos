shader_type spatial;
render_mode unshaded;

void fragment() {
	// can be simplified
	float delta_y = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).y;
	delta_y = clamp((delta_y + 30.0)/20.0, 0, 1);
	
	vec3 blue = vec3(0.2, 0.2, 0.7);
	vec3 gray = vec3(0.5);
	
	ALBEDO = (blue - gray) * delta_y + gray;
}
