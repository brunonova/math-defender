extends Control
# Area to move and shoot with the mouse or touch

export(int, 0, 3) var position_index = 0
export(NodePath) var player_nodepath

onready var _player = get_node(player_nodepath) as Player


func _on_MouseAreaPlayer_mouse_entered() -> void:
	#_player.move_to_position_index(position_index)
	pass


func _on_MouseAreaPlayer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			_player.move_to_position_index(position_index)
			_player.shoot()
