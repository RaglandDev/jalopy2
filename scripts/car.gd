extends VehicleBody3D

var max_rpm = 500
var max_torque = 200
var active = false
var car_zone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		$camera_car.make_current()
		
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


func _on_player_detect_body_entered(body):
	if body.name == "player":
		car_zone = true
func _on_player_detect_body_exited(body):
	if body.name == "player":
		car_zone = false
func entering_car():
	if Input.is_action_just_pressed("ui_e") && car_zone:
		var hidden_player = get_parent().get_node("player")
		hidden_player.active = false
		$camera_car.make_current()
		active = true
func leaving_car():
	var vehicle = $"."
	var hidden_player = get_parent().get_node("player")
	var newLoc = vehicle.global_transform.origin - 2 * vehicle.global_transform.basis.x
	if Input.is_action_just_pressed("ui_e"):
		hidden_player.active = true
		active = false 
		hidden_player.global_transform.origin = newLoc
