extends Control
class_name Interface
@export_group("Planètes")
@export var astres : ListeAstres
@export_group("Interface")
@export var slider : HSlider
@export var label_temps : Label
@export var label_date : Label

# --- Valeurs d'échelle de temps --- #
#Valeur minimale : 1s réelle = 1 mois de simulation
const ECHELLE_MIN = 2629800.0
#Valeur maximale : 1s réelle = 10 ans de simulation
const ECHELLE_MAX = 315576000.0

# --- Date de simulation --- #
var temps_ecoule : float = 0.0
var date_initialisation : Dictionary = {"day": 1, "month": 1, "year": 2026, "hour": 0, "minute": 0, "second": 0}
var echelle_actuelle : float = 2629800.0 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Configure le slider
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = 0.0

# Connecte le signal
	slider.value_changed.connect(_on_slider_value_changed)
	_mettre_a_jour_label(slider.value)

var pause = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
# Arrête le temps de simulation lorsqu'en Pause, 
# sinon calcule le temps passé pour afficher la date depuis le 1 Janvier 2026, 
# soit les positions initiales des planètes
	if pause == false:
		temps_ecoule += delta * echelle_actuelle
		_mettre_a_jour_date()
	
	
	
func _on_slider_value_changed(valeur : float) -> void:
	""" Effectue une interpolation logarithmique pour les valeurs
	de l'échelle de temps du slider
	Paramètre:
		valeur -- valeur du slider, comprise en 0.0 et 1.0, envoyée lorsqu'elle est modifiée
	"""
	var echelle = ECHELLE_MIN * pow(ECHELLE_MAX / ECHELLE_MIN, valeur)
	echelle_actuelle = echelle
	for planete in astres.planetes:
		planete.echelle_temps = echelle
	_mettre_a_jour_label(valeur)

func _mettre_a_jour_label(valeur : float) -> void:
	"""Affiche la valeur du temps simulé en équivalent du temps réel
	
	Paramètre:
		valeur -- valeur du slider, comprise en 0.0 et 1.0, envoyée lorsqu'elle est modifiée
	 """
	var echelle = ECHELLE_MIN * pow(ECHELLE_MAX / ECHELLE_MIN, valeur)
# Affiche l'échelle de temps en mois ou en ans selon la valeur
	if echelle < 31557600.0:
		var mois = echelle / 2629800.0
		label_temps.text = "%.1f mois" % mois
	else:
		var ans = echelle / 31557600.0
		label_temps.text = "%.1f ans" % ans

func _mettre_a_jour_date() -> void:
	"""Affiche dans l'interface la date simulée à partir du temps de simulation écoulé
	"""
	var jours_ecoules = int(temps_ecoule / 86400.0)
	var date = Time.get_datetime_dict_from_unix_time(
		Time.get_unix_time_from_datetime_dict(date_initialisation) + int(temps_ecoule)
		)
	label_date.text = "%02d/%02d/%04d" % [date["day"], date["month"], date["year"]]

func changer_etat_pause(etat_pause : bool) -> void:
	"""Change l'état de pause à chacun des astres
	
	Paramètre :
	etat_pause -- est-ce que la simulation est en pause ou non """
	pause = etat_pause
	for planete in astres.planetes:
		planete.mettre_en_pause(etat_pause)
