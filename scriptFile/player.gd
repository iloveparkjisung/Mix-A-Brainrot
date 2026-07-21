extends CharacterBody3D

@onready var hold_point = $Camera3D/HoldPoint
@onready var ray = $Camera3D/RayCast3D
@onready var camera = $Camera3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
var held_object = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY) #side
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY) #up down
		
		camera.rotation.x = clamp(
			camera.rotation.x,deg_to_rad(-80),deg_to_rad(80)
		)
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if ray.is_colliding():
			var object = ray.get_collider()
			if object.has_method("interact"):
				object.interact()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	object.reparent(hold_point)
	
	object.position = Vector3.ZERO
	object.rotation = Vector3.ZERO
	print("Picked up:", object.name)
