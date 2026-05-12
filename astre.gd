extends Node3D
class_name Astre
@export var liste_planetes : ListeAstre
@export_group("Paramètre de conversion simulation")
@export var min_distance_simulee : float
@export var max_distance_simulee : float
@export var min_distance_reelle : float
@export var max_distance_reelle : float


@export_group("Simulation gravitationnelle")
@export var masse : float
@export var position_initiale : Vector3
@export var vitesse_initiale : Vector3

@export_group("Informations")
@export var nom : String
@export var vitesse_peri : float
@export var periode_revo : float
@export var periode_rot : float
@export var excentricité : float

@export var interface : Node2D

func _input_event(_camera, event, _position, _normal, _shape_idx):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			appeler_interface

func appeler_interface():
	if interface :
		interface.remplir_le_tableau(self)
	else:
		print("Erreur : L'interface n'est pas reliée dans l'inspecteur de ", nom)

@export_group("Paramètres RK4")
@export var etapes_calcul_par_ecran : int

### CONSTANTES ###
var G : float = 6.673e-11


var echelle_temps : float = 31557600.0
#1s = 1 mois : 2629800.0
#1s = 1 an : 31557600.0

var v_i : Vector3
var r_i : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#---POSITION INITIALE---#
	r_i = position_initiale
	
	position = conv_position_reelle_a_simulee(r_i)
	
#---VITESSE INITIALE---#
	v_i = vitesse_initiale
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	appliquer_RK4(delta)
	position = conv_position_reelle_a_simulee(r_i)
	

func conv_position_reelle_a_simulee(position_reelle : Vector3) -> Vector3:
	var distance_reelle = position_reelle.length() #Norme vecteur de distance
	var ratio = inverse_lerp(min_distance_reelle, max_distance_reelle, distance_reelle)
	var distance_simulee = lerp(min_distance_simulee, max_distance_simulee, ratio)
	var position_simulee = distance_simulee * position_reelle / position_reelle.length()
	return position_simulee

func calculer_acceleration_gravitationnelle(position_reelle : Vector3) -> Vector3:
	var acceleration = Vector3.ZERO
	for planete in liste_planetes.planetes :
		if planete != self:
			var vecteur_distance_autre_planète : Vector3 = planete.r_i - position_reelle
			var distance : float = vecteur_distance_autre_planète.length()
			if distance > 1.0:  # Évite division par zéro
				acceleration += G * planete.masse / (distance**2) * vecteur_distance_autre_planète.normalized()
	return acceleration

func appliquer_RK4(temps_dernier_ecran : float) -> void:
	var h = temps_dernier_ecran * echelle_temps / etapes_calcul_par_ecran

	for _i in range(etapes_calcul_par_ecran):
		# k1 — pente au début du pas
		var k1_r = v_i
		var k1_v = calculer_acceleration_gravitationnelle(r_i)

		# k2 — pente au milieu du pas (estimée avec k1)
		var k2_r = v_i + k1_v * (h / 2)
		var k2_v = calculer_acceleration_gravitationnelle(r_i + k1_r * (h / 2))

		# k3 — pente au milieu du pas (estimée avec k2)
		var k3_r = v_i + k2_v * (h / 2)
		var k3_v = calculer_acceleration_gravitationnelle(r_i + k2_r * (h / 2))

		# k4 — pente à la fin du pas (estimée avec k3)
		var k4_r = v_i + k3_v * h
		var k4_v = calculer_acceleration_gravitationnelle(r_i + k3_r * h)

		# Mise à jour position et vitesse
		r_i = r_i + (h / 6.0) * (k1_r + 2*k2_r + 2*k3_r + k4_r)
		v_i = v_i + (h / 6.0) * (k1_v + 2*k2_v + 2*k3_v + k4_v)
