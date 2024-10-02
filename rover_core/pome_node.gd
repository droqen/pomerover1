@tool
extends Node2D
class_name PomeNode
#@export var pome : Pome

@export_multiline var pome : String

@export var exits : Array[PomeLink] = []

var labelsettings : LabelSettings
var connection_vectors : Array[Vector2]
var connection_labels : Array[String]

func _physics_process(_delta: float) -> void:
	queue_redraw()

func update_labels(pomeparent : Node, labelsettings : LabelSettings) -> void:
	self.labelsettings = labelsettings
	if len(exits) != len(connection_vectors):
		connection_vectors.clear()
		connection_labels.clear()
		for i in range(len(exits)):
			var other = pomeparent.get_node_or_null(exits[i].pomename)
			connection_vectors.append(Vector2.ONE*20 if other==null else other.position-position)
			connection_labels.append(exits[i].label)
	else:
		for i in range(len(exits)):
			var other = pomeparent.get_node_or_null(exits[i].pomename)
			connection_vectors[i] = Vector2.ONE*20 if other==null else other.position-position
			connection_labels[i] = exits[i].label

func _draw() -> void:
	if labelsettings:
		draw_string(labelsettings.font,
		Vector2(0,-16), name)
		draw_multiline_string(
			labelsettings.font,
			Vector2.ZERO, pome, HORIZONTAL_ALIGNMENT_CENTER, -1,
			labelsettings.font_size, -1,
			labelsettings.font_color)
	for i in range(len(connection_vectors)):
		draw_arrow(Vector2.ZERO, connection_vectors[i])
		draw_string(labelsettings.font,
			connection_vectors[i]/4, connection_labels[i], HORIZONTAL_ALIGNMENT_CENTER, -1,
			labelsettings.font_size * 2 / 3,
			labelsettings.font_color)

func draw_arrow(a:Vector2,b:Vector2) -> void:
	var arrowdir = (b-a).normalized()
	var arrowlen = a.distance_to(b)
	var arrowheadtip = arrowdir * 0.95 * arrowlen
	var arrowheadlen = max(20, arrowlen*0.1)
	var arrowheadbase = arrowheadtip - arrowdir * arrowheadlen
	var sideways = arrowdir.rotated(PI*0.5)
	draw_line(arrowdir * 0.05 * arrowlen, arrowheadbase, Color(1,1,1,.25), 3, true)
	draw_colored_polygon([
		arrowheadbase + sideways * arrowheadlen/2,
		arrowheadbase - sideways * arrowheadlen/2,
		arrowheadtip,
	], Color(1,1,1,.25))
