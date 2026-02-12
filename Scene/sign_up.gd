extends Control
# REFERENCIAS (Ajusta las rutas a tu escena real)
@onready var input_email = $VBoxContainer/HBoxContainer2/InputCorreo
@onready var input_pass = $VBoxContainer/HBoxContainer3/InputCorreo # O InputPass
@onready var lbl_mensaje = $VBoxContainer/LabelMensaje # Opcional: Para mostrar errores

func _on_sign_upbt_pressed() -> void:
	var email = input_email.text
	var password = input_pass.text
	get_tree().change_scene_to_file("res://Scene/login.tscn")
	
	
	# Validaciones básicas
	if email == "" or password == "":
		print("Campos vacíos")
		return

	# USAMOS EL DATA MANAGER GLOBAL
	var registro_exitoso = DataManager.registrar_usuario(email, password)
	
	if registro_exitoso:
		print("¡Usuario creado!")
		# Volver al login automáticamente
		get_tree().change_scene_to_file("res://Scene/login.tscn")
	else:
		print("Error: El usuario ya existe")
		# Aquí podrías poner un texto en rojo en la pantalla
