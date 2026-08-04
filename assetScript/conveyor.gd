extends Node3D
@export var speed := 0.5
@export var spawn_delay := 1

@export var common_egg: PackedScene #repeat for every egg type
@export var common_chance := 60
@export var uncommon_egg: PackedScene
@export var uncommon_chance:= 25
@export var rare_egg: PackedScene
@export var rare_chance:= 10
@export var epic_egg: PackedScene
@export var epic_chance:= 4
@export var legendary_egg: PackedScene
@export var legendary_chance:= 1

@onready var path: Path3D = $Path3D

func _process(delta) -> void:
	for child in $Path3D.get_children():
		if child is PathFollow3D:
			child.progress += speed * delta
	
func _ready():
	spawn_loop()

func spawn_loop():
	while true:
		spawn_egg()
		await get_tree().create_timer(spawn_delay).timeout

func spawn_egg():
	var roll = randi_range(1,100)
	print("Roll",roll)
	var chosen_egg: PackedScene
	
	if roll <= common_chance:
		chosen_egg = common_egg
	elif roll <= common_chance + uncommon_chance:
		chosen_egg = uncommon_egg
	elif roll <= common_chance + uncommon_chance + rare_chance:
		chosen_egg = rare_egg
	elif roll <= common_chance + uncommon_chance + rare_chance + epic_chance:
		chosen_egg = epic_egg
	elif roll <= common_chance + uncommon_chance + rare_chance + epic_chance + legendary_chance:
		chosen_egg = legendary_egg
	
	print('Chosen Egg',chosen_egg)
	var egg = chosen_egg.instantiate()
	path.add_child(egg)
	egg.progress_ratio = 0.0
