extends Node3D

@onready var platform1 = $InputPatform/Platform
@onready var platform2 = $InputPatform/Platform2
@onready var mix_button = $UI/Panel/MixButton

var can_mix := false
var current_recipe = null
var recipes =[
	{
		"ingredients": ["SkySeaSimp", "RainyBlossom"],
		"result": "FlowStateGoblin",
		"scene": "res://assetFile/brainrotCharacters/FlowStateGoblin.tscn"
	}
]
func _ready():
	mix_button.visible = false
	mix_button.pressed.connect(_on_mix_button_pressed)

func _process(_delta):
	check_recipe()
	
func check_recipe():
	var brainrot1 = platform1.brainrot
	var brainrot2 = platform2.brainrot
	
	if brainrot1 == null or brainrot2 == null:
		can_mix = false
		mix_button.visible = false
		return
	var _valid_recipe = false
	
	#making da recipe
	for recipe in recipes:
		var ingredients = recipe["ingredients"]
		if (
			(brainrot1.name == ingredients[0] and brainrot2.name == ingredients[1])
			or
			(brainrot1.name == ingredients[1] and brainrot2.name == ingredients[0])
		):
		
			can_mix = true
			current_recipe = recipe
			mix_button.visible = true
			return

func _on_mix_button_pressed():
	if not can_mix or current_recipe == null:
		return
	var _brainrot1 = platform1.remove_brainrot()
	var _brainrot2 = platform2.remove_brainrot()
	if _brainrot1 == null or _brainrot2 == null:
		return
	_brainrot1.queue_free()
	_brainrot2.queue_free()

	create_result(current_recipe)

	can_mix = false
	current_recipe = null
	mix_button.visible = false

func create_result(recipe):
	var _scene = load(recipe["scene"])
	if _scene == null:
		print ("could not load screen")
		return
	var new_brainrot = _scene.instantiate()
	$ResultPlatform.add_child(new_brainrot)
	new_brainrot.position = $ResultPlatform/BrainrotPoint.position
	new_brainrot.rotation = Vector3.ZERO
