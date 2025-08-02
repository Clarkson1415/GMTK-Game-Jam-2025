extends AnimationPlayer

class_name PowerAnimations

func _power_off() -> void:
	play("OFF")


func _power_on() -> void:
	play("ON")
