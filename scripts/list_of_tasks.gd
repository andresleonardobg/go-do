extends Control

onready var tree_task = $PanelContainer/Tree

var items : Array

var tree

#signals

#functions
func add_new_items( node_parent : String, name_item : String ) -> void:

	if node_parent.length() > 0:
		tree = node_parent.split("-", true)
	
	if node_parent == "":
		var item = tree_task.create_item()
		item.add_to_group(name_item)
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
	


func create_new_item(item, name_item) -> void:
	var new_item = tree_task.create_item(item)
	new_item.add_to_group(name_item)
	new_item.set_cell_mode(0, 1)
	new_item.set_editable(0, true)
	new_item.set_text( 0, name_item )
	items.append(new_item)
