extends Control
class_name InterfaceInfos

# --- Valeurs pour les labels de l'interface --- #
@export var astres : Node
@export var label_nom : Label
@export var label_masse : Label
@export var label_vitesse_perihelie : Label
@export var label_excentricite : Label
@export var label_periode_revolution : Label
@export var label_periode_rotation : Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Cache l'interface des infos de planète au début
	visible = false
	for planete in get_tree().get_nodes_in_group("corps_celestes"):
		planete.astre_clique.connect(_on_astre_clique)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Cache l'interface — elle se réaffichera si un astre est cliqué
		visible = false

func _on_astre_clique(astre : Astres) -> void:
	visible = true
	label_nom.text = astre.name
	label_masse.text = format_scientifique(astre.masse) + " kg"
	label_vitesse_perihelie.text = str(int(astre.vitesse_perihelie)) + " m/s"
	label_excentricite.text = str(astre.excentricite)
	label_periode_revolution.text = str(astre.periode_revolution) + " jours"
	label_periode_rotation.text = str(astre.periode_rotation) + " jours"
	
	

func format_scientifique(valeur : float) -> String:
	"""Converti en format scientifique les nombres décimaux avec 3 décimales
	
	Parametre:
	valeur -- la valeur à afficher de façon scientifique
	
	Retour:
	une chaîne de caractères représentant ce nombre
	"""
	var nombre_decimales = int(log(valeur) / log(10))
	var nombre_presente = valeur / 10.0**nombre_decimales
	return "%.3f" % nombre_presente + "e" + "%s" % nombre_decimales
