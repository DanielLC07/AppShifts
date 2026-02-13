extends Control

@onready var input_email = $VBoxContainer/HBoxContainer2/InputCorreo
@onready var input_pass = $VBoxContainer/HBoxContainer3/InputCorreo # O InputPass
@onready var lbl_mensaje = $VBoxContainer/LabelMensaje # Opcional: Para mostrar errores

func _on_sign_upbt_pressed() -> void:
	var email = input_email.text
	var password = input_pass.text
	get_tree().change_scene_to_file("res://Scene/login.tscn")
	
	
	if email == "" or password == "":
		print("Campos vacíos")
		return

	var registro_exitoso = DataManager.registrar_usuario(email, password)
	
	if registro_exitoso:
		print("¡Usuario creado!")
		get_tree().change_scene_to_file("res://Scene/login.tscn")
	else:
		print("Error: El usuario ya existe")
