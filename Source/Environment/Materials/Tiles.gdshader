shader_type spatial;

uniform vec2 UV_scale = vec2(1);
uniform vec2 cutoff = vec2(0.1, 0.1);
uniform vec4 color : source_color = vec4(1.0);
uniform vec2 offset = vec2(0.0);

void fragment() {
	vec2 uv = UV * UV_scale;
	uv.x += floor(uv.y)*offset.x;
	uv.y += floor(uv.x)*offset.y;
	ALBEDO = color.rgb * vec3(float((fract(uv.x) > cutoff.x) && (fract(uv.y) > cutoff.y)));
}
