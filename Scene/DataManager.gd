extends Node

const ARCHIVO_USUARIOS = "user://usuarios.json"
var base_de_datos = {}

var usuario_actual: String = "" 

func _ready():
	cargar_datos()

func registrar_usuario(email, password):
	if base_de_datos.has(email):
		return false
	
	base_de_datos[email] = {
		"password": password,
		"fecha_registro": Time.get_datetime_string_from_system(),
		"historial": [] 
	}
	guardar_en_disco()
	return true

func verificar_login(email, password):
	if not base_de_datos.has(email):
		return false
	
	if base_de_datos[email]["password"] == password:
		usuario_actual = email 
		return true
	
	return false

func guardar_jornada(hora_inicio, hora_final, horas_trabajadas):
	if usuario_actual == "" or not base_de_datos.has(usuario_actual):
		return
	
	if not base_de_datos[usuario_actual].has("historial"):
		base_de_datos[usuario_actual]["historial"] = []
	
	var nueva_entrada = {
		"fecha": Time.get_date_string_from_system(),
		"inicio": hora_inicio,
		"fin": hora_final,
		"tiempo_total": horas_trabajadas
	}
	
	base_de_datos[usuario_actual]["historial"].append(nueva_entrada)
	guardar_en_disco()
	print("Jornada guardada en JSON correctamente")

func guardar_en_disco():
	var archivo = FileAccess.open(ARCHIVO_USUARIOS, FileAccess.WRITE)
	var json_texto = JSON.stringify(base_de_datos, "\t")
	archivo.store_string(json_texto)
	archivo.close()

func cargar_datos():
	if FileAccess.file_exists(ARCHIVO_USUARIOS):
		var archivo = FileAccess.open(ARCHIVO_USUARIOS, FileAccess.READ)
		var error = JSON.parse_string(archivo.get_as_text())
		if error != null:
			base_de_datos = error
