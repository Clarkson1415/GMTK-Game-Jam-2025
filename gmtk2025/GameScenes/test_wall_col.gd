extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var query = PhysicsShapeQueryParameters2D.new()
	var areaCollisionShape = null
	for child in get_children():
		if child is CollisionShape2D:
			areaCollisionShape = child
	if areaCollisionShape == null:
		push_error("Area collision shape not found on: " + self.name)
	query.shape = areaCollisionShape.shape
	query.transform = Transform2D(0, global_position)
	query.collision_mask = 4 # walls are on 3. 0b00000100 = layer 3, 3rd bit is set. # walls  # set based on what layers you want to collide with
	var result = get_world_2d().direct_space_state.intersect_shape(query)
	var isCollidingWithWalls = result.size() > 0
	# print("WALL COLLISION tested at = ", nextPosition)
	print("test awll collision = ", isCollidingWithWalls)
	# Remove this Objects Static object? But a wire doesnt have a static object.
