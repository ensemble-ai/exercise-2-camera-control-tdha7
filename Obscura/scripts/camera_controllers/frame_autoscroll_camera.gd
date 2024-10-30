class_name FrameAutoscrollCamera
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0
# idk what I am supposed to do here for the variables
@export var top_left:Vector2
@export var bottom_right:Vector2
# only control x and z
@export var autoscroll_speed:Vector3 = Vector3(0.1, 0.0, 0.0)

func _process(delta: float) -> void:
	if !current:
		return
	# draw_camera_logic
	if true:
		draw_logic()
	
	position += autoscroll_speed
	
	# var tpos = target.global_position
	var cpos = global_position
	
	var left_edge_box_position = cpos.x - box_width / 2.0
	var right_edge_box_position = cpos.x + box_width / 2.0
	var top_edge_box_position = cpos.z - box_height / 2.0
	var bottom_edge_box_position = cpos.z + box_height / 2.0

	if target.global_position.x - target.RADIUS < left_edge_box_position:
		target.global_position.x = left_edge_box_position + target.RADIUS  
	if target.global_position.x + target.RADIUS > right_edge_box_position:
		target.global_position.x = right_edge_box_position - target.RADIUS 
	if target.global_position.z - target.RADIUS < top_edge_box_position:
		target.global_position.z = top_edge_box_position + target.RADIUS 
	if target.global_position.z + target.RADIUS > bottom_edge_box_position:
		target.global_position.z = bottom_edge_box_position - target.RADIUS  

	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
