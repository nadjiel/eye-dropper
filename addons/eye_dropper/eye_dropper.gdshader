shader_type canvas_item;

/**
 * The [code]palette_array_size[/code] constant specifies how much colors the [code]input_palette_array[/code] and [code]output_palette_array[/code] properties should store.
 * Since the size of arrays in shaders must be constant, this can't be exported to be edited in the editor, so it is expected that you hardcode this manually to attend your needs.
 */
const uint palette_array_size = uint(4);

/**
 * The [code]palette_size[/code] property must specify how much colors the [code]input_palette_texture[/code] and [code]output_palette_texture[/code] properties store.
 */
uniform uint palette_size = 0;

/**
 * The [code]input_palette_texture[/code] property should store a texture with a color palette.
 * This palette should be organized as a row of pixels, each one storing a color.
 * The amount of pixels this texture is supposed to have is the number that you inform in the [code]palette_size[/code] property.
 * If found in the original texture, the color of each pixel of this palette is replaced in that texture by the color of same position in the [code]output_palette_texture[/code].
 */
uniform sampler2D input_palette_texture;

/**
 * The [code]output_palette_texture[/code] property should store a texture with a color palette.
 * This palette should be organized as a row of pixels, each one storing a color.
 * The amount of pixels this texture is supposed to have is the number that you inform in the [code]palette_size[/code] property.
 * The color of each pixel of this palette is used to replace the color of same position in the [code]input_palette_texture[/code], if found in the original texture.
 */
uniform sampler2D output_palette_texture;

/**
 * The [code]input_palette_array[/code] property stores an array with the colors that should be replaced by others, if found in the base texture.
 * The colors that will replace the ones specified here are the colors stored in the [code]output_palette_array[/code] property.
 * What color will replace what color is determined by the index of such colors: the colors in the same index in both arrays are the ones that will be switched.
 */
uniform vec4 input_palette_array[palette_array_size]: source_color;

/**
 * The [code]output_palette_array[/code] property stores an array with the colors that will replace the others, if found in the base texture.
 * The colors that will be replaced by the ones specified here are the colors stored in the [code]input_palette_array[/code] property.
 * What color will replace what color is determined by the index of such colors: the colors in the same index in both arrays are the ones that will be switched.
 */
uniform vec4 output_palette_array[palette_array_size]: source_color;

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
 * The [code]find_color_in_palette_texture[/code] function tries to find a
 * [param color] in a [param palette] texture with size [param size].
 * To do so, this function iterates over the palette trying to find a
 * color that matches the desired one.
 * If such color is not found, this function returns [code]-1.0[/code] as its
 * result. If the color is found, the coordinate of this color in the texture
 * (from [code]0.0[/code] to [code]1.0[/code]) is returned.
 */
float find_color_in_palette_texture(vec4 color, sampler2D palette, uint size) {
	for(float i = 0.5; i < float(size); i += 1.0) {
		float palette_coord = i / float(size);
		
		vec4 palette_color = texture(palette, vec2(palette_coord, 0.5));
		
		if(color.rgb == palette_color.rgb) {
			return palette_coord;
		}
	}
	
	return -1.0;
}

/**
 * The [code]get_color_from_palette_texture[/code] function returns what color
 * is in the given [param coord] in the given [param palette].
 * The [param coord] should be between [code]0.0[/code] and [code]1.0[/code]
 * so that the [code]texture[/code] function can be used with it as the x axis
 * of the palette texture to look for.
 */
vec4 get_color_from_palette_texture(float coord, sampler2D palette) {
	return texture(palette, vec2(coord, 0.5));
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
	float palette_coord = find_color_in_palette_texture(
		input_color, input_palette_texture, palette_size
	);
	
	if(compare_floats(palette_coord, -1.0) == 0) {
		return;
	}
	
	output_color.rgb = get_color_from_palette_texture(
		palette_coord,
		output_palette_texture
	).rgb;
}

/**
 * The [code]find_color_in_palette_array[/code] function tries to find a
 * [param color] in a [param palette] array with size
 * [code]palette_array_size[/code].
 * To do so, this function iterates over the palette trying to find a
 * color that matches the desired one.
 * If such color is not found, this function returns [code]-1[/code] as its
 * result. If the color is found, the coordinate of this color in the texture
 * (from [code]0[/code] to [code]palette_array_size - 1[/code]) is returned.
 */
int find_color_in_palette_array(vec4 color, vec4[palette_array_size] palette) {
	for(int i = 0; i < palette.length(); i++) {
		vec4 palette_color = palette[i];
		
		if(color.rgb == palette_color.rgb) {
			return i;
		}
	}
	
	return -1;
}

/**
 * The [code]get_color_from_palette_array[/code] function returns what color
 * is in the given [param coord] in the given [param palette].
 * The [param coord] should be between [code]0[/code] and
 * [code]palette_array_size - 1[/code] so that the color can be got without
 * an out of bounds access to the [code]palette[/code] array.
 */
vec4 get_color_from_palette_array(
	uint coord,
	vec4[palette_array_size] palette
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
	
	output_color.rgb = get_color_from_palette_array(
		uint(palette_coord),
		output_palette_array
	).rgb;
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
