extends Area2D

class_name PowerableArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var IsRecevingPower: bool
var IsSendingPower: bool

func _process(delta: float) -> void:
	var overlapping = get_overlapping_areas()
	# if no overlapping powers are IsSending power off.
	# if 1 or more ovrelapping are IsSending power on.
	var overlappingPowerA = tryGetOverlappingPoweredArea()
	if overlappingPowerA == null:
		return
	if overlappingPowerA.IsSendingPower:
		self.IsRecevingPower = true
	else:
		self.IsRecevingPower = false

## should only be at most 1 overlapping wire end with another end,
func tryGetOverlappingPoweredArea() -> PowerableArea:
	var overlapping = get_overlapping_areas()
	var poweredA: PowerableArea = null
	for a in overlapping:
		if a is PowerableArea:
			poweredA = a
			break
	return poweredA
