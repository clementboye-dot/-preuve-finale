extends Node3D

@export var vitesse_translation : float = 10.0
@export var vitesse_rotation : float = 1.0
@export var pitch_min : float = -89.0
@export var pitch_max : float = 89.0

var position_initiale
var rotation_initiale

func _ready() -> void:
	rotation_initiale = rotation
	position_initiale = position

func _process(delta: float) -> void:
	# --- Translation WASD ---
	if Input.is_action_pressed("avancer_caméra"):
		position += -transform.basis.z * vitesse_translation * delta
	if Input.is_action_pressed("reculer_caméra"):
		position += transform.basis.z * vitesse_translation * delta
	if Input.is_action_pressed("tasser_droite_caméra"):
		position += transform.basis.x * vitesse_translation * delta
	if Input.is_action_pressed("tasser_gauche_caméra"):
		position += -transform.basis.x * vitesse_translation * delta
	
	# --- Rotation QE ---
	if Input.is_action_pressed("tourner_gauche_caméra"):
		rotate_y(vitesse_rotation * delta)
	if Input.is_action_pressed("tourner_droite_caméra"):
		rotate_y(-vitesse_rotation * delta)
	
	# --- Inclinaison ZX ---
	if Input.is_action_pressed("incliner_haut_caméra"):
		rotate_x(vitesse_rotation * delta)
	if Input.is_action_pressed("incliner_bas_caméra"):
		rotate_x(-vitesse_rotation * delta)
	# Limite l'inclinaison pour éviter le backflip
	rotation.x = clamp(rotation.x, deg_to_rad(pitch_min), deg_to_rad(pitch_max))
	
	
	# --- Réinitialisation --- #
	if Input.is_action_pressed("reinitialiser_camera"):
		position = position_initiale
		rotation = rotation_initiale
