extends Control

enum {
	PAGE_SETTINGS,
	PAGE_PAUSE,
	PAGE_MAIN,
	PAGE_NONE
}

var page = PAGE_NONE
var pmenu : PanelContainer
var smenu : MarginContainer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	pmenu = get_node("PauseMenu")
	smenu = get_node("SettingsMenu")
	pmenu.visible = false
	smenu.visible = false

func _process(delta):
	
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


func _on_settings_pressed():
	page = PAGE_SETTINGS
	pmenu.visible = false
	smenu.visible = true
	
