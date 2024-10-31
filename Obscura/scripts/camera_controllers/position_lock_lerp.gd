class_name PositionLockLerpCamera
extends CameraControllerBase

# CURRENT ISSUES:
# 1. Sometimes there is jittery behavior. is this ok?
# 2. Why is the distance between target and camera 10.0 instead of 0.0? 
# 2a. The y coordinate for camera is 10+ higher. Why is this?

# base speed of vessel is 50.0, but hyper speed is 300.0
# access speed by target.velocity.x

@export var follow_speed:float = 1.0
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 15.0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	#draw_camera_logic
	if true:
		draw_logic()
		
	
	var distance_to_target = position.distance_to(target.position)
	#if distance_to_target >= 10.0:
		#position.y -= 10.0
		#distance_to_target -= 10.0
	"""
	# why is the distance initially 0 but then it is 10?
	print("Distance:" + str(distance_to_target))
	print("Target position:" + str(target.position.x) + ", " + str(target.position.y) + ", " + str(target.position.z))
	print("Camera position:" + str(position.x) + ", " + str(position.y) + ", " + str(position.z))
	# player is moving
	if (target.velocity.x != 0 or target.velocity.z != 0):
		if distance_to_target > leash_distance:
			position.x += (abs(target.position.x - position.x) - leash_distance) * (target.velocity.x) * delta
			position.z += (abs(target.position.z - position.z) - leash_distance) * (target.velocity.z) * delta
			print("OUT OF RANGE")
		else:
			position.x += (target.position.x - position.x) * follow_speed * delta
			position.z += (target.position.z - position.z) * follow_speed * delta
			print("FOLLOWING")
	# player is not moving
	else: 
		position.x += (target.position.x - position.x) * catchup_speed * delta
		position.z += (target.position.z - position.z) * catchup_speed * delta
		print("CATCHING UP")
	"""
	
	# NOT SURE: if this implementation is correct
	if target.velocity.x != 0 or target.velocity.z != 0:  
		if distance_to_target < leash_distance:
			position = position.lerp(target.position, follow_speed * delta)
		else:
			var direction = (target.position - position).normalized()
			position += direction * (target.position.distance_to(position) - leash_distance) * abs(target.velocity) * delta
			print(distance_to_target)
	else: # Target is not moving, catch up
		position = position.lerp(target.position, catchup_speed * delta)

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
