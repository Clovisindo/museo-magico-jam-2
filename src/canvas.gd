class_name Canvas
extends Node2D

const PIECES_DIR := "res://assets/pieces/"

func _ready() -> void:
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
