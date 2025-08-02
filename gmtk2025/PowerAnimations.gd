extends AnimationPlayer

class_name PowerAnimations

func _on_power_controller_power_off() -> void:
	play("OFF")


func _on_power_controller_power_on() -> void:
	play("ON")
