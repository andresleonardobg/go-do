tool
extends WindowDialog

onready var title_panel := get_node("title")
onready var description := get_node("description")
onready var box_comentary_child := get_node("box_commentary/VBoxContainer")
onready var window_new_comment := get_node("new_comment_window")
onready var get_new_comment := get_node("new_comment_window/VBoxContainer/TextEdit")

var node_task : Node

var comments : Array

#tree
onready var treee := get_node("Tree")
var root
onready var name_new_item := get_node("HBoxContainer/name_new_item")
var subtasks : Array
var info_item : Array #verify to delete
var item_selected : Object


func _ready():
	root = treee.create_item()
	root.set_text(0, "Subtareas")
	
	#show info_about_node in panel
	title_panel.text = node_task.info_about_node["name_task"]
	
	if "description" in node_task.info_about_node:
		description.text = node_task.info_about_node["description"]
	else:
		description.text = ""
	
	if "comments" in node_task.info_about_node && node_task.info_about_node["comments"].size() != 0:
		for comment in node_task.info_about_node["comments"]:
			new_commentary(comment)
	
	if "subtasks" in node_task.info_about_node && node_task.info_about_node["subtasks"].size() != 0:
		for sub_task in node_task.info_about_node["subtasks"]:
			create_new_item( sub_task[0], sub_task[1] )


func _on_info_node_popup_hide():
#
	if description.text != "":
		node_task.info_about_node["description"] = description.text

	if subtasks.size() != 0:
		node_task.info_about_node["subtasks"] = subtasks

	if comments.size() != 0:
		node_task.info_about_node["comments"] = comments
	
	
	var info_subtasks := []
	
	if subtasks.size() != 0:
		for task in subtasks:
			info_subtasks.append([ task.get_text(0), task.is_checked(0) ])
	
	node_task.info_about_node["subtasks"] = info_subtasks
	
	queue_free()

#functions
func create_new_item( name_subtask : String, checked : bool = false) -> void:
	var child = treee.create_item(root)
	child.set_cell_mode(0, 1)
	child.set_text(0, name_subtask)
	child.set_editable(0, true)
	child.set_checked(0, checked)
	subtasks.append(child)


func get_info_form_items() -> Array:
	var info : Array	
	for i in subtasks:
		info.push_back([i.get_text(0), i.is_checked(0)])	
	return info


func new_commentary( text_comment : String ) -> void:
	comments.append(text_comment)
	var new_commentary = Label.new()
	new_commentary.autowrap = true
	new_commentary.rect_min_size = Vector2(530, 50)
	new_commentary.text = text_comment
	box_comentary_child.add_child(new_commentary)


#signals
func _on_add_new_item_pressed():
	if name_new_item.text != "":
		create_new_item(name_new_item.text)
		name_new_item.text = ""


func _on_Tree_item_selected():
	item_selected = treee.get_selected()


func _on_add_new_commentary_pressed():
	window_new_comment.popup_centered()


func _on_add_comment_pressed():
	new_commentary( get_new_comment.text )
	get_new_comment.text = ""
	window_new_comment.visible = false


func _on_delete_item_pressed():
	root.remove_child(item_selected)
	if subtasks.has(item_selected):
		print('iteme existe en subtasks')
		subtasks.erase(item_selected)
	item_selected.free()
	print("item seleccionado")


func _on_finished_pressed() -> void:
	node_task.node_task_finished( true )
	print("finalizar tarea")
