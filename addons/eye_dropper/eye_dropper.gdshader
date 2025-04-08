shader_type canvas_item;

/**
 * The [code]max_palette_array_size[/code] constant specifies how much colors the [code]input_palette_array[/code] and [code]output_palette_array[/code] properties should store at maximum.
 * Since the size of arrays in shaders must be constant, this can't be exported to be edited in the editor, so it is expected that you hardcode this manually to attend your needs.
 */
const uint max_palette_array_size = uint(8);

/**
 * The [code]palette_array_size[/code] property stores how much colors there actually are in the palette arrays.
 * Letting this property as [code]0[/code] will make it so the palette arrays aren't used at all, which is useful so that when there aren't any colors defined there, transparent colors aren't replaced.
 * This property should be kept between [code]0[/code] and [code]max_palette_array_size[/code], but to avoid errors it is always clamped when used.
 */
uniform uint palette_array_size = uint(0);

/**
 * The [code]input_palette_texture[/code] property should store a texture with a color palette.
 * This palette should be organized as a grid of pixels (transparent colors count), each one storing a color.
 * If found in the original texture, the color of each pixel of this palette is replaced by the color of same position in the [code]output_palette_texture[/code].
 * If this palette texture is set, but the [code]output_palette_texture[/code] is not, the shader will try to replace the target colors with that empty texture, which should be avoided.
 * If you wish to let this property set to a palette without affecting the end result, just set the [code]output_palette_texture[/code] to the same palette.
 */
uniform sampler2D input_palette_texture: filter_nearest;

/**
 * The [code]output_palette_texture[/code] property should store a texture with a color palette.
 * This palette should be organized as a grid of pixels (transparent colors count), each one storing a color.
 * For proper functioning, this texture should have the same size as the [code]input_palette_texture[/code].
 * The color of each pixel of this palette is used to replace the color of same position in the [code]input_palette_texture[/code], if found in the original texture.
 */
uniform sampler2D output_palette_texture: filter_nearest;

/**
 * The [code]input_palette_array[/code] property stores an array with the colors that should be replaced by other colors, if found in the base texture.
 * This array is only used if the [code]palette_array_size[/code] property is greater than [code]0[code].
 * The colors that will replace the ones specified here are the colors stored in the [code]output_palette_array[/code] property.
 * What color will replace what color is determined by the index of such colors: the colors in the same index in both arrays are the ones that will be switched.
 * If there's a color in this array that doesn't have a pair in the [code]output_palette_array[/code], such color is replaced by full transparency.
 * Also, any empty values in this array are considered as fully transparent colors.
 */
uniform vec4 input_palette_array[max_palette_array_size]: source_color;

/**
 * The [code]output_palette_array[/code] property stores an array with the colors that will replace the other mapped colors found in the base texture.
 * This array is only used if the [code]palette_array_size[/code] property is greater than [code]0[code].
 * The colors that will be replaced by the ones specified here are the colors stored in the [code]input_palette_array[/code] property.
 * What color will replace what color is determined by the index of such colors: the colors in the same index in both arrays are the ones that will be switched.
 * Also, any empty values in this array are considered as fully transparent colors.
 */
uniform vec4 output_palette_array[max_palette_array_size]: source_color;

/**
 * The [code]compare_floats[/code] function receives two [code]float[/code]
 * numbers [param a] and [param b] and returns an [code]int[/code] indicating
 * if those values are equal, less than or greater than one another.
 * If they are approximately equal, this function returns [code]0[/code],
 * if [param a] is greater than [param b], this function returns [code]1[/code],
 * and if [param a] is less than [param b], this function returns
 * [code]-1[/code].
 */
int compare_floats(float a, float b) {
	float difference = a - b;
	
	if(abs(difference) < 0.0001) {
		return 0;
	} else if(difference > 0.0) {
		return 1;
	} else {
		return -1;
	}
}

/**
 * Compares two colors ([param a] and [param b]), and tells if they are
 * approximately equal, based on an epsilon of [code]0.001[/code].
 * If the colors match, [code]true[/code] is returned, else, this function
 * returns [code]false[/code].
 * This code was adapted from
 * [url=https://forum.godotengine.org/t/shader-wont-work-during-runtime/53299/4]Calinou's post on the Godot forum[/url].
 */
bool color_is_approx_equal(vec4 a, vec4 b) {
	if (
	    a.r >= b.r - 0.001 && a.r <= b.r + 0.001 &&
	    a.g >= b.g - 0.001 && a.g <= b.g + 0.001 &&
	    a.b >= b.b - 0.001 && a.b <= b.b + 0.001 && 
	    a.a >= b.a - 0.001 && a.a <= b.a + 0.001
	) {
		return true;
	}
	
	return false;
}

/**
 * The [code]color_is_transparent[/code] function is a utility function that
 * returns a [code]bool[/code] indicating if the received [param color] is
 * fully transparent.
 */
bool color_is_transparent(vec4 color) {
	return compare_floats(color.a, 0.0) == 0;
}

/**
 * The [code]find_color_in_palette_texture[/code] function tries to find a
 * [param color] in a [param palette] texture.
 * To do so, this function iterates over the palette trying to find a
 * color that matches the desired one (fully transparent colors are considered
 * equal, and when comparing other colors the opacity is taken into account).
 * If such color is not found, this function returns a [code]vec2(-1.0)[/code]
 * as its result. If the color is found, the coordinate of this color in the
 * texture (from [code]vec2(0.0)[/code] to [code]vec2(1.0)[/code]) is returned.
 */
vec2 find_color_in_palette_texture(vec4 color, sampler2D palette) {
	ivec2 palette_size = textureSize(palette, 0);
	
	for(uint y = uint(0); y < uint(palette_size.y); y++) {
		for(uint x = uint(0); x < uint(palette_size.x); x++) {
			vec2 palette_coord = vec2(
				float(x) / float(palette_size.x),
				float(y) / float(palette_size.y)
			);
			
			vec4 palette_color = texture(palette, palette_coord);
			
			if(color == palette_color) {
				return palette_coord;
			}
			if(
				color_is_transparent(color) &&
				color_is_transparent(palette_color)
			) {
				return palette_coord;
			}
		}
	}
	
	return vec2(-1.0);
}

/**
 * The [code]get_color_from_palette_texture[/code] function returns what color
 * is in the given [param coord] in the given [param palette].
 * The [param coord] should be between [code]vec2(0.0)[/code] to
 * [code]vec2(1.0)[/code] so that the [code]texture[/code]
 * function can be used with it as the coordinates to look for.
 */
vec4 get_color_from_palette_texture(vec2 coord, sampler2D palette) {
	return texture(palette, coord);
}

/**
 * The [code]swap_colors_from_palette_textures[/code] function takes a
 * [param input_color] and an [param output_color].
 * This function then modifies the [param output_color],
 * if the [param input_color] is mapped in the
 * [code]input_palette_texture[/code], so that it matches the corresponding
 * [code]output_palette_texture[/code] color.
 */
void swap_colors_from_palette_textures(
	vec4 input_color,
	inout vec4 output_color
) {
	vec2 palette_coord = find_color_in_palette_texture(
		input_color, input_palette_texture
	);
	
	if(palette_coord == vec2(-1.0)) {
		return;
	}
	
	output_color = get_color_from_palette_texture(
		palette_coord,
		output_palette_texture
	);
}

/**
 * The [code]find_color_in_palette_array[/code] function tries to find a
 * [param color] in a [param palette] array with size
 * [code]max_palette_array_size[/code].
 * Such search is only made between the [code]0[/code] and
 * [code]palette_array_size[/code] indexes, so that undefined colors aren't
 * considered.
 * To find the desired color, this function iterates over the palette trying to find a
 * color that matches the desired one (fully transparent colors are considered
 * equal, and when comparing other colors the opacity is taken into account).
 * If such color is not found, this function returns [code]-1[/code] as its
 * result. If the color is found, the coordinate of this color in the texture
 * (from [code]0[/code] to [code]max_palette_array_size - 1[/code]) is returned.
 */
int find_color_in_palette_array(vec4 color, vec4[max_palette_array_size] palette) {
	int safe_palette_array_size = int(clamp(
		palette_array_size,
		0,
		max_palette_array_size
	));
	
	for(int i = 0; i < safe_palette_array_size; i++) {
		vec4 palette_color = palette[i];
		
		if(color_is_approx_equal(color, palette_color)) {
			return i;
		}
		if(color_is_transparent(color) && color_is_transparent(palette_color)) {
			return i;
		}
	}
	
	return -1;
}

/**
 * The [code]get_color_from_palette_array[/code] function returns what color
 * is in the given [param coord] in the given [param palette].
 * The [param coord] should be between [code]0[/code] and
 * [code]max_palette_array_size - 1[/code] so that the color can be got without
 * an out of bounds access to the palette array.
 */
vec4 get_color_from_palette_array(
	uint coord,
	vec4[max_palette_array_size] palette
) {
	return palette[coord];
}

/**
 * The [code]swap_colors_from_palette_arrays[/code] function takes a
 * [param input_color] and an [param output_color].
 * This function then modifies the [param output_color],
 * if the [param input_color] is mapped in the
 * [code]input_palette_array[/code], so that it matches the corresponding
 * [code]output_palette_array[/code] color.
 */
void swap_colors_from_palette_arrays(
	vec4 input_color,
	inout vec4 output_color
) {
	int palette_coord = find_color_in_palette_array(
		input_color,
		input_palette_array
	);
	
	if(palette_coord == -1) {
		return;
	}
	
	output_color = get_color_from_palette_array(
		uint(palette_coord),
		output_palette_array
	);
}

/*
 * This function is executed for every pixel of the base texture on which
 * this shader is being applied. For every one of those pixels, this function
 * tries to figure out if its color is mapped in an input palette and
 * tries to replace such color with its corresponding one in an output palette.
 * Such operations are done with the palette textures first and then with
 * the palette arrays so that the arrays are prioritized over the textures,
 * when applicable.
 */
void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	vec4 output_color = texture(TEXTURE, UV);
	
	swap_colors_from_palette_textures(input_color, output_color);
	swap_colors_from_palette_arrays(input_color, output_color);
	
	COLOR = output_color;
}
