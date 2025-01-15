# Eye Dropper 🎨

![Banner](https://github.com/user-attachments/assets/8d85caed-b37e-4f8d-aef6-630930af9167)

Eye Dropper is a shader (GDShader) that helps with quick color palette swapping easily customizable through shader parameters.

This shader is a `canvas_item` type of shader that was meant, at least initially, to be used with `CanvasItem`s nodes in Godot. Contributions are welcome to make a `3D` version.

With this shader, you can configure your palettes through textures or through color arrays, or even use both options, if it's more convenient to you.

This project is fully documented so that you can understand what each function or property does, just check it out in the `eye_dropper.gdshader` file!

To be able to use the palette arrays with various colors, make sure to tweak the `max_palette_array_size` constant in the shader file so that it attends your project's needs. By default it is set to `4`, which means that only `4` colors are allowed at maximum using the arrays, but, as mentioned, that's easily tweakable.

I hope this shader helps you with your project! :D

*This project was tested with Godot 4.3.

## Contributing
Here are some ways you can contribute to this project:

- If you find a bug, feel free to [create an issue](https://github.com/nadjiel/eye-dropper/issues/new) pointing it out. The more informations the better. Also, including a Minimal Reproduction Project would go a long way;
- If you see an issue that you think you can help with, give it a try! :) The list of issues is in this [link](https://github.com/nadjiel/eye-dropper/issues).
