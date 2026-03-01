extends MultiMeshInstance2D

@export var tree_count: int = 500
@export var spawn_area: Rect2 = Rect2(0, 0, 1920, 1080)

func _ready() -> void:
	# 1. Tell the MultiMesh how many instances it needs to manage
	multimesh.instance_count = tree_count
	
	# 2. Loop through and place each one
	for i in range(tree_count):
		# Generate a random position within our defined area
		var random_x = randf_range(spawn_area.position.x, spawn_area.end.x)
		var random_y = randf_range(spawn_area.position.y, spawn_area.end.y)
		var pos = Vector2(random_x, random_y)
		
		# 3. Apply the position to the current tree instance
		# Transform2D takes the rotation (0) and the position (pos)
		multimesh.set_instance_transform_2d(i, Transform2D(0, pos))
