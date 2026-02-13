extends Control

@onready var input_correo = $VBoxContainer/HBoxContainer/InputCorreo
@onready var input_pass = $VBoxContainer/HBoxContainer2/InputPassword

func _on_inicio_sesion_bt_pressed():
	var email = input_correo.text
	var password = input_pass.text
	
	if DataManager.verificar_login(email, password):
		print("Login correcto. Entrando...")
		get_tree().change_scene_to_file("res://Scene/start_shift.tscn")
	else:
		print("Error: Usuario o contraseña incorrectos")

func _on_sign_upbt_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/SignUp.tscn")
	
func _on_cerrar_bt_pressed() -> void:
	get_tree().quit()
