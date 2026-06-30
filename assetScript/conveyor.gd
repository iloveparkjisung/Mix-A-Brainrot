extends Node3D
@export var speed := 2.0


func _process(delta) -> void:
	for child in $Path3D.get_children():
		if child is PathFollow3D:
			child.progress += speed * delta
	
	pass
