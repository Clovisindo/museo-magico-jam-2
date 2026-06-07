class_name Exhibit
extends Resource

@export var name: String
@export var textures: Array[Texture2D]
@export var positions: Array[Vector2]
@export var sizes: Array[Vector2]
@export var rotations: Array[float]
@export var id: int

func _init(texture_rects: Array[TextureRect] = [], name_: String = "", id_: int = 0) -> void:
	for texture: TextureRect in texture_rects:
		textures.push_back(texture.texture)
		positions.push_back(texture.position)
		sizes.push_back(texture.size)
		rotations.push_back(texture.rotation)
		name = name_
	id = id_

func calculate_score() -> Array:
	var comment := ""
	var score := 0
	var used_animals := {}
	var used_terrains := {}
	var bad_name := false
	var good_name := false
	var bad_theme := randf() < 0.5
	var good_theme := false
	var similar_to = ""
	for texture: Texture2D in textures:
		var file_name = texture.resource_path.get_file()
		file_name = file_name.split(".")[0]
		var name_parts = file_name.split("_")
		var animal_name = name_parts[0]
		if not animal_name in used_animals:
			used_animals[animal_name] = 1
		else:
			used_animals[animal_name] += 1
			if used_animals[animal_name] > 2:
				similar_to = animal_name
		for name_part in name_parts:
			if name_part in Global.tags_by_name_part:
				for tag in Global.tags_by_name_part[name_part]:
					if tag == Global.get_current_theme():
						score += 100
						if randf() < 0.3:
							bad_theme = false
							good_theme = true
					if tag in [Global.Tag.OCEANO, Global.Tag.TIERRA, Global.Tag.AIRE]:
						used_terrains[tag] = true
	score += used_animals.size() * 100
	score += used_terrains.size() * 100
	score += mini(15, name.length())
	if name.contains("a") and name.contains("e") and name.contains("i") and name.contains("o") and name.contains("u"):
		score += 50
		good_name = true
	var used_letters := {}
	for letter in name:
		used_letters[letter] = true
	score += used_letters.size() * 10
	if (used_letters.size() > 10 or name.length() > 12) and randf() < 0.5:
		good_name = true
	elif (used_letters.size() < 4 or name.length() < 5) and randf() < 0.5:
		bad_name = true
	
	if similar_to and randf() < 0.7:
		if Global.language == "gl" and similar_to in Global.traduciones:
			similar_to = Global.traduciones[similar_to]
		comment = TranslationServer.translate(Global.reactions_similarity[0]) % [name, similar_to]
	elif bad_name and randf() < 0.7:
		comment = TranslationServer.translate(Global.reactions_bad_name.pick_random())
	elif good_name and randf() < 0.7:
		comment = TranslationServer.translate(Global.reactions_good_name.pick_random())
	elif bad_theme and not Global.bad_theme_already_used and randf() < 0.5:
		comment = TranslationServer.translate(Global.reactions_bad_theme[Global.day - 1])
		Global.bad_theme_already_used = true
	elif good_theme and not Global.good_theme_already_used and randf() < 0.5:
		comment = TranslationServer.translate(Global.reactions_good_theme[Global.day - 1])
		Global.good_theme_already_used = true
	elif score < 350:
		comment = TranslationServer.translate(Global.reactions_low.pick_random())
	elif score > 600:
		comment = TranslationServer.translate(Global.reactions_high.pick_random())
	else:
		comment = TranslationServer.translate(Global.reactions_mid.pick_random())
	if comment.contains("%s"):
		comment = comment % name
	return [score, comment]
