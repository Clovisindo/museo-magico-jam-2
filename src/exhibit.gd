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
	var score := 0
	var used_animals := {}
	var used_terrains := {}
	for texture: Texture2D in textures:
		var file_name = texture.resource_path.get_file()
		file_name = file_name.split(".")[0]
		var name_parts = file_name.split("_")
		var animal_name = name_parts[0]
		used_animals[animal_name] = true
		for name_part in name_parts:
			if name_part in Global.tags_by_name_part:
				for tag in Global.tags_by_name_part[name_part]:
					if tag == Global.get_current_theme():
						score += 100
					if tag in [Global.Tag.OCEANO, Global.Tag.TIERRA, Global.Tag.AIRE]:
						used_terrains[tag] = true
	score += used_animals.size() * 100
	score += used_terrains.size() * 100
	score += mini(15, name.length())
	if name.contains("a") and name.contains("e") and name.contains("i") and name.contains("o") and name.contains("u"):
		score += 50
	var used_letters := {}
	for letter in name:
		used_letters[letter] = true
	score += used_letters.size() * 10
	return score
