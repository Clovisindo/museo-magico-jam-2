class_name Canvas
extends Node2D

const PIECES_DIR := "res://assets/pieces/"

func _ready() -> void:
	%Confirmation.hide()
	%Main.show()
	# Cargar imágenes:
	for file: String in DirAccess.get_files_at(PIECES_DIR):
		if file.ends_with(".import"):
			continue
		var filepath := PIECES_DIR.path_join(file)
		var scene := preload("res://src/movable_texture_rect/catalog_texture.tscn")
		var new_catalog_texture: CatalogTexture = scene.instantiate()
		var texture = load(filepath)
		new_catalog_texture.target_parent = %CanvasRect
		new_catalog_texture.set_texture(texture)
		new_catalog_texture.z_index = 100
		%PieceContainer.add_child(new_catalog_texture)

func create_composite_texture() -> CompositeTexture:
	var new_composite := CompositeTexture.new()
	var pieces: Array[TextureRect] = []
	var positions: Array[Vector2] = []
	for child: Node in %CanvasRect.get_children():
		if child is MovableTextureRect:
			var copy := TextureRect.new()
			copy.texture = child.texture
			pieces.push_back(copy)
			positions.push_back(child.position)
	new_composite.init(pieces, positions)
	return new_composite

func _on_submit_button_pressed() -> void:
	%Main.hide()
	%Confirmation.show()
	var canvas_panel: Control = %CanvasPanel
	#var comp_texture := create_composite_texture()
	canvas_panel.get_parent().remove_child(canvas_panel)
	%ConfirmationContainer.add_child(canvas_panel)
	%ConfirmationContainer.move_child(canvas_panel, 0)

func _on_line_edit_text_changed(new_text: String) -> void:
	%ConfirmButton.disabled = new_text.is_empty()
