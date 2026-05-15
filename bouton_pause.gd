# Permet de mettre en pause ou de relancer la simulation
extends Button

@export var interface : Interface

@export_group("Textes possibles pour le bouton")
@export var texte_pause : String = "Pause"
@export var texte_reprendre : String = "Reprendre"

var pause : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Initialise la scène pas sur pause
	pause = false
# Execute la fonction changer_etat_pause lorsque le bouton est cliqué
	pressed.connect(changer_etat_pause)

func changer_etat_pause() -> void:
	"""Bascule l'état de pause du jeu entre en cours et en pause. Met à jour
	les objets avec l'information"""
	pause = !pause
	interface.changer_etat_pause(pause)
	
	if pause :
		text = texte_reprendre
	else:
		text = texte_pause
	
