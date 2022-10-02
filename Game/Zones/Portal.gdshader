shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

float sinn(float theta) {
	return (sin(theta) + 1.0) / 2.0;
}

float not_noise(vec2 uv, float time) {
	float acc = 0.0;
	acc += sinn(uv.x * 2.0 * PI * 2.0 + time);
	acc += sinn(uv.x * 2.0 * PI * -3.0 + time);
	acc += sinn(uv.x * 2.0 * PI * -5.0 + time);
	acc += sinn(uv.x * 2.0 * PI * 7.0 + time);
	acc += sinn(uv.x * 2.0 * PI * 11.0 + time);
	acc += sinn(uv.x * 2.0 * PI * -13.0 + time);
	return acc / 5.0 * uv.y;
}

void fragment() {
	// Place fragment code here.
	ALPHA = not_noise(UV, TIME * PI * 3.0);
}
