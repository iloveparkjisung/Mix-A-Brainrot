extends Node3D
@export var money_per_second := 39.0
@export var sell_price := 600
var stored_money := 0.0
var hatching_platform = null

func _process(delta: float) -> void:
	stored_money += money_per_second * delta
	print(int(stored_money))

func set_hatching_platform(platform) -> void:
	hatching_platform = platform
