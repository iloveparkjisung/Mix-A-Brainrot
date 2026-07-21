extends PathFollow3D
@export var speed := 2.0

func _process(delta: float) -> void:
	progress += speed * delta
	
	if progress_ratio >= 0.5:
		queue_free()
