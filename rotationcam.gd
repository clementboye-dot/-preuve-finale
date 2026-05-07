extends Node3D

@export var vitesse_rotation: float
@export var pitch_min: float = -89.0
@export var pitch_max: float = 89.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("incliner_haut_caméra"):
		rotate_x(vitesse_rotation * delta)
	if Input.is_action_pressed("incliner_bas_caméra"):
		rotate_x(-vitesse_rotation * delta)
	#pour limiter la rotation, pour ne pas que la caméra fasse un backflip
	rotation.x = clamp(rotation.x, deg_to_rad(pitch_min), deg_to_rad(pitch_max))
	
