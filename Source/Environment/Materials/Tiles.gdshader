shader_type spatial;

uniform float thickness = 0.1;
uniform vec2 UV_scale = vec2(1);
uniform vec4 color : source_color = vec4(1.0);

void fragment() {
	vec2 uv = UV * UV_scale;
	ALBEDO = color.rgb * vec3(float((fract(uv.x) > thickness) && (fract(uv.y) > thickness)));
}
