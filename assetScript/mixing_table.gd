extends Node3D

@onready var platform1 = $InputPlatform/Platform
@onready var platform2 = $InputPlatform/Platform2
@onready var mix_button = $UI/Panel/MixLabel
@onready var mix_progress_bar = $UI/Panel/ProgressBar

var can_mix := false
var current_recipe = null

var mix_progress := 0.0
@export var mix_time := 2.0
@onready var ui = $UI
var recipes = [
	{
		"ingredients": ["SkySeaSimp", "RainyBlossomBro"],
		"result": "FlowStateGoblin",
		"scene": "res://assetFile/brainrotCharacters/FlowStateGoblin.tscn"
	}
]

func _ready():
	mix_button.visible = false
	mix_progress_bar.visible = false
	mix_progress_bar.value = 0
	ui.visible = false
	add_to_group("mixing_table")


func _process(delta):
	check_recipe()
	if mix_button.visible and can_mix:
		if Input.is_action_pressed("interact"):
			mix_progress += delta
			mix_button.text = "Mixing..."
			mix_progress_bar.visible = true
			mix_progress_bar.value = (mix_progress / mix_time) * 100.0
			if mix_progress >= mix_time:
				_on_mix_button_pressed()
		else:
			mix_progress = 0.0
			mix_progress_bar.value = 0
			mix_progress_bar.visible = false
			mix_button.text = "Hold [E] to Mix"


func check_recipe():
	var brainrot1 = platform1.brainrot
	var brainrot2 = platform2.brainrot

	if brainrot1 == null or brainrot2 == null:
		can_mix = false
		current_recipe = null
		return

	var id1 = brainrot1.brainrot_id
	var id2 = brainrot2.brainrot_id

	print("MIX CHECK:")
	print("Platform 1: ", id1)
	print("Platform 2: ", id2)

	for recipe in recipes:
		var ingredients = recipe["ingredients"]

		print("Recipe needs: ", ingredients[0], " + ", ingredients[1])

		if (
			(id1 == ingredients[0] and id2 == ingredients[1])
			or
			(id1 == ingredients[1] and id2 == ingredients[0])
		):
			can_mix = true
			current_recipe = recipe
			print("RECIPE MATCH!")
			return

	can_mix = false
	current_recipe = null
	print("NO RECIPE MATCH")

func show_mix_ui():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		mix_button.visible = false
		return
	var ray = player.get_node("Camera3D/RayCast3D")

	if ray == null or not ray.is_colliding():
		mix_button.visible = false
		return

	var target = ray.get_collider()
	var node = target

	while node != null:
		if node == self:
			break
		node = node.get_parent()
	if node != self:
		mix_button.visible = false
		return
	if platform1.brainrot == null or platform2.brainrot == null:
		mix_button.visible = false
		return
	mix_button.visible = true
	mix_progress_bar.visible = true
	if can_mix:
		mix_button.text = "Hold [E] to Mix"
	else:
		mix_button.text = "ERROR: Cannot Mix"
		mix_progress_bar.visible = false


func hide_mix_ui():
	mix_button.visible = false
	mix_progress = 0.0


func _on_mix_button_pressed():

	if not can_mix or current_recipe == null:
		return

	var brainrot1 = platform1.remove_brainrot()
	var brainrot2 = platform2.remove_brainrot()

	if brainrot1 == null or brainrot2 == null:
		return

	brainrot1.queue_free()
	brainrot2.queue_free()

	create_result(current_recipe)

	can_mix = false
	current_recipe = null
	mix_progress = 0.0
	mix_button.visible = false


func create_result(recipe):

	var scene = load(recipe["scene"])

	if scene == null:
		print("Could not load scene")
		return

	var new_brainrot = scene.instantiate()

	$ResultPlatform.add_child(new_brainrot)

	new_brainrot.position = $ResultPlatform/BrainrotResultPoint.position
	new_brainrot.rotation = Vector3.ZERO
