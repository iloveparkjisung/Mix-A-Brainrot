extends PathFollow3D
var is_hatching = false
@export var price := 150
@export var hatch_time := 3.0
@onready var egg_body = %EggBody
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
	if not is_hatching:
		progress += speed * delta
	
		if progress_ratio >= 0.5:
			queue_free()

func choose_brainrot():
	var roll = randi_range(1,100)
	print(roll)
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
	print("chosenbrainrot",chosen_brainrot)
	var new_brainrot = chosen_brainrot.instantiate()
	print("created")
	get_tree().current_scene.add_child(new_brainrot)
	new_brainrot.global_position = egg_body.global_position + Vector3(0,1,0)
	print("removed")
	
	egg_body.queue_free()
	queue_free()
	return new_brainrot
