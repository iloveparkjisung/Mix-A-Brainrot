extends Node3D
var brainrot = null

func  set_brainrot(new_brainrot):
	brainrot = new_brainrot

func _ready() -> void:
	await get_parent().child_entered_tree

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("touched")
	if body.is_in_group("player"):
		print("detected")
		collect_money()

func collect_money():
	print("brainrot = ",brainrot)
	if brainrot == null:
		print("nobrainrot")
		return
	print(brainrot.stored_money)
	var amount = roundi(brainrot.stored_money)
	
	if amount <= 0:
		return
		
	GameManager.add_money(amount)
	brainrot.stored_money = 0
	
	print("collected", amount)
