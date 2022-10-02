shader_type spatial;

uniform sampler2D noise;

void vertex() {
	// every ten seconds! :D
	VERTEX.y += pow(sin(TIME * PI/10.0 + VERTEX.z/12.0), 4) - 1.0;
		
	// shrink to sphere, preserve y
	vec3 offset = vec3(0, -2, 8);
	if (length(VERTEX + offset) > 15.7) {
		//COLOR = vec4(vec3(0.2), 1);
		float radius = sqrt(15.7 * 15.7 - (VERTEX.y + offset.y) * (VERTEX.y + offset.y));
		VERTEX.xz = normalize(VERTEX.xz + offset.xz) * radius - offset.xz;
	}
}

void fragment() {
	float low = texture(noise, UV + vec2(0, -TIME/13.0)).x * -1.0;
	
	float y = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).y;
	y = clamp(y, low, -0.03);
	y = (y - low) / (-low - 0.03);
	
	vec3 blue = vec3(0.2, 0.5, 0.7);
	vec3 white = vec3(1);
	ALPHA = (1.0 - 0.5) * y + 0.5;
	ALBEDO = (white - blue) * y + blue;
}
