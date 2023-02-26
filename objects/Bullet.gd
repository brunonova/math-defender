class_name Bullet
extends Area2D

# Speed of the bullet
export(float, 5000) var speed = 2000.0


func _process(delta: float) -> void:
	position.y -= speed * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
