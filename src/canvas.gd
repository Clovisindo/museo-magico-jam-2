class_name Canvas
extends Node2D

const PIECES_DIR := "res://assets/pieces/"
@onready var canvas_rect: ColorRect = %CanvasRect
var canvas_panel: Control 

func _ready() -> void:
	%ConfirmButton.disabled = true
	%Confirmation.hide()
	%Main.show()
	# Cargar imágenes:
	var files = []
	for file: String in DirAccess.get_files_at(PIECES_DIR):
		if  not file.ends_with(".png"):
			continue
		files.push_back(file)
	files.shuffle()
	for file in files:
		var filepath := PIECES_DIR.path_join(file)
		var scene := preload("res://src/movable_texture_rect/catalog_texture.tscn")
		var new_catalog_texture: CatalogTexture = scene.instantiate()
		var texture = load(filepath)
		new_catalog_texture.target_parent = canvas_rect
		new_catalog_texture.set_texture(texture)
		new_catalog_texture.z_index = 100
		%PieceContainer.add_child(new_catalog_texture)

func create_exhibit() -> Exhibit:
	var pieces: Array[TextureRect] = []
	for child: Node in canvas_rect.get_children():
		if child is MovableTextureRect:
			var copy := TextureRect.new()
			copy.texture = child.texture
			copy.position = child.position
			pieces.push_back(copy)
	var new_exhibit := Exhibit.new(pieces, %LineEdit.text, Global.n_creations)
	return new_exhibit

func _on_submit_button_pressed() -> void:
	%Main.hide()
	%Confirmation.show()
	if not canvas_panel:
		canvas_panel = %CanvasPanel
	#var comp_texture := create_composite_texture()
	canvas_panel.get_parent().remove_child(canvas_panel)
	%ConfirmationContainer.add_child(canvas_panel)
	%ConfirmationContainer.move_child(canvas_panel, 0)
	%LineEdit.grab_focus()
	%AudioStreamPlayer.play()

func _on_line_edit_text_changed(new_text: String) -> void:
	%ConfirmButton.disabled = new_text.is_empty()

func _on_confirm_button_pressed() -> void:
	var new_exhibit := create_exhibit()
	DirAccess.make_dir_absolute("user://exhibits")
	ResourceSaver.save(new_exhibit, "user://exhibits/" + new_exhibit.name + ".tres")
	Global.n_creations += 1
	#%Main.show()
	#%Confirmation.hide()
	##var comp_texture := create_composite_texture()
	#canvas_panel.get_parent().remove_child(canvas_panel)
	#%HBoxContainer.add_child(canvas_panel)
	#%HBoxContainer.move_child(canvas_panel, 1)
	%AudioStreamPlayer.play()
	if Global.n_creations < 3 * Global.day:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://src/scores/score_screen.tscn")


func _on_canvas_rect_child_entered_tree(_node: Node) -> void:
	%SubmitButton.disabled = canvas_rect.get_child_count() == 0


func _on_canvas_rect_child_exiting_tree(_node: Node) -> void:
	%SubmitButton.disabled = canvas_rect.get_child_count() <= 1


func _on_drag_button_pressed() -> void:
	Global._activate_drag()
	%AudioStreamPlayer.play()


func _on_rotate_button_pressed() -> void:
	Global._activate_rotate()
	%AudioStreamPlayer.play()


func _on_scale_button_pressed() -> void:
	Global._activate_scale()
	%AudioStreamPlayer.play()

func _on_flip_button_horizontal_pressed() -> void:
	Global._activate_flip_h()
	%AudioStreamPlayer.play()


func _on_flip_button_vertical_pressed() -> void:
	Global._activate_flip_v()
	%AudioStreamPlayer.play()
