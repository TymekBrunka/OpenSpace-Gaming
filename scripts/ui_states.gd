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
				
		elif page == PAGE_PAUSE:
			pmenu.visible = false
			page = PAGE_NONE
		
		elif page == PAGE_SETTINGS:
			pmenu.visible = true
			smenu.visible = false
			page = PAGE_PAUSE


func _on_settings_pressed() -> void:
	page = PAGE_SETTINGS
	pmenu.visible = false
	smenu.visible = true
	
