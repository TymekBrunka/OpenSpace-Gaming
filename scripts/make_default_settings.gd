extends Node

@export var key_move_left : InputEventKey
@export var key_move_right : InputEventKey
@export var key_move_forward : InputEventKey
@export var key_move_backward : InputEventKey

@onready var settings : Dictionary = {
	"keybinds" : {
		"move_left" :        key_move_left,
		"move_right" :       key_move_right,
		"move_forward" :     key_move_forward,
		"move_backward" :    key_move_backward,
	},
	"sound_settings" : {
		"master" : 1.0,
		"music" :  1.0,
	}
}
