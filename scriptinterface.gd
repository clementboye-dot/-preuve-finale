extends Node2D

@onready var label_nom = $Panel/Nom
@onready var label_masse = $Panel/Masse
@onready var label_excentricité = $Panel/Excentricité
@onready var label_périoderévolution = $Panel/Périoderévolution
@onready var label_périoderotation = $Panel/Périoderotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func mettre_a_jour_interface(nom: String, masse: float):
	show() # Affiche le panneau
	label_nom.text = nom
	label_masse.text = "Masse : " + str(masse_p) + " kg"
