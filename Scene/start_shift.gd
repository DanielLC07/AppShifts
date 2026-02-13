extends Control

@onready var lbl_temporizador = $VBoxContainer/Temporizador
@onready var btn_jornada = $VBoxContainer/HBoxContainer/IniciarJornadaBT
@onready var alarma = %Alarma 

const DURACION_JORNADA = 5


var tiempo_restante: float = DURACION_JORNADA
var jornada_activa: bool = false

var hora_inicio_str: String = "" 

func _process(delta):
	if jornada_activa:
		tiempo_restante -= delta
		
		if tiempo_restante <= 0:
			tiempo_restante = 0
			jornada_activa = false
			
			lbl_temporizador.text = "00:00:00"
			btn_jornada.text = "¡JORNADA COMPLETADA!"
			btn_jornada.get_theme_stylebox("normal").bg_color = Color.DIM_GRAY
			
			alarma.play() 
			
			terminar_y_guardar()

		else:
			lbl_temporizador.text = formatear_tiempo(tiempo_restante)

func _on_iniciar_jornada_bt_pressed():
	if tiempo_restante <= 0: return 

	jornada_activa = !jornada_activa 
	
	# --- NUEVO: CAPTURAR HORA DE INICIO (Solo la primera vez) ---
	if jornada_activa and hora_inicio_str == "":
		hora_inicio_str = Time.get_time_string_from_system()
		print("Hora inicio registrada: " + hora_inicio_str)
	
	var estilo = btn_jornada.get_theme_stylebox("normal")
	if jornada_activa:
		btn_jornada.text = "PAUSAR / DESCANSO"
		estilo.bg_color = Color.FIREBRICK 
	else:
		btn_jornada.text = "REANUDAR JORNADA"
		estilo.bg_color = Color.FOREST_GREEN


func terminar_y_guardar():
	var hora_final_str = Time.get_time_string_from_system()
	

	var segundos_trabajados = DURACION_JORNADA - tiempo_restante
	var texto_horas = formatear_tiempo(segundos_trabajados)
	
	DataManager.guardar_jornada(hora_inicio_str, hora_final_str, texto_horas)


func formatear_tiempo(segundos_totales: float) -> String:
	var tiempo_int = int(ceil(segundos_totales))
	var segundos = tiempo_int % 60
	var minutos = (tiempo_int / 60) % 60
	var horas = (tiempo_int / 3600)
	return "%02d:%02d:%02d" % [horas, minutos, segundos]

func _on_cerrar_sesion_bt_pressed():
	get_tree().change_scene_to_file("res://Scene/login.tscn")
