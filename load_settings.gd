extends Node

var settings : Dictionary
signal settings_ready

func fill_settings(settings: Dictionary, defaults: Dictionary):
	for i in defaults.keys():
		if not settings.has(i):
			settings[i] = defaults[i]
		else:
			if typeof(defaults[i]) == TYPE_DICTIONARY:
				fill_settings(settings[i], defaults[i])

func pass_settings():
	return settings

# Called when the node enters the scene tree for the first time.
func _ready():

	var defaults_node = get_node("make_default_settings")
	var defaults : Dictionary = defaults_node.settings
	
	#make default keybinds compatible with saved settings
	for i in defaults["keybinds"].keys(): #loops not modified
		defaults["keybinds"][i] = defaults["keybinds"][i].keycode
	
	var a = FileAccess.get_file_as_string("res://settings/settings.json")
	settings = JSON.parse_string(a)
	
	#fill settings list if they lack entries
	fill_settings(settings, defaults)
	
	#save settings into file
	if  not a == JSON.stringify(settings, "    "):
		FileAccess.open("res://settings/settings.json", FileAccess.WRITE).store_string(JSON.stringify(settings, "    "))
	settings_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
