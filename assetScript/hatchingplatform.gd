extends Node3D
@onready var egg_point = $EggPoint
var egg = null

func place_egg(new_egg):
	if egg != null:
		return false
	
	print("placed",name)
	
	var egg_path = egg.get_parent()
	egg_path.is_hatching = true
	
	egg = new_egg
	egg.reparent(self)
	
	egg.global_position = egg_point.global_position
	egg.global_rotation = egg_point.global_rotation
	
	egg.set_hatching_platform(self)
	print("hatching on",name)
	egg.start_hatching()
	
	return true
	
func clear_egg():
	egg = null
	print("clear",name)
