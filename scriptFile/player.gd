extends CharacterBody3D
#for movement and camera
@onready var hold_point = $Camera3D/HoldPoint
@onready var ray = $Camera3D/RayCast3D
@onready var camera = $Camera3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
#holding
var held_object = null
var holding_brainrot := false
var held_brainrot_visual_scale := Vector3.ONE

#for the interaction ui buying
@onready var interaction_ui = $InteractionUI/Panel
@onready var action_label = $InteractionUI/Panel/ActionLabel
@onready var progress_bar = $InteractionUI/Panel/ProgressBar
@onready var pickup_label = $InteractionUI/Panel/PickupLabel
var buy_progress := 0.0
var buy_time := 0.5
var current_target = null
var buying_egg = null

#recipebook
@onready var recipe_book = $RecipeBookUI/Book

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

func pick_up(object): #egg
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
	
	#place brainrot
	if held_object != null:
		var target = ray.get_collider()
		if target == null:
			hide_interaction_ui()
			return
		#brainrot
		if holding_brainrot:
			var platform = get_brainrot_place_target()

			if platform != null and platform.brainrot == null:
				action_label.text = "Press [E] to place Brainrot"
				interaction_ui.visible = true
				progress_bar.visible = false
				pickup_label.visible = false
				return

			hide_interaction_ui()
			return
		#egg
		if not holding_brainrot:

			var egg_platform = target
			while egg_platform != null and not egg_platform.has_method("place_egg"):
				egg_platform = egg_platform.get_parent()

			if egg_platform != null and egg_platform.egg == null:
				action_label.text = "Press [E] to Place Egg"
				interaction_ui.visible = true
				progress_bar.visible = false

				if Input.is_action_just_pressed("interact"):
					if egg_platform.place_egg(held_object):
						held_object = null

			return

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
		pickup_label.visible = false

	if held_object != null:

		if object.is_in_group("hatching_platform"):

			var platform = object.get_parent()

			if platform.egg == null:

				action_label.text = "Press [E] to Place Egg"
				interaction_ui.visible = true
				progress_bar.visible = false
				pickup_label.visible = false

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
		pickup_label.visible = false

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
	if held_object != null:
		selling_brainrot = null
		sell_progress = 0.0
		return
		
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
	pickup_label.visible = true
	action_label.text = "Hold [X] to Sell - $" +str(brainrot.sell_price)
	pickup_label.text = "Press [E] to Pick Up"
	
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

func pick_up_brainrot(brainrot):
	if held_object != null:
		return
	var old_platform = brainrot.get_parent()
	if old_platform != null and old_platform.has_method("remove_brainrot"):
		old_platform.remove_brainrot()
	held_object = brainrot
	holding_brainrot = true
	held_brainrot_visual_scale = brainrot.get_node("Sprite3D").scale
	brainrot.pick_up()

	var collision = brainrot.get_node_or_null("StaticBody3D/CollisionShape3D")
	if collision != null:
		collision.disabled = true

	brainrot.reparent(hold_point)
	brainrot.position = Vector3.ZERO
	brainrot.rotation = Vector3.ZERO

	brainrot.get_node("Sprite3D").scale = held_brainrot_visual_scale * 0.5
	print("Carrying Brainrot: ", brainrot.name)

func get_brainrot_target():
	var target = $Camera3D/RayCast3D.get_collider()

	if target == null:
		return null

	return find_brainrot_from_target(target)

func try_pick_up_brainrot():
	if held_object != null:
		return
	var brainrot = get_brainrot_target()
	if brainrot == null:
		return
	pick_up_brainrot(brainrot)

func get_brainrot_place_target():
	var target = $Camera3D/RayCast3D.get_collider()

	if target == null:
		return null
	var platform = target
	while platform != null:
		if platform.has_method("place_brainrot"):
			return platform

		platform = platform.get_parent()

	return null

func try_place_brainrot():
	if held_object == null:
		return

	var platform = get_brainrot_place_target()

	if platform == null:
		print("No Brainrot placement target found")
		return

	if platform.place_brainrot(held_object):

		var collision = held_object.get_node_or_null("StaticBody3D/CollisionShape3D")
		if collision != null:
			collision.disabled = false

		held_object.get_node("Sprite3D").scale = held_brainrot_visual_scale

		held_object = null
		holding_brainrot = false

		print("Brainrot placed successfully!")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_recipe_book"):
		recipe_book.visible = !recipe_book.visible
	if Input.is_action_just_pressed("interact"):
		if holding_brainrot:
			try_place_brainrot()
		elif held_object == null:
			try_pick_up_brainrot()
	var mixing_table = get_mixing_table_target()

	if mixing_table != null:
		mixing_table.show_mix_ui()
	else:
		for table in get_tree().get_nodes_in_group("mixing_table"):
			table.hide_mix_ui()

func find_brainrot_from_target(target):
	var node = target

	while node != null:
		if node.has_method("pick_up"):
			return node

		node = node.get_parent()

	return null

func get_mixing_table_target():
	var target = $Camera3D/RayCast3D.get_collider()
	if target == null:
		return null
	var node = target
	while node != null:
		if node.has_method("show_mix_ui"):
			return node
		node = node.get_parent()
	return null
