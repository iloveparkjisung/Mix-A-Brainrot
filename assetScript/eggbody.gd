extends RigidBody3D
@export var egg_parent: PathFollow3D
var held = false
var hatching_platform = null
func _ready() -> void:
	%EggBody.freeze = true


func interact():
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		egg_parent.is_hatching = true
		player.pick_up(self)
