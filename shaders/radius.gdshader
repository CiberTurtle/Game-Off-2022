shader_type canvas_item;

uniform vec4 fill_color : source_color;
uniform float fill_ratio : hint_range(0.0, 1.0) = 1.0;

uniform vec4 border_color : source_color;
uniform float border_size_ratio: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	float len = length(UV - vec2(0.5));
	if (len < fill_ratio / 2.0) {
		if (len > 0.5 - border_size_ratio / 2.0) {
			COLOR = border_color;
		} else {
			COLOR = fill_color;
		}
	} else {
		discard;
	}
	
	// Place fragment code here.
}
