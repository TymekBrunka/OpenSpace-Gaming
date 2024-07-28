extends TabContainer


# Called when the node enters the scene tree for the first time.
var Keybinds : Dictionary
var Settings : Dictionary
var UiContainers : Dictionary

var AwaitingButton : Button = null
var AwaitingBId : String = ""

signal AwaitForKey(button : Button)
signal SetSettingsValue(key : String, value)
signal SaveSettings

signal UpdatedKeybinds
signal KeybindsReady
func pass_keybinds():
	return Keybinds

func save_settings():
	var a = FileAccess.get_file_as_string("res://settings/settings.json")
	if  not a == JSON.stringify(Settings, "    "):
		FileAccess.open("res://settings/settings.json", FileAccess.WRITE).store_string(JSON.stringify(Settings, "    "))

func _ready():
	connect("AwaitForKey", AwaitForKeyFunc)
	connect("SetSettingsValue", SetSettingsValueFunc)
	#connect("SetTheKey", SetTheKeyFunc)

func SetSettingsValueFunc(key : String, value):
	var keys = key.split(".")
	var ky = keys[keys.size() -1]
	keys.remove_at(keys.size() - 1)
	var valuee = Settings

	for keyy in keys:
		valuee = valuee[keyy]

	valuee[ky] = value
	SaveSettings.emit()

func UIF_hslider(val: int, node : HSlider, key : String):
	SetSettingsValue.emit(key, node.value)
	await SaveSettings
	print("fex")
	save_settings()

func AwaitForKeyFunc(button : Button, id : String):
	AwaitingButton = button
	button.text = " ⌨ "
	AwaitingBId = id
	
func SetKeyBind(id: String, button: Button):
	AwaitForKey.emit(button, id)
	#var b = await SetTheKey

func _on_settings_settings_ready():
	Settings = get_node("../../../../../../Settings").pass_settings()
	
	for i in Settings["keybinds"]:
		var bindbutton : Button = get_node("Keybinds/list/" + i)
		var bind = InputEventKey.new()
		
		bind.keycode = Settings["keybinds"][i]
		Keybinds[i] = bind
		
		bindbutton.text = " " + bind.as_text_keycode() + " "
		#Keybinds_buttons[i] = bindbutton
		bindbutton.pressed.connect(SetKeyBind.bind(i, bindbutton))
	
	# key : [ node, signal ]
	UiContainers = {
		"sound_settings": [ get_node("Music and Sounds/list"), null ]
	}
	for i in UiContainers.keys():
		for j in Settings[i].keys():
			#var node : Control = UiContainers[0][0]
			var node : Control = UiContainers[i][0].find_child(j)
			#print(node)
			if node is HSlider:
				print(i + "." + j)
				node.value = Settings[i][j]
				node.drag_ended.connect(UIF_hslider.bind(node, i + "." + j))
	
func _input(event):
	if AwaitingButton != null or AwaitingBId != "":
		if event is InputEventKey and event.pressed:
			AwaitingButton.text = " " + event.as_text_keycode() + " "
			Settings["keybinds"][AwaitingBId] = event.keycode
			Keybinds[AwaitingBId] = event
			
			save_settings()
			
			AwaitingBId = ""
			AwaitingButton = null
