package crt

import "../graphics"

@(private)
crt := cstring(#load("crt.glsl"))
@(private)
crt_loaded: graphics.Shader
@(private)
crt_texture: graphics.Texture

// Runs a CRT pass on the provided scene and returns a CRT'd scene 
pass :: proc(scene: graphics.Texture, res: graphics.Resolution) -> graphics.Texture {
	f32_res := graphics.to_f32(res)

	if !graphics.check_texture_matches_resolution(res, crt_texture) {
		crt_texture = graphics.create_texture(res.width, res.height)
	}
	if crt_loaded.id < 1 {
		crt_loaded = graphics.load_shader(crt, "crt")
	}

	graphics.begin_texture(crt_texture)
	graphics.begin_shader(crt_loaded)
	graphics.set_shader_uniform_330(crt_loaded, "resolution", .VEC2, &f32_res)
	graphics.set_shader_texture_330(crt_loaded, "scene", scene)
	graphics.rect(res.width, res.height)
	graphics.end_shader()
	graphics.end_texture()
	return crt_texture
}

destroy :: proc() {
	graphics.unload_shader(&crt_loaded)
	graphics.unload_texture(&crt_texture)
}
