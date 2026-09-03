extends Node3D
@onready var egg_point = $EggPoint
@onready var hatch_timer = $HatchTimer
@export var money_popup_scene: PackedScene
var egg = null


func place_egg(new_egg):
	if is_instance_valid(egg):
		return false
	egg = null
	
	print("placed ", name)
	if not is_instance_valid(new_egg):
		print("ERROR: new_egg is already freed")
		return false

	if not is_instance_valid(new_egg.egg_parent):
		print("ERROR: egg_parent is already freed")
		return false
	egg = new_egg.egg_parent
	egg.is_hatching  = true
	egg.reparent(self, true)
	new_egg.reparent(egg, true)
	
	new_egg.global_position = egg_point.global_position
	new_egg.global_rotation = egg_point.global_rotation
	
	print("MOVED EGG TO: ", egg.global_position)
	start_hatching()
	print("hatching on",name)
	return true

func start_hatching():
	hatch_timer.wait_time = egg.hatch_time
	hatch_timer.start()
	print("timer started for ", hatch_timer.wait_time, " seconds")

func _on_hatch_timer_timeout() -> void:
	if egg == null:
		return
	print("hatching", egg)
	var egg_to_hatch = egg
	egg = null
	
	var brainrot = egg_to_hatch.hatch()
	
	if brainrot != null:
		$MoneyCollection.set_brainrot(brainrot)
	
