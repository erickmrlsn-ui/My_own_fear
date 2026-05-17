shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float vignette_strength : hint_range(0.0, 2.0) = 1.25;
uniform float vignette_radius : hint_range(0.0, 1.5) = 0.62;
uniform float center_light : hint_range(0.0, 1.0) = 0.10;
uniform float distortion_strength : hint_range(0.0, 0.08) = 0.012;
uniform float pulse_strength : hint_range(0.0, 0.2) = 0.025;
uniform float grain_strength : hint_range(0.0, 0.2) = 0.03;

float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 center = vec2(0.5, 0.5);
	vec2 offset = uv - center;

	float dist = length(offset);

	vec2 distorted_uv = center + offset * (1.0 + dist * dist * distortion_strength * 8.0);

	vec4 screen_color = texture(screen_texture, distorted_uv);

	float pulse = sin(TIME * 2.2) * pulse_strength;

	float vignette = smoothstep(vignette_radius + pulse, vignette_radius - 0.35 + pulse, dist);
	float darkness = 1.0 - vignette;

	screen_color.rgb *= 1.0 - darkness * vignette_strength;

	float center_glow = smoothstep(0.55, 0.0, dist) * center_light;
	screen_color.rgb += center_glow;

	float grain = random(uv * TIME * 30.0) * grain_strength;
	screen_color.rgb += grain;

	COLOR = screen_color;
}