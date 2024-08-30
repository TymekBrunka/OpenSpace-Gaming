extends TileMap

const map_size : int = 7
@onready var Scale : Vector2 = Vector2(2,2)
@export var player : SpaceshipPlayer
@export var scroll_factor : float = 0.5
#@export var zoom_factor : float = 0.1

#var seed: int

#returns tileid from seed
func get_tile_ph1(mini: int, maxi: int, seed: int) -> int:
	#var zrandom: int = 282939321
	var zrandom: int = ((seed * 1103515247 * 282939321) + 12345678) % 2147483647
	zrandom = floor( ( mini + (zrandom * ( (maxi - mini) + 1) ) ) / 2147483647 )
	return zrandom

func get_tile_f(point: Vector2i) -> Vector2i:
	var tileid: int = get_tile_ph1(1,5, point.x * 100000 + point.y)
	if tileid == 1:
		tileid = get_tile_ph1(2,9, point.y * 100000 + point.x)
		return Vector2i( wai(tileid % 3, 3) , wai(tileid / 3, 3) )
	return Vector2i(0,0)

func vec2mod(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(fmod(v1.x, v2.x), fmod(v1.y, v2.y))
	
func vec2waf(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(waf(v1.x, v2.x), waf(v1.y, v2.y))
	
#wrap around intiger (0, x)
func wai(a : int, x: int) -> int:
	return ( a % x ) if a >= 0 else 0 if a < 0 && a % x == 0 else x + (a % x)

# float wrapping for background position
func waf(a : int, x: int) -> int:
	return -x - fmod(-a, x)  if a > 0 else fmod( a, x )

func _ready() -> void:
	Scale = scale

func _process(delta) -> void:
	self.position = ( vec2waf(-player.position * scroll_factor, Vector2(tile_set.tile_size) * self.Scale) * (player.camera.zoom) ) + (Vector2(get_window().size) / 2) - player.camera.position.rotated(player.rotation)
	self.scale = Scale - ((Vector2(1,1) - (player.camera.zoom)) * Scale)
	#    v---chunk position (like offset but in tiles)
	var cp: Vector2i = ceil( -player.position * scroll_factor / Vector2(tile_set.tile_size) / self.Scale)
	#print("cp = ", cp )
	for x in range(-map_size / 2, map_size / 2):
		for y in range(-map_size / 2, map_size / 2):
			var tile: Vector2i = get_tile_f( cp + Vector2i(x,y) )
			#if ( cp + Vector2i(x,y) == Vector2i(0,2) ):
				#print(tile)
			self.set_cell(0, Vector2i(x,y), 0, tile )
	#self.set_cell(0, Vector2i(0,0), 0, Vector2i(2,2))
