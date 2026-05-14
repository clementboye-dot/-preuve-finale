extends Control
class_name InterfaceInfos

@export var astres : Node
@export var label_nom : Label
@export var label_masse : Label
@export var label_vitesse_perihelie : Label
@export var label_excentricite : Label
@export var label_periode_revolution : Label
@export var label_periode_rotation : Label


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for planete in astres.planetes:
		#planete.planete_clique.connect(_on_astre_clique)
func _ready() -> void:
	for planete in get_tree().get_nodes_in_group("corps_celestes"):
		planete.astre_clique.connect(_on_astre_clique)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_astre_clique(astre : Astres) -> void:
	label_nom.text = astre.name
	label_masse.text = format_scientifique(astre.masse)
	label_vitesse_perihelie.text = "Vitesse au périhélie : %.1f m/s" % astre.vitesse_perihelie
	label_excentricite.text = "Excentricité : %.4f" % astre.excentricite
	label_periode_revolution.text = "Période de révolution : %.1f jours" % astre.periode_revolution
	label_periode_rotation.text = "Période de rotation : %.1f jours" % astre.periode_rotation

func format_scientifique(valeur : float) -> String:
	"""Converti en format scientifique les nombres décimaux avec 3 décimales
	
	Parametre:
	valeur -- la valeur à afficher de façon scientifique
	
	Retour:
	une chaîne de caractères représentant ce nombre
	"""
	var nombre_decimales = int(log(valeur) / log(10))
	var nombre_presente = valeur / 10**nombre_decimales
	return "%.3f" % nombre_presente + "e" + "%s" % nombre_decimales
