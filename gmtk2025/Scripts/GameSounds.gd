extends Node2D

const PLACE_WIRE: AudioStreamMP3 = preload("res://MySounds/PlaceWire.mp3")
const REVERSE_PLACE_WIRE: AudioStreamMP3 = preload("res://MySounds/ReversePlaceWire.mp3")
const ROTATESOUND: AudioStreamMP3 = preload("res://MySounds/SERUM_FXBullwhip.mp3")
const POWER_OFF: AudioStreamMP3 = preload("res://MySounds/PowerOff.mp3")

## Power on
const ELECTRIC_PULSE_SOUND: AudioStreamMP3 = preload("res://MySounds/ElectricPulseSound.mp3")
const POWER_ON_V_2 = preload("res://MySounds/PowerOnV2.mp3")
const POWER_UPV_3 = preload("res://MySounds/PowerUPV3.mp3")
const POWER_UPV_4 = preload("res://MySounds/PowerUPV4.mp3")

var placeWirePlayer: AudioStreamPlayer2D
var reversePlacedWire: AudioStreamPlayer2D
var rotatePlayer: AudioStreamPlayer2D
var ElectricONPlayer: AudioStreamPlayer2D
var ElectricOffPlayer: AudioStreamPlayer2D

func createAudioPlayer(clipPath: AudioStreamMP3) -> AudioStreamPlayer2D:
	var newAudioP = AudioStreamPlayer2D.new()
	newAudioP.stream = clipPath
	add_child(newAudioP)
	return newAudioP

func _ready() -> void:
	placeWirePlayer = createAudioPlayer(PLACE_WIRE)
	reversePlacedWire = createAudioPlayer(REVERSE_PLACE_WIRE)
	rotatePlayer = createAudioPlayer(ROTATESOUND)
	ElectricONPlayer = createAudioPlayer(POWER_UPV_4)
	ElectricOffPlayer= createAudioPlayer(POWER_OFF)
	ElectricOffPlayer.volume_db -= 3

func PlayPlaceSound():
	placeWirePlayer.play()

func PlayPickupSound():
	reversePlacedWire.play()

func PlayRotateSound():
	rotatePlayer.play()

func PlayElectricPulseSound():
	ElectricONPlayer.play()

func PowerOff():
	ElectricOffPlayer.play()
