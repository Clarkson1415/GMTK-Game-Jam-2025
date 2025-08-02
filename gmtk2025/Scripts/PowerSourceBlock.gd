extends Area2D

## Is a permanant power source area 2d.
class_name PowerSource

## Set collision layer to 2 which wires are on.
func _ready() -> void:
	set_collision_layer_value(2, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, false)
