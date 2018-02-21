uniform int color_type;
uniform sampler2D myTexture;

in vec4 mColor;
in vec2 mTexCoord;
out vec4 fragColor;

#define texture2D texture

/* keep this list synchronized with list in gpencil_engine.h */
#define GPENCIL_COLOR_SOLID   0
#define GPENCIL_COLOR_TEXTURE 1
#define GPENCIL_COLOR_PATTERN 2

void main()
{
	vec2 centered = mTexCoord - vec2(0.5);
	float dist_squared = dot(centered, centered);
	const float rad_squared = 0.25;

	// round point with jaggy edges
	if (dist_squared > rad_squared)
		discard;

	vec4 tmp_color = texture2D(myTexture, mTexCoord);

	/* Solid */
	if (color_type == GPENCIL_COLOR_SOLID) {
		fragColor = mColor;
	}
	/* texture */
	if (color_type == GPENCIL_COLOR_TEXTURE) {
		fragColor =  texture2D(myTexture, mTexCoord);
	}
	/* pattern */
	if (color_type == GPENCIL_COLOR_PATTERN) {
		vec4 text_color = texture2D(myTexture, mTexCoord);
		fragColor = mColor;
		fragColor.a = min(text_color.a, mColor.a);
	}
}
