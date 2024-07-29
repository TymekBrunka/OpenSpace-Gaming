extends TabContainer


# Called when the node enters the scene tree for the first time.
var Keybinds : Dictionary
var Settings : Dictionary
var UiContainers : Dictionary

var AwaitingButton : Button = null
var AwaitingBId : String = ""

signal AwaitForKey(button : Button)
signal SetSettingsValue(key : String, value)
#signal GetSettingsValue(key : String, value)
signal SaveSettings

signal UpdatedKeybinds
signal KeybindsReady
signal LoadedSettings
func pass_keybinds():
	return Keybinds

func save_settings() -> void:
	print("saving settings")
	var a = FileAccess.get_file_as_string("res://settings/settings.json")
	if  not a == JSON.stringify(Settings, "    "):
		FileAccess.open("res://settings/settings.json", FileAccess.WRITE).store_string(JSON.stringify(Settings, "    "))

func _ready() -> void:
	connect("AwaitForKey", AwaitForKeyFunc)
	connect("SetSettingsValue", SetSettingsValueFunc)
	#connect("SetTheKey", SetTheKeyFunc)

func SetSettingsValueFunc(key : String, value) -> void:
	var keys = key.split(".")
	var ky = keys[keys.size() -1]
	keys.remove_at(keys.size() - 1)
	var valuee = Settings

	for keyy in keys:
		valuee = valuee[keyy]

	valuee[ky] = value
	await get_tree().process_frame #this is to make sure that things that await SaveSettings, will get the signal
	SaveSettings.emit()

func GetSettingsValue(key : String):
	var keys = key.split(".")
	var ky = keys[keys.size() -1]
	keys.remove_at(keys.size() - 1)
	var valuee = Settings

	for keyy in keys:
		valuee = valuee[keyy]
	return valuee[ky]

func AwaitForKeyFunc(button : Button, id : String) -> void:
	AwaitingButton = button
	button.text = " ⌨ "
	AwaitingBId = id
	
func SetKeyBind(id: String, button: Button) -> void:
	AwaitForKey.emit(button, id)
	#var b = await SetTheKey

func _on_settings_settings_ready() -> void:
	Settings = get_node("../../../../../../Settings").pass_settings()
	LoadedSettings.emit()
	
	for i in Settings["keybinds"]:
		var bindbutton : Button = get_node("Keybinds/list/" + i)
		var bind = InputEventKey.new()
		
		bind.keycode = Settings["keybinds"][i]
		Keybinds[i] = bind
		
		bindbutton.text = " " + bind.as_text_keycode() + " "
		#Keybinds_buttons[i] = bindbutton
		bindbutton.pressed.connect(SetKeyBind.bind(i, bindbutton))
	
func _input(event) -> void:
	if AwaitingButton != null or AwaitingBId != "":
		if event is InputEventKey and event.pressed:
			AwaitingButton.text = " " + event.as_text_keycode() + " "
			Settings["keybinds"][AwaitingBId] = event.keycode
			Keybinds[AwaitingBId] = event
			
			save_settings()
			
			AwaitingBId = ""
			AwaitingButton = null
