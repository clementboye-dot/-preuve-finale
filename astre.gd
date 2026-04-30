extends Node3D
class_name Astre
@export var liste_planetes : ListeAstre
@export_group("Paramètre de conversion simulation")
#@export var centre_rotation : Node3D
#@export var periode_relative : float
@export var min_distance_simulee : float
@export var max_distance_simulee : float
@export var min_distance_reelle : float
@export var max_distance_reelle : float
@export var echelle_temps : float

@export_group("Simulation gravitationnelle")
@export var masse : float
#@export var masse_centre_rotation : float
@export var position_initiale : Vector3
@export var vitesse_initiale : Vector3
@export var vitesse_perihelie : float
@export var excentricite : float
@export var periode : float
@export var plan_inclinaison : float

@export_group("Paramètres RK4")
@export var etapes_calcul_par_ecran : int

### CONSTANTES ###
var G : float = 6.673e-11


var r_i : Vector3
var v_i : Vector3
#var periode : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#---POSITION INITIALE---#
	r_i = position_initiale
	
	position = conv_position_reelle_a_simulee(r_i)
	
#---VITESSE INITIALE---#
	v_i = vitesse_initiale
	
#---PÉRIODE---#
	#periode = 2 * PI * rayon_initial / vitesse_initiale
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	appliquer_RK4(delta)
	
	position = conv_position_reelle_a_simulee(r_i)
	
	#if centre_rotation != null:
		#position += centre_rotation.position

func conv_position_reelle_a_simulee(position_reelle : Vector3) -> Vector3:
	var distance_reelle = position_reelle.length() #Norme vecteur de distance
	var ratio = inverse_lerp(min_distance_reelle, max_distance_reelle, distance_reelle)
	var distance_simulee = lerp(min_distance_simulee, max_distance_simulee, ratio)
	var position_simulee = distance_simulee * position_reelle / position_reelle.length() #ou position_reelle.normalized()
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
	var nb_periode = temps_dernier_ecran * echelle_temps
	var h = nb_periode / etapes_calcul_par_ecran

	var t_i = 0.0
	while t_i <= nb_periode:
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

		t_i += h
