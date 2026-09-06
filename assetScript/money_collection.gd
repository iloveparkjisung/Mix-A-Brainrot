extends Node3D
var brainrot = null
@onready var money_label = $Label3D

func  set_brainrot(new_brainrot):
	brainrot = new_brainrot

func _ready() -> void:
	await get_parent().child_entered_tree

func _process(delta: float) -> void:
	if brainrot == null:
		money_label.text = "$0"
		return
	money_label.text = "$" + str(int(brainrot.stored_money))
	

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
	brainrot.stored_money = 0
	
