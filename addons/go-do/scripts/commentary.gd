tool
extends Control

var text_commentary : String
var panel_info : Node
var disable_button := false
onready var text_container := get_node("PanelContainer/VBoxContainer/Label")
onready var button := get_node("PanelContainer/VBoxContainer/Button")

func _ready() -> void:
	text_container.text = text_commentary

func _process(delta: float) -> void:
	print(disable_button)
	if disable_button:
		button.disabled = disable_button
		#print("boton desactivado")
	else:
		button.disabled = disable_button
		#print("boton activado")

func _on_Button_pressed() -> void:
	var index = panel_info.comments.find(text_container.text)
	panel_info.comments.remove(index)
	queue_free()
