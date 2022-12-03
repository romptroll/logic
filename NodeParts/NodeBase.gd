extends Node2D

var input_node_scene = load("res://NodeParts/NodeInput.tscn")
var output_node_scene = load("res://NodeParts/NodeOutput.tscn")

var inputs = null
var outputs = null

var input_nodes = null
var output_nodes = null

var id = -1
var old_values = []
var values = []

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		if is_mouse_inside(mouse_pos):
			if event.is_action_pressed("mouse_left"):
				get_parent().select_node()
			elif event.is_action_released("mouse_left"):
				get_parent().unselect_node()
		
func get_value(io):
	if io is NodeOutput:
		return old_values[outputs.find(io)]
	elif io is NodeInput:
		return old_values[inputs.find(io)]
	else:
		assert(false)

func is_mouse_inside(mouse_pos):
	return mouse_pos.x >= global_position.x && mouse_pos.x < global_position.x + 128 && mouse_pos.y >= global_position.y && mouse_pos.y < global_position.y + 128
	
func set_inputs(new_input_nodes):
	input_nodes = new_input_nodes
	inputs = []
	for i in input_nodes.size():
		var input_node_instance = input_node_scene.instance()
		input_node_instance.position.y = (128 / (self.input_nodes.size() + 1))*(i+1)
		input_node_instance.position.x = -10
		input_node_instance.id = i
		add_child(input_node_instance)
		inputs.push_back(input_node_instance)
	return self
		
func set_outputs(new_output_nodes):
	output_nodes = new_output_nodes
	outputs = []
	for i in output_nodes.size():
		var output_node_instance = output_node_scene.instance()
		output_node_instance.position.y = (128 / (output_nodes.size() + 1))*(i+1)
		output_node_instance.position.x = 128+10
		output_node_instance.id = 0
		add_child(output_node_instance)
		outputs.push_back(output_node_instance)
	values.resize(outputs.size())
	values.fill(false)
	old_values.resize(outputs.size())
	old_values.fill(false)
	return self
	
func reset():
	old_values = values
	
func clicked_input(input, btn):
	get_parent().clicked_input(input, btn)

func clicked_output(output, btn):
	get_parent().clicked_output(output, btn)
	
func id():
	return id

func save():
	var node_inputs = []
	for input in inputs:
		node_inputs.push_back(input.save())
	
	var node_outputs = []
	for output in outputs:
		node_outputs.push_back(output.save())
	
	var save_dict = {
		"id": id(),
		"inputs": node_inputs,
		"outputs": node_outputs
	}
	
	return save_dict
