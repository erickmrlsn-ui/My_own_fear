shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float vignette_strength : hint_range(0.0, 1.5) = 0.45;
uniform float vignette_radius : hint_range(0.0, 1.5) = 0.72;
uniform float grain_strength : hint_range(0.0, 0.15) = 0.018;
uniform float wave_strength : hint_range(0.0, 0.02) = 0.003;
uniform float pulse_strength : hint_range(0.0, 0.08) = 0.012;

float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = SCREEN_UV;

	// Distorsión MUY suave, sin fisheye.
	vec2 distorted_uv = uv;
	distorted_uv.x += sin((uv.y * 22.0) + TIME * .45) * wave_strength;
	distorted_uv.y += cos((uv.x * 16.0) + TIME * 0.35) * wave_strength * 0.5;

	vec4 screen_color = texture(screen_texture, distorted_uv);

	vec2 center = vec2(0.5, 0.5);
	float dist = length(uv - center);

	float pulse = sin(TIME * 1.5) * pulse_strength;

	// Viñeta suave.
	float vignette = smoothstep(vignette_radius + pulse, vignette_radius - 0.35 + pulse, dist);
	float darkness = 1.0 - vignette;

	screen_color.rgb *= 1.0 - darkness * vignette_strength;

	// Grano suave.
	float grain = random(uv * TIME * 20.0) * grain_strength;
	screen_color.rgb += grain;

	COLOR = screen_color;
}