class_name FourWaySpeedZone
extends CameraControllerBase

@export var push_ratio:float = 0.9
@export var pushbox_top_left:Vector2 = Vector2(-12.0, 8.0)
@export var pushbox_bottom_right:Vector2 = Vector2(12.0, -8.0)
@export var speedup_zone_top_left:Vector2 = Vector2(-5.0, 3.0)
@export var speedup_zone_bottom_right:Vector2 = Vector2(5.0, -3.0)


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()
	
	var tpos = Vector3(target.global_position.x, 0.0, target.global_position.z)
	var cpos = Vector3(global_position.x, 0.0, global_position.z)
	
	#boundary checks
	#left and right
	var diff_between_left_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_top_left.x)
	var diff_between_right_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x + pushbox_bottom_right.x)
	var diff_between_left_push = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedup_zone_top_left.x)
	var diff_between_right_push = (tpos.x - target.WIDTH / 2.0) - (cpos.x + speedup_zone_bottom_right.x)
	# check for either side
	if (diff_between_left_push < 0.0 and target.velocity.x < 0.0) or (diff_between_right_push > 0.0 and target.velocity.x > 0.0):
		if diff_between_left_edges < 0.0 or diff_between_right_edges > 0.0:
			# move at target speed
			global_position.x += target.velocity.x * delta
		else:
			global_position.x += target.velocity.x * delta * push_ratio
	
	# top and down
	var diff_between_top_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z - pushbox_top_left.y)
	var diff_between_bottom_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_bottom_right.y)
	var diff_from_top_push = (tpos.z + target.WIDTH / 2.0) - (cpos.z - speedup_zone_top_left.y)
	var diff_from_bottom_push = (tpos.z - target.WIDTH / 2.0) - (cpos.z - speedup_zone_bottom_right.y)
	
	if (diff_from_top_push < 0.0 and target.velocity.z < 0.0) or (diff_from_bottom_push > 0.0 and target.velocity.z > 0.0):
		if diff_between_top_edges < 0.0 or diff_between_bottom_edges > 0.0:
			global_position.z += target.velocity.z * delta
		else:
			global_position.z += target.velocity.z * delta * push_ratio
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# inner box 
	var pushbox_width = pushbox_bottom_right.x - pushbox_top_left.x
	var pushbox_height = pushbox_top_left.y - pushbox_bottom_right.y

	var pushbox_left:float = -pushbox_width / 2.0
	var pushbox_right:float = pushbox_width / 2.0
	var pushbox_top:float = -pushbox_height / 2.0
	var pushbox_bottom:float = pushbox_height / 2.0
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0.0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0.0, pushbox_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0.0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0.0, pushbox_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0.0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0.0, pushbox_top))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0.0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0.0, pushbox_top))
	
	# outer box 
	
	var speedup_width = speedup_zone_bottom_right.x - speedup_zone_top_left.x
	var speedup_height = speedup_zone_top_left.y - speedup_zone_bottom_right.y

	var speedup_left:float = -speedup_width / 2.0
	var speedup_right:float = speedup_width / 2.0
	var speedup_top:float = -speedup_height / 2.0
	var speedup_bottom:float = speedup_height / 2.0
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0.0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0.0, speedup_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0.0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0.0, speedup_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0.0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0.0, speedup_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0.0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0.0, speedup_top))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
