extends Control

onready var tree_task = $PanelContainer/Tree
var items : Array


#default functions
func _physics_process(_delta: float) -> void:
	if Global.delete_task[0]:
		delete_items(Global.delete_task[1])


#functions
func add_new_items( node_parent : String, name_item : String ) -> void:

	var tree

	if node_parent.length() > 0:
		tree = node_parent.split("_", true)
	
	if node_parent == "":

		var item = tree_task.create_item()
		item.set_text(0, name_item)
		items.append(item)

	else:
		for item in items:
			if tree.size() < 2:
				if item.get_text(0) == node_parent:
					create_new_item(item, name_item)
			else:
				if item.get_text(0) == tree[-1] and item.get_parent().get_text(0) == tree[-2]:
					create_new_item(item, name_item)


func create_new_item(item_parent, name_item) -> void:
	var new_item = tree_task.create_item(item_parent)
	new_item.set_cell_mode(0, 1)
	new_item.set_editable(0, true)
	new_item.set_text( 0, name_item )
	items.append(new_item)

func delete_items(node_task : String ) -> void:
	
	Global.delete_task = [false, ""]
	
	var content = node_task.split("_", true)
	
	for i in items:
	
		if content.size() == 2:
			var item = content[-1]
			var item_parent = content[-2]
			
			if i.get_text(0) == item and i.get_parent().get_text(0) == item_parent:
				i.get_parent().remove_child(i)
				items.erase(i)
			
		elif content.size() >= 3:
			var item = content[-1]
			var item_parent = content[-2]
			var item_grandparent = content[-3]
			
			if i.get_text(0) == item and i.get_parent().get_text(0) == item_parent:
				if i.get_parent().get_parent().get_text(0) == item_grandparent:
					i.get_parent().remove_child(i)
					items.erase(i)


func delete_all_items():
	tree_task.clear()
	items = []
