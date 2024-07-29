class_name settings_headers

var SH : Control
var SL : Node

func _init(node : Node) -> void: #passing node (in ext script it is self) to make get_node() work
	SH = node.get_node("/root/Main/ui/SettingsMenu/sub/sub2/sub3/settings_handler")
	SL = node.get_node("/root/Main/Settings")
