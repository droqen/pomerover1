extends Node

@export var text_and_options_parent : Node
@onready var text : Label = text_and_options_parent.get_node("text")
@onready var options_parent : Node = text_and_options_parent.get_node("options")
var message : String
var message_len : int
var options_ct : int
var phase_printing_message : bool
var printing_chardelay : int
var phase_revealing_option : int = 0


func _ready() -> void:
	setup("Hello, this is message.\nPlease confirm reception of message.\nThankyou.", ["Confirm", "Not Confirm"])

func setup(text_message : String, options_strings : Array[String]) -> void:
	message = text_message
	message_len = len(message)
	text.text = text_message;
	options_ct = len(options_strings)
	for i in range(options_parent.get_child_count()):
		var opt : Button = options_parent.get_child(i)
		opt.disabled = true
		opt.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if i < options_ct:
			opt.show(); opt.text = options_strings[i]
		else:
			opt.hide(); opt.text = "-"
	reset();

func reset() -> void:
	phase_printing_message = true;
	phase_revealing_option = 0;
	text.visible_characters = 0
	for opt in options_parent.get_children():opt.modulate.a=0

func _physics_process(_delta: float) -> void:
	if phase_printing_message:
		printing_chardelay -= 1
		while printing_chardelay <= 0 and phase_printing_message:
			if text.visible_characters < message_len:
				var c : String = message[text.visible_characters]
				match c:
					'\n': printing_chardelay = 30
					' ': printing_chardelay = 5
					'.',',': printing_chardelay = 15
			text.visible_characters += 1
			if text.visible_characters >= message_len:
				phase_printing_message = false
				printing_chardelay = 30
	elif printing_chardelay > 0:
		printing_chardelay -= 1
	elif phase_revealing_option < options_ct:
		var opt : Button = options_parent.get_child(phase_revealing_option)
		opt.modulate.a += 0.02
		opt.disabled = false
		opt.mouse_filter = Control.MOUSE_FILTER_STOP
		if opt.modulate.a >= 1.00:
			phase_revealing_option += 1
