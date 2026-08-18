extends Node3D
var brainrot = null

func  set_brainrot(new_brainrot):
	brainrot = new_brainrot

func _ready() -> void:
	await get_parent().child_entered_tree

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		collect_money()

func collect_money():
	if brainrot == null:
		return
		
	var amount = brainrot.stored_money
	
	if amount <= 0:
		return
		
	GameManager.add_money(amount)
	brainrot.stored_monde = 0
	
