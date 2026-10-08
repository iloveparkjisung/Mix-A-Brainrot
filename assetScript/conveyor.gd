
extends Node3D
@export var speed := 0.5
@export var spawn_delay := 1.0
@export var common_egg: PackedScene
@export var common_chance := 68
@export var uncommon_egg: PackedScene
@export var uncommon_chance := 20
@export var rare_egg: PackedScene
@export var rare_chance := 7
@export var epic_egg: PackedScene
@export var epic_chance := 4
@export var legendary_egg: PackedScene
@export var legendary_chance := 1
@onready var path: Path3D = $Path3D
@onready var spawn_timer: Timer = $SpawnTimer
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	spawn_timer.wait_time = spawn_delay
	spawn_timer.one_shot = false
	spawn_timer.autostart = false
	spawn_timer.timeout.connect(spawn_egg)
	spawn_timer.start()

func _process(delta: float) -> void:
	for child in path.get_children():
		if child is PathFollow3D:
			child.progress += speed * delta
			if child.progress_ratio >= 0.5:
				child.queue_free()

func spawn_egg():
	var roll = randi_range(1, 100)
	var chosen_egg: PackedScene = null
	if roll <= common_chance:
		chosen_egg = common_egg
	elif roll <= common_chance + uncommon_chance:
		chosen_egg = uncommon_egg
	elif roll <= common_chance + uncommon_chance + rare_chance:
		chosen_egg = rare_egg
	elif roll <= common_chance + uncommon_chance + rare_chance + epic_chance:
		chosen_egg = epic_egg
	else:
		chosen_egg = legendary_egg
	if chosen_egg == null:
		push_warning("An egg scene has not been assigned!")
		return
	var egg = chosen_egg.instantiate()
	path.add_child(egg)
	egg.progress_ratio = 0.0
