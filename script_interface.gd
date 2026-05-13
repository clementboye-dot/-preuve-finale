extends Control
class_name Interface
@export_group("Planètes")
@export var astres : ListeAstres
@export_group("Interface")
@export var slider : HSlider
@export var label_temps : Label

###Valeurs d'échelle de temps###
#Valeur minimale : 1s réelle = 1 mois de simulation
const ECHELLE_MIN = 2629800.0
#Valeur maximale : 1s réelle = 10 ans de simulation
const ECHELLE_MAX = 315576000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Configure le slider
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = 0.0  # Commence à 1s = 1 mois

# Connecte le signal
	slider.value_changed.connect(_on_slider_value_changed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_slider_value_changed(valeur : float) -> void:
	# Interpolation logarithmique pour avoir une progression naturelle
	var echelle = ECHELLE_MIN * pow(ECHELLE_MAX / ECHELLE_MIN, valeur)
	for planete in astres.planetes:
		planete.echelle_temps = echelle
	_mettre_a_jour_label(valeur)
func _mettre_a_jour_label(valeur : float) -> void:
	var echelle = ECHELLE_MIN * pow(ECHELLE_MAX / ECHELLE_MIN, valeur)
# Affiche en mois ou en ans selon la valeur
	if echelle < 31557600.0:
		var mois = echelle / 2629800.0
		label_temps.text = "%.1f mois / seconde" % mois
	else:
		var ans = echelle / 31557600.0
		label_temps.text = "%.1f ans / seconde" % ans
