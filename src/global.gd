extends Node

var museum_name: String = "Museo"
var day: int = 1
var score: int = 0
var n_creations: int = 0
var saved_exhibits: Array[Exhibit] = []
var rotate_mode : bool = false
var scale_mode : bool = false
var flip_mode_h : bool = false
var flip_mode_v : bool = false
var drag_mode : bool = true
var used_names = []
var language := "gl"

enum Tag {
	BOSQUE,
	OCEANO,
	PELIGROSA,
	MASCOTA,
	TIERRA,
	AIRE,
}

var tags_by_name_part := {
	"capybara": [Tag.MASCOTA, Tag.TIERRA],
	"caracol": [Tag.MASCOTA, Tag.BOSQUE, Tag.TIERRA],
	"escorpion": [Tag.PELIGROSA, Tag.TIERRA],
	"gato": [Tag.BOSQUE, Tag.MASCOTA, Tag.PELIGROSA, Tag.TIERRA],
	"pato": [Tag.OCEANO, Tag.MASCOTA, Tag.AIRE],
	"pulpo": [Tag.OCEANO, Tag.PELIGROSA],
	"tiburon": [Tag.OCEANO, Tag.PELIGROSA],
	"tortuga": [Tag.OCEANO, Tag.MASCOTA, Tag.TIERRA],
	"ciervo": [Tag.BOSQUE, Tag.TIERRA, Tag.PELIGROSA],
	"vaca": [Tag.TIERRA, Tag.PELIGROSA],
	"paloma": [Tag.MASCOTA, Tag.AIRE],
	"lagarto": [Tag.TIERRA, Tag.BOSQUE, Tag.PELIGROSA],
	"gallo": [Tag.AIRE, Tag.BOSQUE, Tag.MASCOTA],
	"ave": [Tag.AIRE],
	"murcielago": [Tag.PELIGROSA, Tag.AIRE],
	"humano": [Tag.BOSQUE, Tag.PELIGROSA],
}
var traduciones := {
	'pulpo': 'polbo',
	'tortuga': 'tartaruga',
	'ciervo': 'cervo',
	'paloma': 'pomba',
	'gallo': 'galo',
	'murcielago': 'morcego',
}

var theme_by_day := {
	1: Tag.BOSQUE,
	2: Tag.PELIGROSA,
	3: Tag.MASCOTA,
}

func get_current_theme() -> Tag:
	return theme_by_day[Global.day]

func _ready() -> void:
	if !DirAccess.dir_exists_absolute("user://exhibits"):
		DirAccess.make_dir_absolute("user://exhibits")
	for file in DirAccess.get_files_at("user://exhibits"):
		DirAccess.remove_absolute("user://exhibits".path_join(file))

func _activate_rotate():
	rotate_mode = true
	scale_mode = false
	flip_mode_h = false
	flip_mode_v = false
	drag_mode = false

func _activate_scale():
	rotate_mode = false
	scale_mode = true
	flip_mode_h = false
	flip_mode_v = false
	drag_mode = false

func _activate_flip_h():
	rotate_mode = false
	scale_mode = false
	flip_mode_h = true
	flip_mode_v = false
	drag_mode = false

func _activate_flip_v():
	rotate_mode = false
	scale_mode = false
	flip_mode_h = false
	flip_mode_v = true
	drag_mode = false

func _activate_drag():
	rotate_mode = false
	scale_mode = false
	flip_mode_h = false
	flip_mode_v = false
	drag_mode = true

var reactions_low := [
	'low1', 'low2', 'low3', 'low4'
]

var reactions_mid := [
	'mid1', 'mid2', 'mid3'
]

var reactions_high := [
	'high1', 'high2', 'high3'
]

var reactions_bad_name := [
	'badname1', 'badname2'
]

var reactions_good_name := [
	'goodname1', 'goodname2'
]

var bad_theme_already_used := false
var reactions_bad_theme := [
	'badtheme1', 'badtheme2', 'badtheme3'
]

var good_theme_already_used := false
var reactions_good_theme := [
	'goodtheme1', 'goodtheme2', 'goodtheme3'
]

var reactions_similarity := [
	'similar'
]
