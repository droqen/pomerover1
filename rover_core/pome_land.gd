@tool
extends Node2D
class_name PomeLand
@export var labelsettings : LabelSettings
func _physics_process(_delta: float) -> void:
	for child in get_children():
		var pome_node : PomeNode = (child as PomeNode)
		if pome_node == null: continue;
		if labelsettings != null:
			pome_node.update_labels(self, labelsettings)
