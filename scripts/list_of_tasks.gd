extends Control

onready var tree_task = $PanelContainer/Tree

func _ready() -> void:
	
	Global.load_data()
	
	var project = tree_task.create_item()
	project.set_text(0, Global.data["nodes"][0]["name_task"])
	
	var list : Array = []
	
	for n in Global.data["nodes"]:
		if n["name_task"] != Global.data["nodes"][0]["name_task"] and n["parent"] != Global.data["nodes"][0]["name_task"]:
			
			var child = tree_task.create_item(project)
			child.set_text(0, n["name_task"])
			list.append(child)
#		else:
#			for i in list:
#				if n["parent"] == i.get_text(0):
#					var child = tree_task.create_item(i)
#					list.append(child)
	
	
	print(list[0].get_text(0))
#	var root = tree_task.create_item()
#	root.set_text(0, "proyecto")
#	var child1 = tree_task.create_item(root)
#	child1.set_text(0,"hijo uno")
#	var child2 = tree_task.create_item(root)
#	child2.set_text(0,"hijo dos")
#	var subchild1 = tree_task.create_item(child1)
#	subchild1.set_text(0, "Subchild1")
