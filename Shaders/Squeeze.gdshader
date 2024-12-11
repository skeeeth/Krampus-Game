shader_type canvas_item;
uniform sampler2D noise;
uniform float intensity;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;
void vertex() {
	//VERTEX.x *= 1.0-(intensity/5.0);
	//VERTEX.y *= 1.0-(intensity/5.0);
}

void fragment() {
	vec2 center = vec2(0.5); //vec2(cos(angle*TAU),sin(angle*TAU));
	vec2 diff = SCREEN_UV-center;
	float d = distance(center,SCREEN_UV);
	float frag_a = atan(diff.y,diff.x);
	float noise_a = mix(0,-PI/2.0,frag_a/TAU);
	vec2 ang_p = vec2(cos(noise_a),sin(noise_a));
	float y_change = intensity*(texture(noise,ang_p).b-0.0);
	vec2 read_uv = SCREEN_UV+(diff*y_change);
	//read_uv = clamp(read_uv,vec2(0.0),vec2(0.5));
	COLOR = texture(screen_texture,read_uv);
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
