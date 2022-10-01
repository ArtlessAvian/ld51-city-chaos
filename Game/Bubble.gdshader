shader_type spatial;

uniform vec3 ZONE_CENTER_WORLD;

void fragment() {
	// delta is relative to the model
	vec3 delta = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).xyz;
	// now should be relative to 0,0 but not really
	delta -= NODE_POSITION_WORLD;
	delta -= ZONE_CENTER_WORLD;

	if (length(delta) > 16.0) {
		discard;
	}
}
