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
	"cuerno": [Tag.PELIGROSA],
	"ciervo": [Tag.BOSQUE, Tag.TIERRA],
	"vaca": [Tag.TIERRA],
	"paloma": [Tag.MASCOTA, Tag.AIRE],
	"lagarto": [Tag.TIERRA, Tag.BOSQUE, Tag.PELIGROSA],
	"gallo": [Tag.AIRE, Tag.BOSQUE, Tag.MASCOTA],
	"ala": [Tag.AIRE],
	"murcielago": [Tag.PELIGROSA],
	"humano": [Tag.BOSQUE, Tag.PELIGROSA],
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
	'¡Vaya timo! A este [color=yellow]%s[/color] se le ve el pegamento entre las extremidades...',
	'Este [color=yellow]%s[/color] no se parece en nada a como aparece en los libros.',
	'No sé, este [color=yellow]%s[/color] parece falso...',
	'Le ha arruinado la navidad a mis hijos. Nunca te lo perdonaré, [color=yellow]%s[/color].'
]

var reactions_mid := [
	'¡Qué interesante! No conocía al [color=yellow]%s[/color].',
	'Este [color=yellow]%s[/color] me recuerda a los cuentos que me contaba mi madre.',
	'Qué curioso, ojalá existiese [color=yellow]%s[/color] en la vida real'
]

var reactions_high := [
	'Wow! Juraría que una vez vi un [color=yellow]%s[/color] como este en el bosque.',
	'Supera a como me lo imaginaba! Qué bien poder ber un [color=yellow]%s[/color] real.',
	'Me puedo llevar al [color=yellow]%s[/color]? A mis hijas les encantaría.'
]

var reactions_bad_name := [
	'[color=yellow]%s[/color]? Vaya nombre más tonto...',
	'[color=yellow]%s[/color] parece un nombre inventado.',
]

var reactions_good_name := [
	'[color=yellow]%s[/color], qué bien suena ese nombre!',
	'Qué poético el nombre [color=yellow]%s[/color]. A quién se le ocurriría?',
]

var bad_theme_already_used := false
var reactions_bad_theme := [
	'En serio [color=yellow]%s[/color] vive en el bosque? No parece adaptado a este terreno.',
	'Se supone que este [color=yellow]%s[/color] es peligroso? No lo parece para nada...',
	'Qué feo es este [color=yellow]%s[/color]! No soporto verlo.'
]

var good_theme_already_used := false
var reactions_good_theme := [
	'Interesante. Este [color=yellow]%s[/color] parece perfectamente adaptado para la supervivencia en el bosque.',
	'No me gustaría enfrentarme a un [color=yellow]%s[/color], espero que ya se extinguieran.',
	'Qué mono es este [color=yellow]%s[/color]! Puedo llevármelo a casa?!',
]
