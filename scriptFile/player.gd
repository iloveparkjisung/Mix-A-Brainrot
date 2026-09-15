extends CharacterBody3D
#for movement and camera
@onready var hold_point = $Camera3D/HoldPoint
@onready var ray = $Camera3D/RayCast3D
@onready var camera = $Camera3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
var held_object = null

#for the interaction ui buying
@onready var interaction_ui = $InteractionUI/Panel
@onready var action_label = $InteractionUI/Panel/ActionLabel
@onready var progress_bar = $InteractionUI/Panel/ProgressBar
var buy_progress := 0.0
var buy_time := 0.5
var current_target = null
var buying_egg = null

#selling
var selling_brainrot = null
var sell_progress := 0.0
@export var sell_time := 2.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_ui.visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY) #side
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY) #up down
		
		camera.rotation.x = clamp(
			camera.rotation.x,deg_to_rad(-80),deg_to_rad(80)
		)

func _physics_process(delta: float) -> void:
	update_interaction_ui(delta)
	update_selling(delta)
	#gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func pick_up(object):
	if held_object != null:
		return
		
	held_object = object
	object.freeze = true
	object.get_node("CollisionShape3D").disabled = true
	object.reparent(hold_point)
	
	object.position = Vector3.ZERO
	object.rotation = Vector3.ZERO
	print("Picked up:", object.name)

func update_interaction_ui(delta: float) -> void:
	if buying_egg != null:
		if not is_instance_valid(buying_egg):
			buying_egg = null
			buy_progress = 0.0
			hide_interaction_ui()
			return
			# E is being held
		if Input.is_action_pressed("interact"):
			action_label.text = "Hold [E] to Buy"
			interaction_ui.visible = true
			progress_bar.visible = true
			buy_progress += delta
			progress_bar.value = (buy_progress / buy_time) * 100.0 
			# Finished buying
			if buy_progress >= buy_time:
				if is_instance_valid(buying_egg): 
					buying_egg.interact()
				buying_egg = null
				buy_progress = 0.0
				progress_bar.value = 0.0
				buying_egg = null
				buy_progress = 0.0
				hide_interaction_ui()
				return

	if not ray.is_colliding():
		hide_interaction_ui()
		return

	var object = ray.get_collider()

	if object == null:
		hide_interaction_ui()
		return
	
	var brainrot= object.get_parent()
	if brainrot != null and brainrot.get("sell_price") !=null:
		action_label.text = "Hold [X] to Sell - $"+str(brainrot.sell_price)
		interaction_ui.visible = true
		progress_bar.visible = true

	if held_object != null:

		if object.is_in_group("hatching_platform"):

			var platform = object.get_parent()

			if platform.egg == null:

				action_label.text = "Press [E] to Place Egg"
				interaction_ui.visible = true
				progress_bar.visible = false

				if Input.is_action_just_pressed("interact"):
					if platform.place_egg(held_object):
						held_object = null
				return

		hide_interaction_ui()
		return

	if object.has_method("interact"):
		action_label.text = "Hold [E] to Buy"
		interaction_ui.visible = true
		progress_bar.visible = true

		if Input.is_action_pressed("interact"):
			buying_egg = object
			buy_progress += delta
			progress_bar.value = (buy_progress / buy_time) * 100.0
			if buy_progress >= buy_time:
				buying_egg.interact()
				buying_egg = null
				buy_progress = 0.0
				progress_bar.value = 0.0

		return
	hide_interaction_ui()

func sell_brainrot(brainrot) -> void:
	if brainrot == null:
		return
	var price = brainrot.sell_price
	GameManager.add_money(price)
	print("sold", brainrot.name, "for", price)
	if brainrot.hatching_platform != null:
		var platform = brainrot.hatching_platform
		platform.brainrot = null
		platform.get_node("MoneyCollection").set_brainrot(null)
	brainrot.queue_free()

func update_selling(delta: float) -> void:
	var target = $Camera3D/RayCast3D.get_collider()
	var brainrot = null
	if target != null:
		brainrot = target.get_parent()
		if brainrot.get("sell_price") == null:
			brainrot = null
	if brainrot == null:
		selling_brainrot = null
		sell_progress = 0.0
		return


	if brainrot == null:
		return

	if brainrot.get("sell_price") == null:
		selling_brainrot = null
		sell_progress = 0.0
		return
	interaction_ui.visible = true
	progress_bar.visible = true
	action_label.text = "Hold [X] to Sell - $" +str(brainrot.sell_price)
	
	if Input.is_key_pressed(KEY_X):
		if selling_brainrot != brainrot:
			selling_brainrot = brainrot
			sell_progress = 0.0
			print("Selling: ", brainrot.name)

		sell_progress += delta
		progress_bar.value = (sell_progress/sell_time) *100.0
		print("Sell progress: ", sell_progress)

		if sell_progress >= sell_time:
			sell_brainrot(brainrot)
			selling_brainrot = null
			sell_progress = 0.0
	else:
		# X released
		selling_brainrot = null
		sell_progress = 0.0
		progress_bar.value = 0

func hide_interaction_ui() -> void:
	interaction_ui.visible = false
	buy_progress = 0.0
	progress_bar.value = 0.0
