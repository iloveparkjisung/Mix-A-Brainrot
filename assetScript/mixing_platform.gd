extends StaticBody3D

var brainrot = null

func _ready():
	add_to_group("mixing_platform")

func place_brainrot(_new_brainrot):
	if brainrot != null:
		return false
	brainrot = _new_brainrot
	_new_brainrot.get_parent().remove_child(_new_brainrot)
	add_child(_new_brainrot)
	_new_brainrot.position = $BrainrotPoint.position
	_new_brainrot.rotation = Vector3.ZERO
	_new_brainrot.place_on_platform(self)
	return true

func remove_brainrot():
	var old_brainrot = brainrot
	brainrot = null
	return old_brainrot
