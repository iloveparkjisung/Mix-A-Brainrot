extends Node3D
@export var speed := 0.5
@export var spawn_delay := 1
@export var egg_scene: PackedScene
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
	var egg = egg_scene.instantiate()
	path.add_child(egg)
	egg.progress_ratio = 0.0
