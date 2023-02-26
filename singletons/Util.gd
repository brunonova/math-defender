extends Node


# Converts a NodePath array to an array of positions (Vector2's)
func nodepath_array_to_vector2_array(node: Node, array: Array) -> Array:
	var res = []
	for node_path in array:
		res.append(node.get_node(node_path).position)
	return res


# Converts a NodePath array to an array of Nodes
func nodepath_array_to_node_array(node: Node, array: Array) -> Array:
	var res = []
	for node_path in array:
		res.append(node.get_node(node_path))
	return res


# Generates a random integer number between the given limits
func randi_range(minimum: int, maximum: int) -> int:
	return (randi() % (maximum - minimum + 1)) + minimum
