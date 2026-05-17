shader_type canvas_item;

uniform float hover_strength : hint_range(0.0, 1.0) = 0.0;
uniform vec4 glow_color : source_color = vec4(0.85, 0.05, 0.04, 1.0);
uniform float scan_strength : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec2 uv = UV;

	// Distancia al centro del rectángulo.
	vec2 center = vec2(0.5, 0.5);
	float dist = length(uv - center);

// Brillo que se desvanece desde el centro hacia afuera.
float glow = smoothstep(0.75, 0.05, dist);

// Desvanecimiento extra en bordes para que no parezca rectángulo.
float edge_fade_x = smoothstep(0.0, 0.18, uv.x) * smoothstep(1.0, 0.82, uv.x);
float edge_fade_y = smoothstep(0.0, 0.25, uv.y) * smoothstep(1.0, 0.75, uv.y);
float edge_fade = edge_fade_x * edge_fade_y;

// Scanlines muy suaves.
float scan = sin((uv.y * 65.0) + TIME * 4.0) * 0.5 + 0.5;
scan *= scan_strength;

// Pulso muy ligero.
float pulse = sin(TIME * 3.0) * 0.5 + 0.5;

// Alpha más bajo para que sea menos brillante.
float alpha = hover_strength * edge_fade * (glow * 0.18 + scan * 0.04 + pulse * 0.035);

COLOR = vec4(glow_color.rgb, alpha);
}