class_name Exhibit
extends Resource

@export var name: String
@export var textures: Array[Texture2D]
@export var positions: Array[Vector2]
@export var sizes: Array[Vector2]
@export var id: int

func _init(texture_rects: Array[TextureRect] = [], name_: String = "", id_: int = 0) -> void:
	for texture: TextureRect in texture_rects:
		textures.push_back(texture.texture)
		positions.push_back(texture.position)
		sizes.push_back(texture.size)
		name = name_
	id = id_

func calculate_score() -> int:
	return 100
