class_name FrameAutoscrollCamera
extends CameraControllerBase

@export var top_left:Vector2 = Vector2(-5.0, 5.0)
@export var bottom_right:Vector2 = Vector2(5.0, -5.0)
@export var autoscroll_speed:Vector3 = Vector3(0.1, 0.0, 0.0)

var _box_width = bottom_right.x - top_left.x
var _box_height = top_left.y - bottom_right.y


func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()
	
	position += autoscroll_speed
	
	# var tpos = target.global_position
	var cpos = global_position
	
	var left_edge_box_position = cpos.x - _box_width / 2.0
	var right_edge_box_position = cpos.x + _box_width / 2.0
	var top_edge_box_position = cpos.z - _box_height / 2.0
	var bottom_edge_box_position = cpos.z + _box_height / 2.0

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
	
	var left:float = -_box_width / 2
	var right:float = _box_width / 2
	var top:float = -_box_height / 2
	var bottom:float = _box_height / 2
	
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
