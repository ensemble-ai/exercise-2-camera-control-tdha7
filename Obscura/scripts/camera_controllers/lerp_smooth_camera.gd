class_name LerpSmoothCamera
extends CameraControllerBase

@export var lead_speed:float = 2.5
@export var catchup_delay_duration:float = 1.0
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 10.0

var _timer : float = 0.0
const SCALING_FACTOR = 0.07

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return
	#draw_camera_logic
	if true:
		draw_logic()

	if abs(target.velocity.x) > 0 or abs(target.velocity.z) > 0:
		# reset timer
		_timer = 0.0
		var new_camera_position = target.position + target.velocity.normalized() * target.velocity.length() * SCALING_FACTOR * leash_distance
		global_position = lerp(global_position, new_camera_position, lead_speed * delta) 
	else:
		# start timer
		_timer += delta
		if _timer >= catchup_delay_duration:
			global_position = lerp(global_position, target.position, catchup_speed * delta)
	# fixes position to within leash
	var tpos = Vector3(target.global_position.x, 0.0, target.global_position.z)
	var cpos = Vector3(global_position.x, 0.0, global_position.z)
	var distance_to_target = tpos.distance_to(cpos)
	if distance_to_target - leash_distance > 0.0001:
		global_position += (tpos - cpos).normalized() * (distance_to_target - leash_distance) 
	
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
