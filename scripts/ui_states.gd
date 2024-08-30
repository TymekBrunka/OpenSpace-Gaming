extends Control

enum {
	PAGE_SETTINGS,
	PAGE_PAUSE,
	PAGE_MAIN,
	PAGE_NONE
}

var page = PAGE_NONE
var pmenu : Container
var smenu : Container

#signal paus_geam
#signal unpaus_geam

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	pmenu = get_node("PauseMenu")
	smenu = get_node("SettingsMenu")
	pmenu.visible = false
	smenu.visible = false
	get_node(".").visible = true #prevents confusion

func _process(delta) -> void:
	
	if Input.is_action_just_pressed("toggle_pause_menu"):
		if page == PAGE_NONE:
			pmenu.visible = true
			page = PAGE_PAUSE
			#paus_geam.emit()
			get_tree().paused = true
				
		elif page == PAGE_PAUSE:
			pmenu.visible = false
			page = PAGE_NONE
			#unpaus_geam.emit()
			get_tree().paused = false
		
		elif page == PAGE_SETTINGS:
			pmenu.visible = true
			smenu.visible = false
			page = PAGE_PAUSE


func _on_settings_pressed() -> void:
	page = PAGE_SETTINGS
	pmenu.visible = false
	smenu.visible = true

func _on_resume_pressed():
	pmenu.visible = false
	page = PAGE_NONE
	#unpaus_geam.emit()
	get_tree().paused = false
