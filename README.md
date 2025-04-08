
<h1 align="center">🎨 Eye Dropper</h1>

![Banner](https://raw.githubusercontent.com/nadjiel/eye-dropper/refs/heads/main/assets/pictures/banner.png)

<p align="center">
  <a href="https://godotengine.org/download/" target="_blank">
    <img alt="Godot v4.3+" src="https://img.shields.io/badge/Godot_v4.3+-%23478cbf?color=478cbf&logo=godotengine&logoColor=ffedf5&style=for-the-badge" />
  </a>
  <a href="LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/nadjiel/eye-dropper?labelColor=ffedf5&color=06d6a0&style=for-the-badge">
  </a>
  <a href="https://github.com/nadjiel/eye-dropper/releases">
    <img alt="Latest Release" src="https://img.shields.io/github/v/release/nadjiel/eye-dropper?labelColor=ffedf5&color=ef476f&style=for-the-badge">
  </a>
  <a href="https://ko-fi.com/nadjiel">
    <img alt="" src="https://img.shields.io/badge/Ko--fi-ffda6e?logo=kofi&color=ffda6e&style=for-the-badge" >
  </a>
</p>

Eye Dropper is a shader for the Godot engine (`GDShader`) that helps with quick color palette swapping easily customizable through shader parameters.

This shader is a `canvas_item` type of shader that was meant, at least initially, to be used with `CanvasItems` nodes in Godot.
[Contributions](https://github.com/nadjiel/eye-dropper/tree/main#handshake-contributing) are welcome to make a version that works with `3D` nodes.

With this shader, you can configure your palettes through `Textures` or through `PackedColorArrays`, or even use both options, if it's more convenient to you.

## :sparkles: Features

### :paintbrush: Palette Swapping
The main purpose of this project is allowing easy color swapping for `CanvasItems` nodes in the Godot engine.
That's achieved with the `eye_dropper.gdshader` script, which exposes handy properties that can be tweaked programatically, or manually in the Godot editor, in order to achieve different palettes dynamically.

<p align="center">
  <img width="80%" alt="Color swapping illustration" src="https://raw.githubusercontent.com/nadjiel/eye-dropper/refs/heads/main/assets/pictures/picture1.png" ><br>
  <em>Illustration of the color swapping process</em>
</p>

For that palette swapping to happen, two important pair of properties are available in the shader parameters: the `input_palette_array` and `output_palette_array` and the `input_palette_texture` and `output_palette_texture`.

Both of these pair of properties serve the same functionality: allowing you to define what colors should be replaced by what colors in the color swapping process.

<p align="center">
  <img alt="Shader parameters screenshot" src="https://raw.githubusercontent.com/nadjiel/eye-dropper/refs/heads/main/assets/pictures/shader_parameters.png" ><br>
  <em>Screenshot of the shader parameters</em>
</p>

The difference between the `Array` based and the `Texture` based properties is that the `Texture` ones are easier if you want to swap quickly from a pre-stablished palette saved in a `Texture` to another one.

The `Array` based, on the other hand makes it easier to swap between palettes that aren't predefined in a texture.
That's useful when you wanna make dynamic color swapping that changes frequently, or even smooth animated color swapping with the use of `Tweens` or `AnimationPlayers`.

There's a catch with the `Array` parameters, though.
To be able to use the palette `Arrays` with various colors, make sure to tweak the `max_palette_array_size` constant in the `eye_dropper.gdshader` file so that it attends your project's needs.

By default, that constant is set to `8`, which means that only `8` colors are allowed at maximum using the `Arrays`, but, as mentioned, that's easily tweakable.

This is implemented that way because, in `GDShaders`, `Arrays` must have a constant initial size predefined, which I decided to let as `8`, initially. 

### :eyeglasses: Transparency support
It's important to note that both the `Texture` and `Array` approaches also support swapping transparent colors, not only opaque ones, so keep that in mind when designing your palettes.

<p align="center">
  <img width="80%" alt="Transparent color swapping support illustration" src="https://raw.githubusercontent.com/nadjiel/eye-dropper/refs/heads/main/assets/pictures/picture3.png" ><br>
  <em>Illustration of the transparent color swapping support</em>
</p>

## :books: Documentation
This project is fully documented so that you can understand what each function or property does, just check it out in the `eye_dropper.gdshader` file!

## :test_tube: Testing
This project was manually tested with `Godot 4.3`. Automatic tests weren't written since `GDShaders` generally can't be tested that way, at least to my knowledge.

## :handshake: Contributing
If you like this project, consider supporting me on [Ko-fi](https://ko-fi.com/nadjiel) so I can keep on making content like this! :D

<p align="center">
  <a href='https://ko-fi.com/J3J71AXVC6' target='_blank'>
    <img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' />
  </a>
</p>

Other than that, here are some ways you can contribute to this project, so that we can improve it together:

- If you found a bug, feel free to [create an Issue](https://github.com/nadjiel/eye-dropper/issues/new) pointing it out. The more informations the better.
Also, including a Minimal Reproduction Project would go a long way;

- If you see an [Issue](https://github.com/nadjiel/eye-dropper/issues) that you think you can help with, give it a try! :)

## Credits
Shader created with :heart: by [@nadjiel](https://github.com/nadjiel)

I hope this shader can help you with your projects! :D
