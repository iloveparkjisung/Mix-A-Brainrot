extends Node3D
@export var money_per_second := 15.0
@export var sell_price := 175
var stored_money := 0.0
var hatching_platform = null
var held := false
func _process(delta: float) -> void:
	if held:
		return
	stored_money += money_per_second * delta
	print(int(stored_money))

func set_hatching_platform(platform) -> void:
	hatching_platform = platform

func pick_up():
	held = true
	
	if hatching_platform != null:
		hatching_platform.remove_brainrot()
		hatching_platform = null

func place_on_platform(platform):
	held = false
	hatching_platform= platform
