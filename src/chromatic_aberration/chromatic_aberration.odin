package chromatic_aberration

import "../graphics"

@(private)
chromatic_aberration := cstring(#load("chromatic_aberration.glsl"))
@(private)
chromatic_aberration_loaded: graphics.Shader
@(private)
chromatic_aberration_texture: graphics.Texture

// Runs a chromatic aberration pass on the provided scene and returns the aberrated scene
pass :: proc(scene: graphics.Texture, res: graphics.Resolution) -> graphics.Texture {
	if !graphics.check_texture_matches_resolution(res, chromatic_aberration_texture) {
		chromatic_aberration_texture = graphics.create_texture(res.width, res.height)
	}
	if chromatic_aberration_loaded.id < 1 {
		chromatic_aberration_loaded = graphics.load_shader(
			chromatic_aberration,
			"chromatic_aberration",
		)
	}

	f32_res := graphics.to_f32(res)

	graphics.begin_texture(chromatic_aberration_texture)
	graphics.begin_shader(chromatic_aberration_loaded)
	graphics.set_shader_uniform_330(chromatic_aberration_loaded, "resolution", .VEC2, &f32_res)
	graphics.set_shader_texture_330(chromatic_aberration_loaded, "scene", scene)
	graphics.rect(res.width, res.height)
	graphics.end_shader()
	graphics.end_texture()
	return chromatic_aberration_texture
}

destroy :: proc() {
	graphics.unload_shader(&chromatic_aberration_loaded)
	graphics.unload_texture(&chromatic_aberration_texture)
}
