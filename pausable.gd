class_name PauseHandler

var node: Node;

func _init(_node : Node) -> void: #passing node (in ext script it is self) to make get_node() work
	self.node = _node
	node.get_node("/root/Main/Game/Player/CanvasLayer/ui/").connect("paus_geam", pause)
	node.get_node("/root/Main/Game/Player/CanvasLayer/ui/").connect("unpaus_geam", pause)
	
func pause() -> void:
	node.pause()

func unpause() -> void:
	node.resume()
