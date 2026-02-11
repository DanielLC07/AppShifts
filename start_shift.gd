extends Control

@onready var lbl_temporizador = $VBoxContainer/Temporizador
@onready var btn_jornada = $VBoxContainer/HBoxContainer/IniciarJornadaBT
@onready var alarma = %Alarma


const DURACION_JORNADA = 8 * 3600

var tiempo_restante: float = DURACION_JORNADA
var jornada_activa: bool = false

func _ready():
	lbl_temporizador.text = formatear_tiempo(tiempo_restante)

func _process(delta):
	if jornada_activa:
		tiempo_restante -= delta
		

		if tiempo_restante <= 0:
			tiempo_restante = 0.0 
			jornada_activa = false 
			
			lbl_temporizador.text = "00:00:00"
			
			btn_jornada.text = "JORNADA COMPLETADA"
			var estilo = btn_jornada.get_theme_stylebox("normal")
			estilo.bg_color = Color.DIM_GRAY
			
			sonar_alarma_repetida()
			
		else:
			lbl_temporizador.text = formatear_tiempo(tiempo_restante)

func sonar_alarma_repetida():
	for i in range(3): 
		if alarma.stream != null:
			alarma.play()
			await get_tree().create_timer(4.3).timeout
			
func _on_iniciar_jornada_bt_pressed():

	if tiempo_restante <= 0:
		return 


	jornada_activa = !jornada_activa 
	
	var estilo = btn_jornada.get_theme_stylebox("normal")
	
	if jornada_activa:
		btn_jornada.text = "PAUSAR / DESCANSO"
		estilo.bg_color = Color.FIREBRICK 
	else:
		btn_jornada.text = "REANUDAR JORNADA"
		estilo.bg_color = Color.FOREST_GREEN 
func _on_cerrar_sesion_bt_pressed():
	get_tree().change_scene_to_file("res://Login.tscn")

func formatear_tiempo(segundos_totales: float) -> String:
	var tiempo_int = int(ceil(segundos_totales))
	
	var segundos = tiempo_int % 60
	var minutos = (tiempo_int / 60) % 60
	var horas = (tiempo_int / 3600)
	
	return "%02d:%02d:%02d" % [horas, minutos, segundos]
