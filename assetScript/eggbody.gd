extends RigidBody3D
var held = false

func _ready() -> void:
	%EggBody.freeze = true


func interact():
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.pick_up(self)
