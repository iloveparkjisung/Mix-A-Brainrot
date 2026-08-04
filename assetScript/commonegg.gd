extends PathFollow3D
@export var speed := 2.0
@export var brainrot1: PackedScene
@export var brainrot2: PackedScene
@export var brainrot3: PackedScene
@export var brainrot4: PackedScene
@export var brainrot5: PackedScene

@export var brainrot1_chance := 30
@export var brainrot2_chance := 30
@export var brainrot3_chance := 15
@export var brainrot4_chance := 15
@export var brainrot5_chance := 10

func _process(delta: float) -> void:
	progress += speed * delta
	
	if progress_ratio >= 0.5:
		queue_free()

func choose_brainrot():
	var roll = randi_range(1,100)
	if roll <= brainrot1_chance:
		return brainrot1
	elif roll <= brainrot1_chance + brainrot2_chance:
		return brainrot2
	elif roll <= brainrot1_chance + brainrot2_chance + brainrot3_chance:
		return brainrot3
	elif roll <= brainrot1_chance + brainrot2_chance + brainrot3_chance + brainrot4_chance:
		return brainrot4
	elif roll <= brainrot1_chance + brainrot2_chance + brainrot3_chance + brainrot4_chance + brainrot5_chance:
		return brainrot5
		
func hatch():
	var chosen_brainrot = choose_brainrot()
	var new_brainrot = chosen_brainrot.instantiate()
	get_tree().current_scene.add_child(new_brainrot)
	var hatch_point = get_parent().get_node("HatchPoint")
	new_brainrot.global_position = hatch_point.global_position
	queue_free()
	


func _on_hatch_timer_timeout() -> void:
	print("hatched")
