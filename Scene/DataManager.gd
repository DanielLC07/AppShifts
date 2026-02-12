extends Node

const ARCHIVO_USUARIOS = "user://usuarios.json"
var base_de_datos = {}

# --- NUEVO: Variable para saber quién está usando la app ---
var usuario_actual: String = "" 

func _ready():
	cargar_datos()

func registrar_usuario(email, password):
	if base_de_datos.has(email):
		return false
	
	base_de_datos[email] = {
		"password": password,
		"fecha_registro": Time.get_datetime_string_from_system(),
		"historial": [] # --- NUEVO: Creamos una lista vacía para sus jornadas
	}
	guardar_en_disco()
	return true

func verificar_login(email, password):
	if not base_de_datos.has(email):
		return false
	
	if base_de_datos[email]["password"] == password:
		# --- NUEVO: Recordamos quién ha entrado ---
		usuario_actual = email 
		return true
	
	return false

# --- NUEVO: FUNCIÓN PARA GUARDAR LA JORNADA ---
func guardar_jornada(hora_inicio, hora_final, horas_trabajadas):
	# Seguridad: Si no hay nadie logueado o el usuario no existe, salimos
	if usuario_actual == "" or not base_de_datos.has(usuario_actual):
		return
	
	# Aseguramos que tenga la lista de historial (por si es un usuario antiguo)
	if not base_de_datos[usuario_actual].has("historial"):
		base_de_datos[usuario_actual]["historial"] = []
	
	# Creamos el registro
	var nueva_entrada = {
		"fecha": Time.get_date_string_from_system(),
		"inicio": hora_inicio,
		"fin": hora_final,
		"tiempo_total": horas_trabajadas
	}
	
	# Lo añadimos a su lista y guardamos
	base_de_datos[usuario_actual]["historial"].append(nueva_entrada)
	guardar_en_disco()
	print("Jornada guardada en JSON correctamente")

# ... (Mantén tus funciones guardar_en_disco y cargar_datos igual que antes) ...
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
