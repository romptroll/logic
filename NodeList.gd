extends Node2D 

var selected_node = null
var selected_io = null

var inputs = []
var outputs = []

var nodes = []

var test_values = {}

var input_node_scene = load("res://NodeParts/NodeInput.tscn")
var output_node_scene = load("res://NodeParts/NodeOutput.tscn")

var timer = 0
var t = 0

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resized")

func _draw():
	if selected_io != null:
		draw_line(get_viewport().get_mouse_position(), selected_io.global_position, Color.white, 5.0)

func on_resized():
	reposition_inputs()
	reposition_outputs()
		
func _process(delta):
	timer += delta
	t += 1
	if timer >= 1.0:
		timer -= 1.0
		print("TICK: " + String(t))
		t = 0
	for _i in range(1):
		for node in nodes:
			node.run()
		for node in nodes:
			node.reset()
	if selected_node != null:
		var pos = get_viewport().get_mouse_position()
		var size = selected_node.get_base().get_size()
		selected_node.set_position(Vector2(pos.x-size.x/2, pos.y-size.y/2))
	update()

func set_n_inputs(n_inputs):
	if n_inputs >= 0:
		for input in inputs:
			if get_children().has(input):
				remove_child(input)
		inputs = []
		for i in range(n_inputs):
			var input_node_instance = output_node_scene.instance()
			input_node_instance.id = i
			add_child(input_node_instance)
			inputs.push_back(input_node_instance)
		reposition_inputs()
	
func set_n_outputs(n_outputs):
	if n_outputs >= 0:
		for output in outputs:
			if get_children().has(output):
				remove_child(output)
		outputs = []
		for i in range(n_outputs):
			var output_node_instance = input_node_scene.instance()
			output_node_instance.id = i
			add_child(output_node_instance)
			outputs.push_back(output_node_instance)
		reposition_outputs()

func reposition_outputs():
	var window_size = get_viewport_rect().size;
	for i in range(outputs.size()):
		var output = outputs[i]
		output.position.y = (window_size.y / (outputs.size() + 1))*(i+1)
		output.position.x = window_size.x-16;

func reposition_inputs():
	var window_size = get_viewport_rect().size;
	for i in range(inputs.size()):
		var input = inputs[i]
		input.position.y = (window_size.y / (inputs.size() + 1))*(i+1)
		input.position.x = 128;

func clicked_input(input, btn):
	if btn == BUTTON_LEFT:
		if selected_io == null:
			selected_io = input
		elif selected_io is NodeOutput:
			selected_io.connect_node(input)
			selected_io = null
		else:
			selected_io = input
			update()
	else:
		pass

func clicked_output(output, btn):
	if btn == BUTTON_LEFT:
		if selected_io == null:
			selected_io = output
		elif selected_io is NodeInput:
			selected_io.connect_node(output)
			selected_io = null
		else:
			selected_io = output
		update()
	elif btn == BUTTON_RIGHT:
		if test_values.has(output):
			test_values[output] = !test_values[output]
		else:
			test_values[output] = true
	
func delete():
	for node in get_children():
		remove_child(node)
	selected_io = null
	selected_node = null
	nodes = []

	set_n_inputs(inputs.size())
	set_n_outputs(outputs.size())
	test_values = {}
	

func id():
	return 0
	
func save_custom(node_name):
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("nodes")
	
	var save_game = File.new()
	var error = save_game.open("user://nodes/"+node_name+".save", File.WRITE)
	if error:
		push_error("ERORR OPENING FILE : " + String(error))
	
	var node_inputs = []
	for input in inputs:
		node_inputs.push_back(input.save())
	
	var node_outputs = []
	for output in outputs:
		node_outputs.push_back(output.save())
		
	var nodes_saved = []
	for node in nodes:
		nodes_saved.push_back(node.save())
		
	var save_dict = {
		"name": node_name,
		"inputs": node_inputs,
		"outputs": node_outputs,
		"nodes": nodes_saved
	}
	
	print(to_json(save_dict))
	
	save_game.store_line(to_json(save_dict))
	save_game.close()
	
func create(node):
	selected_node = node
	selected_node.set_id(nodes.size()+1)
	nodes.push_back(selected_node)
	add_child(selected_node)
	pass

func get_value(io):
	if test_values.has(io):
		return test_values[io]
	else:
		return false
	
