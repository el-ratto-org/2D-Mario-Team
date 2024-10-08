
float linear_weight(float dist, float start, float end) {
	//  ⎧            x-S⎫
	//  ⎨x<S:0,x>E:1,───⎬
	//  ⎩            E-S⎭
	// where x=dist, S=start, E=end
	return min(max((dist - start) / (end - start), 0), 1); // rewritten the piecewise into min/max
}

float circular_smooth(float dist, float smoothing) {
	// Simple value clamping
	if (dist < 0.0) return 0.0;
	if (dist > 1.0) return 1.0;

	//      2ʲ
	//  (2x)
	//  ────
	//   2
	// where x=dist, j=smoothing
	if (dist < 0.5) return pow(2.0 * dist, pow(2.0, smoothing)) / 2.0;

	//          2ʲ
	//  2-(2-2x)
	//  ──────────
	//      2
	// where x=dist, j=smoothing
	return (2.0 - pow(2.0 - 2.0 * dist, pow(2.0, smoothing))) / 2.0;
}

float rand(vec2 co) {
	highp float a = 12.9898;
	highp float b = 78.233;
	highp float c = 43758.5453;
	highp float dt = dot(co.xy ,vec2(a,b));
	highp float sn = mod(dt,3.14);
	return fract(sin(sn) * c);
}

vec2 calculate_aspect(vec2 size) {
	float actual = 1.0;
	if (size.x <= size.y) {
		return vec2(size.x / size.y, 1) * actual;
	} else {
		return vec2(1, size.y / size.x) * actual;
	}
}
