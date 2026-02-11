extends Control

@onready var input_correo = $VBoxContainer/HBoxContainer/InputCorreo
@onready var input_pass = $VBoxContainer/HBoxContainer2/InputCorreo 

func _ready():
	input_correo.grab_focus()

func _on_inicio_sesion_bt_pressed():
	var correo = input_correo.text
	var password = input_pass.text
	
	if correo == "usuario@ejemplo.com" and password == "123456":
		print("Login correcto. Cambiando escena...")
		get_tree().change_scene_to_file("res://start_shift.tscn") 
	else:
		print("Error: Datos incorrectos")

func _on_cerrar_bt_pressed():
	get_tree().quit()
