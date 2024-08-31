class_name SpaceshipPlayer

extends CharacterBody2D

var pixelize_shader: Shader = load("res://shaders/pixelize2.gdshader")

var keybinds : Dictionary = {
	"move_left" : InputEventKey.new(),
	"move_right" : InputEventKey.new(),
	"move_forward" : InputEventKey.new(),
	"move_backward" : InputEventKey.new(),
}
var headers : settings_headers

@export var  max_speed: float = 300
@export var rotation_speed: float = 3.5
@export var velocity_damping_factor := .5
@export var linear_acceleration = 300
@export var boost_speed : float = 1200
var forward_backward : float
var rotation_direction: int
var speed : float

var sprite : Sprite2D
@export var spriteScale : Vector2 = Vector2(.7,.7)
@export var colisionBox : Vector2 = Vector2(30, 100)

@export var sprit : Texture2D
@export var main : bool

var col : CollisionShape2D
@export var camera : Camera2D

enum {
	WAITING_FOR_W,
	WAITING_FOR_NO_W,
	WAITING_FOR_W_AGAIN,
}

var boosting : bool
var waiting_for_boosting = WAITING_FOR_W
var last_double_w : float

var fly_audio: AudioStreamPlayer2D;
var boost_audio: AudioStreamPlayer2D;

func _ready() -> void:
	speed = max_speed
	headers = settings_headers.new(self)
	headers.SH.UpdatedKeybinds.connect(UpdateKeybinds.bind())
	sprite = Sprite2D.new()
	sprite.texture = sprit
	sprite.scale = spriteScale
	
	#var pixelize = ShaderMaterial.new()
	#pixelize.shader = pixelize_shader
	#sprite.material = pixelize
	
	self.add_child(sprite)
	col = CollisionShape2D.new()
	col.shape = CapsuleShape2D.new()
	col.shape.height = colisionBox.y
	col.shape.radius = colisionBox.x
	self.add_child(col)
	
	if main:
		var soundsP = get_node("/root/Main/Settings/sounds")
		fly_audio = AudioStreamPlayer2D.new()
		fly_audio.stream = soundsP.player_fly
		self.add_child(fly_audio)
		
		boost_audio = AudioStreamPlayer2D.new()
		boost_audio.stream = soundsP.player_boost
		self.add_child(boost_audio)

func UpdateKeybinds() -> void:
	keybinds = headers.SH.pass_keybinds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if main:
		#input_vector.x = int(Input.is_key_pressed(keybinds["move_left"].keycode)) - int(Input.is_key_pressed(keybinds["move_right"].keycode))
		forward_backward = int(Input.is_key_pressed(keybinds["move_forward"].keycode)) - int(Input.is_key_pressed(keybinds["move_backward"].keycode))
		
		if Input.is_key_pressed(keybinds["move_forward"].keycode):
			if !boosting && waiting_for_boosting == WAITING_FOR_W:
				waiting_for_boosting = WAITING_FOR_NO_W
			elif !boosting && waiting_for_boosting == WAITING_FOR_W_AGAIN && last_double_w < 0.3:
				waiting_for_boosting = WAITING_FOR_W
				last_double_w = 0
				boosting = true
		elif waiting_for_boosting != WAITING_FOR_W && last_double_w < 0.3:
			waiting_for_boosting = WAITING_FOR_W_AGAIN
			last_double_w += delta
		else:
			waiting_for_boosting = WAITING_FOR_W
			last_double_w = 0
			
		if Input.is_key_pressed(keybinds["move_left"].keycode):
			rotation_direction = -1
		elif Input.is_key_pressed(keybinds["move_right"].keycode):
			rotation_direction = 1
		else: 
			rotation_direction = 0
		
		camera.zoom.x = 1 - (0.3 * velocity.length() / boost_speed)
		camera.zoom.y = 1 - (0.3 * velocity.length() / boost_speed)
		if camera.zoom.x < 0.7:
			camera.zoom.x = 0.7
		if camera.zoom.y < 0.7:
			camera.zoom.y = 0.7
		
		#camera.zoom = Vector2(0.5, 0.5)
			
		#camera.position = Vector2(0, (-500 * velocity.length() / boost_speed))
		camera.position = velocity.rotated(-rotation) * 100 / boost_speed
		
		fly_audio.pitch_scale = velocity.length() / 300
	
func bounce_and_slide(velocity: Vector2, normal: Vector2, bounce_factor: float) -> Vector2:
	# Ensure the bounce factor is clamped between 0 and 1
	bounce_factor = clamp(bounce_factor, 0, 1)
	
	# Calculate the perpendicular (normal) component of the velocity
	var normal_component = velocity.dot(normal) * normal
	var tangent_component = velocity - normal_component
	
	# Calculate the new normal component after bouncing
	var new_normal_component = -normal_component * bounce_factor
	
	# Combine the new normal component with the tangent component
	return tangent_component + new_normal_component

func _physics_process(delta):
	if main:
		rotation += (rotation_direction * rotation_speed * delta)
		
		#if input_vector.x != 0 && input_vector.y == 0:
			#slow_down_and_stop(delta)
			#move_and_slide()
		if forward_backward != 0:
			accelerate_forward(delta)
			slow_down_and_stop(delta)
		if forward_backward == 0 && velocity != Vector2.ZERO:
			slow_down_and_stop(delta)
		
		if self.is_on_wall():
			velocity = bounce_and_slide(velocity, get_wall_normal(), 0.3)
			if ((velocity.dot(get_wall_normal()) * get_wall_normal()).length() > 55):
				rotation = velocity.rotated(deg_to_rad(90)).angle()
		move_and_collide(velocity * delta)
		move_and_slide()
	
	
func accelerate_forward(delta: float):
	velocity += Vector2(0, -forward_backward * linear_acceleration * delta).rotated(rotation)
	
	if forward_backward != 0 && !fly_audio.playing:
		fly_audio.play()
	
	if boosting:
		speed = boost_speed
		velocity += Vector2(0, -boost_speed).rotated(rotation)
		boost_audio.play()
		boosting = false
	#velocity.limit_length(speed)

func slow_down_and_stop(delta: float):
		# slow down
		velocity = lerp(velocity, Vector2.ZERO, velocity_damping_factor * (max_speed / 300) * delta)
		
		if speed > max_speed:
			speed -= delta * (boost_speed)
		elif speed < max_speed:
			speed = max_speed
		# stop
		if velocity.y >= -0.5 && velocity.y <= 0.5:
			velocity.y = 0
		if velocity.x >= -0.5 && velocity.x <= 0.5:
			velocity.x = 0
			
		if velocity.length() < 100:
			fly_audio.stop()
			
		if velocity.length() > speed:
			velocity = velocity.normalized() * speed
