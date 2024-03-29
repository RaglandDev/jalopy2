extends VehicleBody3D

var max_rpm = 500
var max_torque = 200
var active = false
var car_zone = false
var hood_zone = false
var door_open = false
var inside_car = true
var top_view = false

@onready var neck := $Neck_Car
@onready var camera := $Neck_Car/camera_car
@onready var top_camera := $car_camera_top

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
		if event is InputEventMouseMotion && inside_car:
			neck.rotate_y(-event.relative.x * .01)
			camera.rotate_x(-event.relative.y * .01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
		if Input.is_action_just_pressed("ui_v") && inside_car:
			top_view = !top_view
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if !top_view:
			$Neck_Car/camera_car.make_current()
		else:
			top_camera.make_current()
		
		steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
		engine_force = Input.get_axis("back", "forward") 
		var acceleration = Input.get_axis("back", "forward") 
		
		var rpm = $wheel_back_left.get_rpm()
		$wheel_back_left.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
		
		rpm = $wheel_back_right.get_rpm()
		$wheel_back_right.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
		
		leaving_car()
	elif !active:
		entering_car()
		opening_hood()


func _on_player_detect_body_entered(body):
	if body.name == "player":
		car_zone = true
func _on_player_detect_body_exited(body):
	if body.name == "player":
		car_zone = false
func entering_car():
	if Input.is_action_just_pressed("ui_e") && car_zone && !door_open:
		get_parent().find_child("AnimationPlayer").play("Door_L Open")
		door_open = true
	elif Input.is_action_just_pressed("ui_e") && car_zone && door_open:
		get_parent().find_child("AnimationPlayer").play_backwards("Door_L Open")
		var hidden_player = get_parent().get_node("player")
		hidden_player.active = false
		$Neck_Car/camera_car.make_current()
		active = true
		door_open = false
		inside_car = true

		
func leaving_car():
	var vehicle = $"."
	var hidden_player = get_parent().get_node("player")
	var newLoc = vehicle.global_transform.origin - .5 * vehicle.global_transform.basis.x
	if Input.is_action_just_pressed("ui_e"):
		hidden_player.active = true
		active = false 
		inside_car = false
		hidden_player.global_transform.origin = newLoc


func _on_player_detect_hood_body_entered(body):
	if body.name == "player":
		hood_zone = true
func opening_hood():
	#if Input.is_action_just_pressed("ui_e") && hood_zone:
		#get_parent().find_child("AnimationPlayer").play("Door_L Open")
	pass
