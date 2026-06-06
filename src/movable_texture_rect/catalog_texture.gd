class_name CatalogTexture
extends Control

@export var target_parent: Control
var current_copy: MovableTextureRect

func _ready() -> void:
	if not target_parent:
		target_parent = get_parent() # just for testing

func set_texture(texture: Texture2D) -> void:
	%MovableTextureRect.texture = texture

func get_texture() -> Texture2D:
	return %MovableTextureRect.texture

func _on_movable_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if current_copy and mouse_event.button_index == MOUSE_BUTTON_LEFT and !mouse_event.pressed:
			current_copy.toggle_drag(false)
			get_viewport().set_input_as_handled()
			return
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			# Crear una copia de la textura para que siga al ratón, dejar esta fija
			var scene: PackedScene = preload("res://src/movable_texture_rect/movable_texture_rect.tscn")
			var copy: MovableTextureRect = scene.instantiate()
			copy.texture = %MovableTextureRect.texture
			target_parent.add_child(copy)
			copy.global_position = global_position
			copy.toggle_drag(true)
			current_copy = copy
			copy.ended_dragging.connect(_on_texture_ended_dragging, CONNECT_APPEND_SOURCE_OBJECT)
			get_viewport().set_input_as_handled()
			return

func _on_texture_ended_dragging(texture: MovableTextureRect) -> void:
	# Controlar que quede dentro del lienzo
	var texture_rect := Rect2(texture.get_global_rect())
	texture_rect.size = texture.texture.get_size()
	#print(target_parent.get_global_rect())
	#print(texture_rect)
	if not target_parent.get_global_rect().encloses(texture_rect):
		texture.queue_free()
