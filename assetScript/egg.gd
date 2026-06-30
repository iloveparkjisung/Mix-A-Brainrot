extends PathFollow3D
@export var speed := 2.0

func _process(delta: float) -> void:
	progress += speed * delta
	
	if progress_ratio >= 1.0:
		queue_free()
