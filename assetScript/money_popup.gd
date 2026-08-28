extends Node3D
@onready var label = $Label3D

func float_up():
	var tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 1.5, 1.0)
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	
	await tween.finished
	
	queue_free()
