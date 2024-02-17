extends Node
@export_subgroup("Discord SDK")
@export var dsdk_enabled = true # Is SDK Enabled
@export var _appId = 1208250381209964594 # Application ID

@export var _details = "Exploring the Gift Plane" # Text 2
@export var _state = "0/10 Pets" # Text 3 (smaller)
@export var _large_image = "main" # Image
@export var _large_image_text = "Petscop" # Text on hover
@export var _small_image = "" # Smaller icon
@export var _small_image_text = "" # Text on hover
@export_subgroup("Level Settings")
@export var room_name = ""
@export var loading_preset=""
@export var background_music_id = 0
@export var fade_color: Color
@export var level_slogan = ""
@export var school_preset = false
@export_subgroup("Limit Camera")
@export var limit_camera_horizontal = false
@export var horizontal_limit = Vector2.ZERO
@export var limit_camera_front = false
@export var front_limit = Vector2.ZERO
@export var limit_camera_vertical = false
@export var vertical_limit = Vector2.ZERO
@export_subgroup("Camera_properties")
@export var allow_horizontal_movement = true
@export var allow_front_movement = true
@export var allow_vertical_movement = true
@export var camera_height = 0.
@export var camera_distance = 0.
@export var change_camera_angle = false
@export var camera_angle = 0.
@export var camera_root_offset_y = 0.
@export_subgroup("Max distance from guardian")
@export var horizontal_max_limit = 0.
@export var front_max_limit = 0.
@export var vertical_max_limit = 0.
@export_subgroup("Environment")

## Vector4(R, G, B, A); 0-1
@export var enable_fog = true #false
@export var texture_background = false
@export var texture: Texture2D
@export var scroll_speed = 0.25
#@export var sky_and_fog_color = Vector4.ZERO #Vector4.ZERO
@export var fog_color = Vector4(1, 1, 1.0, 1.0) #Vector4.ZERO
@export var sky_color = Vector4(1, 1, 1.0, 1.0) #Vector4.ZERO
@export var fog_radius = 50.
@export var ambient_color = Color(1., 1., 1.,1.0)
@export var environment_darkness = 0.
@export var set_custom_fog_focus = false
@export var set_fog_focus = Vector3.ZERO
@export_subgroup("Hardcoded Preset")
@export var preset = 1
#1 = EVENCARE/GIFTPLANE
#2 = NMP

func _ready():
	Global.room_name = room_name
	Global.loading_preset = loading_preset
	get_tree().paused=false
	get_tree().get_first_node_in_group("level_slogan").text = level_slogan.replace("*","\n")
	get_tree().get_first_node_in_group("loading_overlay").get_child(0).color=fade_color
	if Global.camera_dist_ver!=camera_height || camera_height>0.:
		Global.camera_dist_ver = camera_height
	if Global.camera_dist_hor!=camera_distance || camera_distance>0.:
		Global.camera_dist_hor = camera_distance
	if Global.camera_move_x!=allow_horizontal_movement:
		Global.camera_move_x=allow_horizontal_movement
	if Global.camera_move_y!=allow_vertical_movement:
		Global.camera_move_y=allow_vertical_movement
	if Global.camera_move_z!=allow_front_movement:
		Global.camera_move_z=allow_front_movement
	if Global.camera_limit_x!=horizontal_max_limit && horizontal_max_limit>0.:
		Global.camera_limit_x=horizontal_max_limit
	if Global.camera_limit_y!=vertical_max_limit && vertical_max_limit>0.:
		Global.camera_limit_y=vertical_max_limit
	if Global.camera_limit_z!=front_max_limit && front_max_limit>0.:
		Global.camera_limit_z=front_max_limit
	
	if limit_camera_horizontal:
		Global.cam_move_limit_x.x=horizontal_limit.x
		Global.cam_move_limit_x.y=horizontal_limit.y
	else:
		Global.cam_move_limit_x=Vector2.ZERO
	
	if limit_camera_front:
		Global.cam_move_limit_z.x=front_limit.x
		Global.cam_move_limit_z.y=front_limit.y
	else:
		Global.cam_move_limit_z=Vector2.ZERO
	
	if limit_camera_vertical:
		Global.cam_move_limit_y.x=vertical_limit.x
		Global.cam_move_limit_y.y=vertical_limit.y
	else:
		Global.cam_move_limit_y=Vector2.ZERO
	
	if camera_height!=0.0:
		Global.camera_dist_ver=camera_height
	else:
		Global.camera_dist_ver=4
		
	if camera_distance!=0.0:
		Global.camera_dist_hor=camera_distance
	else:
		Global.camera_dist_hor=12
	
	if camera_root_offset_y!=0.0:
		Global.camera_root_dist_verhor=camera_root_offset_y
		
	if change_camera_angle:
		Global.camera_rot = camera_angle
	else:
		Global.camera_rot = -18
		
	if school_preset:
		Global.control_mode=3
		
	if set_custom_fog_focus:
		Global.fog_focus=-1
		RenderingServer.global_shader_parameter_set("player_pos", set_fog_focus)
	
	
	if ambient_color!=Color(0., 0., 0.,1.0):
		$skybox.get_environment().set_ambient_light_color(ambient_color)
	else:
		$skybox.get_environment().set_ambient_light_color(Color(0.89, 0.89, 0.89,1.0))
	
	if environment_darkness!=0.:
		$skybox.get_environment().ambient_light_energy = environment_darkness
	else:
		$skybox.get_environment().ambient_light_energy = 0.73
	
	if enable_fog:
		RenderingServer.global_shader_parameter_set("fog_enable", true)
		if fog_color!=Vector4(0.,0.,0.,0.):
		#SETS FOG COLOR AND FOG RADIUS AS GAME RUNS
			RenderingServer.global_shader_parameter_set("fog_color", fog_color)
			#RenderingServer.global_shader_parameter_set("modulate_color", Color(1, 1, 1, 0))
			if fog_radius!=0.:
				RenderingServer.global_shader_parameter_set("sphere_size", fog_radius)
			else:
				RenderingServer.global_shader_parameter_set("sphere_size", 13.5)
		else:
			RenderingServer.global_shader_parameter_set("fog_color", Vector4.ZERO)
			$skybox.get_environment().set_bg_color(Color(0.,0.,0.,0.))
			if fog_radius!=0.:
				RenderingServer.global_shader_parameter_set("sphere_size", fog_radius)
			else:
				RenderingServer.global_shader_parameter_set("sphere_size", 13.5)
	else:
		RenderingServer.global_shader_parameter_set("fog_enable", false)
	
	if sky_color!=Vector4(0.,0.,0.,0.):
		$skybox.get_environment().set_bg_color(Color(sky_color.x,sky_color.y,sky_color.z,sky_color.w))
	
	if !texture_background:
		$background/color.visible=true
		$background/texture.visible=false
		$background/color.color = Color(sky_color.x,sky_color.y,sky_color.z,1.0)
	else:
		$background/color.visible=false
		$background/texture.visible=true
		if texture!=null:
			$background/texture.texture=texture
		$background/texture.get_material().set_shader_parameter("scroll_speed",scroll_speed)
	bg_music.play_track(background_music_id)
	
	if dsdk_enabled:
		DiscordSDK.app_id = _appId
		DiscordSDK.details = _details
		DiscordSDK.state = _state
		
		DiscordSDK.large_image = _large_image # Image key from "Art Assets"
		DiscordSDK.large_image_text = _large_image_text
		DiscordSDK.small_image = _small_image # Image key from "Art Assets"
		DiscordSDK.small_image_text = _small_image_text

		DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
		# DiscordSDK.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

		DiscordSDK.refresh() # Always refresh after changing the values!
	
