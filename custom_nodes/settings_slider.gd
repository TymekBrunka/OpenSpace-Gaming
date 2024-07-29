@icon("res://custom_nodes/icons/settings_slider.svg")
class_name settings_slider extends HSlider

@export var container : String
@export var key : String
var headers : settings_headers

func Update(val : int) -> void:
	headers.SH.SetSettingsValue.emit(container + "." + key, self.value)
	await headers.SH.SaveSettings
	headers.SH.save_settings()

func Load() -> void:
	self.value = headers.SH.GetSettingsValue(container + "." + key)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	headers = settings_headers.new(self)
	headers.SH.LoadedSettings.connect(self.Load)
	self.drag_ended.connect(Update.bind())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta) -> void:
	#pass
