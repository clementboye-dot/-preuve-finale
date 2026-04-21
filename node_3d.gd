extends Node3D

@export var vitesse_translation : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("avancer_caméra") :
		position += -transform.basis.z * vitesse_translation * delta
	if Input.is_action_pressed("reculer_caméra") :
		position += transform.basis.z * vitesse_translation * delta
	if Input.is_action_pressed("tasser_droite_caméra") :
		position += transform.basis.x * vitesse_translation * delta
	if Input.is_action_pressed("tasser_gauche_caméra") :
		position += -transform.basis.x * vitesse_translation * delta
