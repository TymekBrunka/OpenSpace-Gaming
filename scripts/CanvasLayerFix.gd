extends CanvasLayer

@export var player : SpaceshipPlayer
@onready var player_camera : Camera2D = player.camera

func _process(delta) -> void:
	transform.origin = player.position - (Vector2(get_window().size) / 2 / player_camera.zoom) + player.camera.position.rotated(player.rotation)
	transform.x = Vector2(1 / player.camera.zoom.x, 0)
	transform.y = Vector2(0, 1 / player.camera.zoom.y)
