class_name ScoreScreen
extends Control

@onready var day_1_row: HBoxContainer = %Day1Row
@onready var day_2_row: HBoxContainer = %Day2Row
@onready var day_3_row: HBoxContainer = %Day3Row

func _ready() -> void:
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
	var row: Control
	match Global.day:
		1:
			row = day_1_row
		2:
			row = day_2_row
		3:
			row = day_3_row
	for child: Node in row.get_children():
		var exhibit: Exhibit = child.exhibit
		if not exhibit:
			continue
		var score := exhibit.calculate_score()
		Global.score += score
	%ScoreLabel.text = "Puntuación total: %d" % Global.score
	%ConfirmButton.hide()
	%ContinueButton.show()
	if Global.day == 3:
		%ContinueButton.disabled = true
		%ContinueButton.text = "Final del juego"


func _on_continue_button_pressed() -> void:
	Global.day += 1
	get_tree().change_scene_to_file("res://src/intro_level/intro_level.tscn")
