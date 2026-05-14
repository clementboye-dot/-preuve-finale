# Permet de mettre en pause ou de relancer la simulation
extends Button

var pause : bool
@export var interface : Interface

@export_group("Textes possibles pour le bouton")
@export var texte_pause : String = "Pause"
@export var texte_reprendre : String = "Reprendre"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause = false
	# Lorsque le bouton est appuyé, la fonction entre parenthèses est exécutée.
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
	
