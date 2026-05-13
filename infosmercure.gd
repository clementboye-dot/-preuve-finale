extends RigidBody3D

@export var nom : String = "Terre"
@export var masse : float = 330.104e21
@export var vitesse_péri : float = 58980
@export var excentricité : float = 0.20563593
@export var periode_revo : float = 0.2408467 
@export var periode_rot : float = 58.646

#func _input_event(_camera, event, _position, _normal, _shape_idx):
		#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#afficher_infos()
#func afficher afficher_infos():
	#print("Clic sur :", nom)
	#appeler l'interface utilisateur ici!!!!
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
