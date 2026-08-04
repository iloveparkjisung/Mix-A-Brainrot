extends Node3D
@onready var egg_point = $EggPoint
var egg = null

func place_egg(new_egg):
	if egg != null:
		return false
	
	egg = new_egg
	egg.reparent(self)
	
	egg.global_position = egg_point.global_position
	egg.global_rotation = egg_point.global_rotation
	
	egg.start_hatching()
	
	return true
