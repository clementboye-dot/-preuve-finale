extends RigidBody3D

@export var centre_rotation : RigidBody3D

@export_group("Paramètre de conversion simulation")
@export var min_distance_simulee : float
@export var max_distance_simulee : float
@export var min_distance_reelle : float
@export var max_distance_reelle : float

@export_group("Simulation gravitationnelle")
@export var masse : float
@export var masse_centre_rotation : float
@export var rayon_initial : float
@export var vitesse_initiale : float

@export_group("Paramètres de la méthode Ruge Kutta")
@export var etapes_calcul_par_ecran : int

### CONSTANTES ###
var G : float = 6.673e-11


var r_i : Vector3
var v_i : Vector3
var periode : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	r_i = rayon_initial * Vector3(1, 0, 0)
	position = conv_position_reelle_a_simulee(r_i)
	
	var v_initiale = sqrt(G * masse_centre_rotation / rayon_initial) #Par Kepler
	v_i = v_initiale * Vector3(0, 0, 1)
	
	periode = 2 * PI * rayon_initial / v_initiale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func conv_position_reelle_a_simulee(position_reelle : Vector3) -> Vector3:
	var distance_reelle = position_reelle.length() #Norme vecteur de distance
	var ratio = inverse_lerp(min_distance_reelle, max_distance_reelle, distance_reelle)
	var distance_simulee = lerp(min_distance_simulee, max_distance_simulee, ratio)
	var position_simulee = distance_simulee * position_reelle / position_reelle.length() #ou position_reelle.normalized()
	return position_simulee
