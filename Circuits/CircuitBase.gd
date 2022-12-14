extends Node2D

var base = null

func save():
	return get_base().save()

func get_base():
	if base == null:
		base = get_child(0)
	return base

func set_id(id):
	get_base().id = id

func get_id():
	return get_base().id

func select_node():
	var mouse_pos = get_viewport().get_mouse_position()
	get_parent().selected_node_offset = mouse_pos - get_base().global_position
	get_parent().selected_node = self

func unselect_node():
	get_parent().selected_node = null

func clicked_input(input, btn):
	get_parent().clicked_input(input, btn)

func clicked_output(output, btn):
	get_parent().clicked_output(output, btn)
	
func open_menu(_popup):
	pass

func menu_button_pressed(_action):
	pass
	
func reset():
	base.reset()

func run():
	pass
	
func is_mouse_inside(mouse_pos):
	return mouse_pos.x >= global_position.x && mouse_pos.x < global_position.x + get_base().get_size().x && mouse_pos.y >= global_position.y && mouse_pos.y < global_position.y + get_base().get_size().y
