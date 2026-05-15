extends Node3D
class_name Astres

@export var liste_planetes : ListeAstres

@export_group("Paramètre de conversion simulation")
@export var min_distance_simulee : float
@export var max_distance_simulee : float
@export var min_distance_reelle : float
@export var max_distance_reelle : float


@export_group("Simulation gravitationnelle")
@export var masse : float
@export var position_initiale : Vector3
@export var vitesse_initiale : Vector3
@export var vitesse_perihelie : float
@export var excentricite : float
@export var periode_revolution : float
@export var periode_rotation : float

@export_group("Paramètres RK4")
@export var etapes_calcul_par_ecran : int

# --- CONSTANTE GRAVITATIONNELLE --- #
var G : float = 6.673e-11

# --- DÉCLARATION DE VARIABLES DIVERSES ---#
var echelle_temps : float = 2629800.0 #Vitesse de simulation initiale ( 1s réelle = 1 mois simulé)
var r_i : Vector3 # Vecteur de position d'astre
var v_i : Vector3 #Vecteur de vitesses d'astres
var pause : bool # variable pour gérer la pause
signal astre_clique(astre) # Déclare le signal à émettre lors d'un clic sur l'astre


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#---POSITION INITIALE---#
	r_i = position_initiale
	position = conv_position_reelle_a_simulee(r_i)
	
#---VITESSE INITIALE---#
	v_i = vitesse_initiale
	
#Appelle la fonciton _on_clic lorsqu'un clic sur le RigidBody est détecté
#Solution proposée par Claude (IA) car un message d'erreur apparait sporadiquement 
#lors d'un clic sur des astres
	if not $RigidBody3D.input_event.is_connected(_on_clic):
		$RigidBody3D.input_event.connect(_on_clic)

#Fait débuter la simulation pas sur Pause
	pause = false

# Ajoute les Node dans un groupe pour y accéder facilement pour l'interface infos_planetes.gd
	add_to_group("corps_celestes")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
# Évite que la position se calcule si on met la simulation sur pause
	if pause == true:
		return
# Évalue la position de l'astre avec la méthode Runge-Kutta d'ordre 4
	appliquer_RK4(delta)
	position = conv_position_reelle_a_simulee(r_i)
	

func conv_position_reelle_a_simulee(position_reelle : Vector3) -> Vector3:
	"""Effectue la mise à l'échelle des distances de la simulation en faisant
	la conversion d'une position réelle d'un astre à une position de l'espace 
	de la simulation
	
	Paramètres:
	position_reelle -- la position réelle à convertir
	
	Retour :
	 vecteur de la position dans le monde de la simulation à utiliser
	"""
	var distance_reelle = position_reelle.length() #Norme vecteur de distance
	var ratio = inverse_lerp(min_distance_reelle, max_distance_reelle, distance_reelle)
	var distance_simulee = lerp(min_distance_simulee, max_distance_simulee, ratio)
	var position_simulee = distance_simulee * position_reelle / position_reelle.length()
	return position_simulee

func calculer_acceleration_gravitationnelle(position_reelle : Vector3) -> Vector3:
	"""Calcule l'accélération gravitationnelle exercée par tous les astres du système
	solaire sur le corps selon sa position relative à tous les autres
	
	Paramètre:
	position_reelle : sa position dans l'espace en m
	
	Retour:
	Vecteur de l'accélération gravitationnelle exercée sur le corps en m/s^2
	"""
# Initialise le vecteur d'accélération en vecteur nul
	var acceleration = Vector3.ZERO
# Parcours la liste de planètes pour calculer l'accélération de chacune à chaque instant
	for planete in liste_planetes.planetes :
# Évite les divisions par 0 : pas de calcul d'accélération causée par elle-même
		if planete != self:
			var vecteur_distance_autre_planète : Vector3 = planete.r_i - position_reelle
			var distance : float = vecteur_distance_autre_planète.length()
			acceleration += G * planete.masse / (distance**2) * vecteur_distance_autre_planète.normalized()
	return acceleration

func appliquer_RK4(temps_dernier_ecran : float) -> void:
	"""Applique la méthode de Runge-Kutta d'ordre 4 (RK4)
	pour estimer la position et la vitesse selon le temps de rendu
	de la simulation.
		
	Paramètre :
	temps_dernier_ecran -- le temps écoulé depuis le dernier écran.
	"""
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

		# Met à jour la position et la vitesse de la planète
		r_i = r_i + (h / 6.0) * (k1_r + 2*k2_r + 2*k3_r + k4_r)
		v_i = v_i + (h / 6.0) * (k1_v + 2*k2_v + 2*k3_v + k4_v)


func _on_clic(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	"""Détecte et emet un signal lorsque le bouton gauche de la souris clique sur un astre
	
	Paramètre :
		event -- évenement à détecter """
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("astre_clique", self)



func mettre_en_pause(etat_pause: bool) -> void:
	"""Change l'état de pause de l'astre
	
	Parametre :
	etat_pause -- l'état de pause à adopter par l'astre"""
	pause = etat_pause
