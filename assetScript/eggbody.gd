extends RigidBody3D
@export var egg_parent: PathFollow3D
var held = false
var hatching_platform = null
func _ready() -> void:
	%EggBody.freeze = true


func interact():
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		if GameManager.spend_money(egg_parent.egg_price):
			print("bought", egg_parent.egg_price)
			egg_parent.is_hatching = true
			player.pick_up(self)
		else:
			print("not enough")
