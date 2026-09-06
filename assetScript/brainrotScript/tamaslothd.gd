extends Node3D
@export var money_per_second := 15.0
var stored_money := 0.0

func _process(delta: float) -> void:
	stored_money += money_per_second * delta
	print(int(stored_money))
