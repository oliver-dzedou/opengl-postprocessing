package dithering

import "../graphics"

@(private)
dithering := cstring(#load("dithering.glsl"))
@(private)
dithering_loaded: graphics.Shader
@(private)
dithering_texture: graphics.Texture

// Runs a dithering pass on the provided scene and returns a dithered scene
pass :: proc(scene: graphics.Texture, res: graphics.Resolution) -> graphics.Texture {
	if !graphics.check_texture_matches_resolution(res, dithering_texture) {
		dithering_texture = graphics.create_texture(res.width, res.height)
	}
	if dithering_loaded.id < 1 {
		dithering_loaded = graphics.load_shader(dithering, "dithering")
	}

	f32_res := graphics.to_f32(res)

	graphics.begin_texture(dithering_texture)
	graphics.begin_shader(dithering_loaded)
	graphics.set_shader_uniform_330(dithering_loaded, "resolution", .VEC2, &f32_res)
	graphics.set_shader_texture_330(dithering_loaded, "scene", scene)
	graphics.rect(res.width, res.height)
	graphics.end_shader()
	graphics.end_texture()
	return dithering_texture
}
