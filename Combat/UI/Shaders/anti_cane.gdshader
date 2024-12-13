shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float new_x = UV.x;
	float new_y = UV.y;
	float x_shift = sin(UV.y*15.0) * sin(UV.x*6.0);
	new_x += sin(TIME/4.0) * x_shift;
	new_x = fract(new_x);
	new_y += TIME/5.0 + sin(UV.x*4.0);
	new_y = fract(new_y);
	vec2 on_screen = step(vec2(0.0,0.0),SCREEN_UV);
	COLOR = vec4(texture(TEXTURE,vec2(new_x,new_y)).xyz,COLOR.a * on_screen.x*on_screen.y);
	//COLOR = texture(TEXTURE,vec2(new_x,new_y));
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
