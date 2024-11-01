class_name PositionLockLerpCamera
extends CameraControllerBase

# base speed of vessel is 50.0, but hyper speed is 300.0
# access speed by target.velocity

@export var follow_speed:float = 1.0
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 10.0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	#draw_camera_logic
	if true:
		draw_logic()

	var distance_to_target = Vector2(position.x, position.z).distance_to(Vector2(target.position.x, target.position.z))

	var direction_to_target = (Vector2(target.position.x, target.position.z) - Vector2(global_position.x, global_position.z)).normalized()
	# moving
	if abs(target.velocity.x) > 0 or abs(target.velocity.z) > 0:
		if distance_to_target < leash_distance:
			global_position.x += direction_to_target.x * follow_speed * delta
			global_position.z += direction_to_target.y * follow_speed * delta
		else:
			global_position.x = target.position.x - direction_to_target.x * leash_distance
			global_position.z = target.position.z - direction_to_target.y * leash_distance
	else:
		global_position.x += (target.position.x - global_position.x) * catchup_speed * delta
		global_position.z += (target.position.z - global_position.z) * catchup_speed * delta

	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var cross_length: float = 5.0
	var half_length: float = cross_length / 2

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# vertical line
	# bottom half
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -half_length)) 
	# top half
	immediate_mesh.surface_add_vertex(Vector3(0, 0, half_length))   
	# horizontal line
	# left half
	immediate_mesh.surface_add_vertex(Vector3(-half_length, 0, 0))  
	# right half
	immediate_mesh.surface_add_vertex(Vector3(half_length, 0, 0))  

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
