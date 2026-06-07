extends Node2D

var day_1_text := "day1"
var day_2_text := "day2"
var day_3_text := "day3"

func _ready() -> void:
	%OptionButton.select(1 if Global.language == "es" else 0)
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
	if Global.day == 1:
		Global.museum_name = %LineEdit.text
	%AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://src/canvas.tscn")

func _on_line_edit_text_changed(new_text: String) -> void:
	%Continue.disabled = new_text.is_empty()


func _on_option_button_item_selected(index: int) -> void:
	Global.language = "es" if index == 1 else "gl"
	TranslationServer.set_locale(Global.language)
	get_tree().reload_current_scene()
