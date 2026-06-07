extends Node2D

var day_1_text := """
Acabas de abrir un [color=yellow]museo de criaturas fantásticas[/color]. La gente es tan ingenua que vendrá a visitarte, intrigada por las antiguas [color=yellow]leyendas del bosque[/color] cercano.

En realidad compraste una tienda de réplicas de animales y simplemente los [color=yellow]cortarás y mezclarás para montar tus propios mitos[/color]. [wave amp=12][i]\"Mentalidad de tiburón\"[/i][/wave], te dices a ti misme.

Pronto abrirá el museo y debes dejar todo preparado para la inauguración.

¿Qué nombre le pondrás a tu museo?
"""
var day_2_text := """
El primer día ha sido un éxito, \"nos vamos a hacer de oro\", piensas.

A la gente parecen atraerle especialmente las [color=yellow]criaturas peligrosas[/color], quizá sea buena idea ir en esa dirección...
"""
var day_3_text := """
¡Este es el día decisivo para asentarte como el museo referente de la región!

Sabes que hoy vendrán visitas escolares, así que puede ser buena idea tirar por [color=yellow]criaturas que podrían ser mascotas[/color].
"""

func _ready() -> void:
	%Continue.hide()
	%LineEdit.hide()
	%InitTestLabel.text = get("day_%d_text" % Global.day)
	var tween := get_tree().create_tween().tween_property(%InitTestLabel, "visible_ratio", 1, 4).from(0)
	await tween.finished
	if Global.day == 1:
		%LineEdit.show()
		%LineEdit.grab_focus()
		%Continue.disabled = true
	%Continue.show()


func _on_confirm_pressed() -> void:
	Global.museum_name = %LineEdit.text
	get_tree().change_scene_to_file("res://src/canvas.tscn")


func _on_line_edit_text_changed(new_text: String) -> void:
	%Continue.disabled = new_text.is_empty()
