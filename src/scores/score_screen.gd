class_name ScoreScreen
extends Control

@onready var day_1_row: HBoxContainer = %Day1Row
@onready var day_2_row: HBoxContainer = %Day2Row
@onready var day_3_row: HBoxContainer = %Day3Row

func _ready() -> void:
	Global.bad_theme_already_used = false
	Global.good_theme_already_used = false
	var scene: PackedScene = preload("res://src/scores/exhibit_view.tscn")
	%Title.text = "%s: Día %d" % [Global.museum_name, Global.day]
	%ScoreLabel.text = "Puntuación total: %d" % Global.score
	%ContinueButton.hide()
	var i = 0
	for child: Node in day_1_row.get_children():
		child.requested_change.connect(func():
			request_change(child)
		)
		if Global.saved_exhibits.size() > i:
			var view: ExhibitView = scene.instantiate()
			view.init(Global.saved_exhibits[i])
			child.set_exhibit(view)
		i+=1
	for child: Node in day_2_row.get_children():
		child.requested_change.connect(func():
			request_change(child)
		)
		if Global.day < 2:
			child.disable()
		if Global.saved_exhibits.size() > i:
			var view: ExhibitView = scene.instantiate()
			view.init(Global.saved_exhibits[i])
			child.set_exhibit(view)
		i+=1
	for child: Node in day_3_row.get_children():
		child.requested_change.connect(func():
			request_change(child)
		)
		if Global.day < 3:
			child.disable()
		if Global.saved_exhibits.size() > i:
			var view: ExhibitView = scene.instantiate()
			view.init(Global.saved_exhibits[i])
			child.set_exhibit(view)
		i+=1

func request_change(slot: Slot) -> void:
	%AudioStreamPlayer.play()
	var scene: PackedScene = preload("res://src/scores/exhibit_selection.tscn")
	var exhibit_selection: ExhibitSelection = scene.instantiate()
	get_tree().root.add_child(exhibit_selection)
	%Main.hide()
	exhibit_selection.selected_exhibit.connect(func(exhibit: ExhibitView):
		slot.set_exhibit(exhibit)
		Global.saved_exhibits.push_back(exhibit.exhibit)
		%Main.show()
		exhibit_selection.queue_free()
	)


func _on_button_pressed() -> void:
	%AudioStreamPlayer.play()
	var row: Control
	match Global.day:
		1:
			row = day_1_row
		2:
			row = day_2_row
		3:
			row = day_3_row
	var i := 1
	for child: Node in row.get_children():
		child.disable()
		var exhibit: Exhibit = child.exhibit
		if not exhibit:
			continue
		var score_result := exhibit.calculate_score()
		var score = score_result[0]
		child.set_score(score)
		Global.score += score
		var comment = score_result[1]
		var container = get_node("ReactionContainer%d" % i)
		container.show()
		container.get_node("MarginContainer").get_node("Reaction").text = comment
		await get_tree().create_timer(1).timeout
		i += 1
	if Global.day == 3:
		%ScoreLabel.text = "[color=green][wave]Puntuación final: %d[/wave][/color]" % Global.score
	else:
		%ScoreLabel.text = "[color=green][wave]Puntuación total: %d[/wave][/color]" % Global.score
	%ConfirmButton.hide()
	%ScoreLabel.show()
	if Global.day == 3:
		%ContinueButton.disabled = true
		%Credits.show()
	else:
		%ContinueButton.show()


func _on_continue_button_pressed() -> void:
	%AudioStreamPlayer.play()
	Global.day += 1
	get_tree().change_scene_to_file("res://src/intro_level/intro_level.tscn")
