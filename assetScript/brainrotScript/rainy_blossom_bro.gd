extends Node3D
@export var money_per_second := 10
var stored_money := 0.0
var popup_timer := 0.0

func _process(delta: float) -> void:
	stored_money += money_per_second * delta
	popup_timer += delta
	
	if popup_timer >= 1.0:
		var amount = int(stored_money)
		if amount > 0:
			stored_money -= amount
			print("making pop", amount)
			var platform = get_parent()
			
			if platform.has_method("show_money_popup"):
				print("found platform")
				platform.show_money_popup(amount)
			else:
				print("no pop",platform.name)
				
		popup_timer = 0.0
	
	print(int(stored_money))
