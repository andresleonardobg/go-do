tool
extends WindowDialog

onready var title_panel := get_node("container/title")
onready var description := get_node("container/description")
onready var box_comentary_child := get_node("container/box_commentary/VBoxContainer")
onready var new_comment_window := get_node("new_comment_window")
onready var get_new_comment := get_node("new_comment_window/VBoxContainer/TextEdit")
onready var re_open := get_node("container/open-close/re-open")
onready var name_new_item := get_node("container/subtasks/name_new_item")

var commentary = load("res://addons/go-do/scenes/commentary.tscn")

var node_task : Node

var comments : Array

#tree
onready var treee := get_node("container/Tree")
var root
var subtasks : Array
var info_item : Array #verify to delete
var item_selected : Object


func _ready():
	
	task_is_finished()
	
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


func _process(delta: float) -> void:
	task_is_finished()


func task_is_finished():
	var nodes_to_disable = [get_tree().get_nodes_in_group("buttons"), get_tree().get_nodes_in_group("texts")]
	
	if node_task.info_about_node["finished"]:
		re_open.disabled = false
		
		for b in nodes_to_disable[0]:
			b.disabled = true
		
		for t in nodes_to_disable[1]:
			t.readonly = true
		
		for c in box_comentary_child.get_children():
			c.disable_button = true
		
	else:
		re_open.disabled = true
		
		for b in nodes_to_disable[0]:
			b.disabled = false
		
		for t in nodes_to_disable[1]:
			t.readonly = false
		
		for c in box_comentary_child.get_children():
			c.disable_button = false


func _on_info_node_popup_hide():
	
	if title_panel.text != "":
		node_task.info_about_node["name_task"] = title_panel.text
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
	var new_commentary = commentary.instance()
	new_commentary.panel_info = self
	new_commentary.disable_button = node_task.info_about_node["finished"]
	new_commentary.text_commentary = text_comment
	box_comentary_child.add_child(new_commentary)


#signals
func _on_add_new_item_pressed():
	if name_new_item.text != "":
		create_new_item(name_new_item.text)
		name_new_item.text = ""


func _on_Tree_item_selected():
	item_selected = treee.get_selected()


func _on_add_new_commentary_pressed():
	new_comment_window.popup_centered()


func _on_add_comment_pressed():
	new_commentary( get_new_comment.text )
	get_new_comment.text = ""
	new_comment_window.visible = false


func _on_delete_item_pressed():
	root.remove_child(item_selected)
	if subtasks.has(item_selected):
		print('iteme existe en subtasks')
		subtasks.erase(item_selected)
	item_selected.free()
	print("item seleccionado")


func _on_finished_pressed() -> void:
	
	var can_finish := false
	
	if every_child_is_finished():
		node_task.node_task_finished( true )


func every_child_is_finished() -> bool:
	var childs := get_tree().get_nodes_in_group(node_task.name)
	print(childs.size())
	if childs.size() > 1:
		for child in childs:
			if child.info_about_node["finished"] == false and child.name != node_task.name:
				print(child.name)
				print(child.info_about_node["finished"])
				print("los hijos aun no estan finalizados")
				return false
				break
	print("se puede finalizar la tarea")
	return true

func _on_reopen_pressed() -> void:
	node_task.re_open()
	node_task.emit_signal("task_finished_state")
	node_task.info_about_node["finished"] = false
