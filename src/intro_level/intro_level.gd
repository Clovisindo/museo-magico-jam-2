extends Node2D

var day_1_text := "Empieza el dia 1.
Tienes que crear criaturas con las partes.


etc >.>"
var day_2_text := "Empieza el dia 2.
Tienes que crear criaturas con las partes.


etc >.>"
var day_3_text := "Empieza el dia 3.
Tienes que crear criaturas con las partes.


etc >.>"

func _ready() -> void:
	%InitTestLabel.text = get("day_%d_text" % Global.day)


func _on_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://src/canvas.tscn")
