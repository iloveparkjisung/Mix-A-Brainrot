extends CanvasLayer

@onready var panel = $Panel
@onready var title_label = $Panel/TitleLabel
@onready var tutorial_label = $Panel/TutorialLabel
@onready var continue_label = $Panel/ContinueLabel
var tutorial_steps := 0
var tutorial_finished := false


func _ready():
	add_to_group("tutorial")
	show_step(0)

func show_step(step: int):
	tutorial_steps = step
	match step:
		0:
			title_label.text = "WELCOME TO MIX-A-BRAINROT!"
			tutorial_label.text = "Let's get your first Brainrot!"
			continue_label.text = "[SPACE] to continue"

		1:
			title_label.text = "Step 1 buy an egg"
			tutorial_label.text = "Head over to the conveyor and buy your first egg."
			continue_label.text = "Look at an egg and hold [E] to buy it."

		2:
			title_label.text = "Step 2 place egg in platform"
			tutorial_label.text = "Take your egg to an empty Hatching Platform."
			continue_label.text = "Place your egg on the platform."

		3:
			title_label.text = "Step 3 wait for egg to hatch"
			tutorial_label.text = "Your egg is hatching! Wait until your Brainrot appears."
			continue_label.text = "Wait for the hatch."

		4:
			title_label.text = "Step 4 collect money"
			tutorial_label.text = "Step onto the collection plate to collect it."
			continue_label.text = "[SPACE] to continue"

		5:
			title_label.text = "Step 5 check recipe book"
			tutorial_label.text = "[R] to open your Recipe Book and see what Brainrots you can mix"
			continue_label.text = "[R] to open the Recipe Book"

		6:
			title_label.text = "STEP 6 — MIX A BRAINROT"
			tutorial_label.text = "Have the right ingredients? Head to the Mixing Station and combine them!"
			continue_label.text = "Take your ingredients to the Mixing Station. [SPACE] to end tutorial"

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if tutorial_steps == 0:
			show_step(1)
		elif tutorial_steps == 4:
			show_step(5)
		elif tutorial_steps == 6:
			tutorial_finished = true
			hide()

func egg_bought():
	if tutorial_steps == 1:
		show_step(2)

func egg_picked_up():
	pass

func egg_placed():
	if tutorial_steps == 2:
		show_step(3)

func egg_hatched():
	if tutorial_steps == 3:
		show_step(4)

func money_collected():
	if tutorial_steps == 4:
		continue_label.text = "Press SPACE to continue"

func recipe_book_opened():
	if tutorial_steps == 5:
		show_step(6)

func mixing_station_reached():
	if tutorial_steps == 6:
		continue_label.text = "Press SPACE to finish the tutorial"
