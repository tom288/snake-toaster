extends Node2D

var rope_tscn = preload("res://Parts/Rope.tscn")
var pos_start = Vector2.ZERO
var pos_end = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and !event.is_pressed():
		var pos_mouse = get_global_mouse_position()
		if pos_start == Vector2.ZERO:
			pos_start = pos_mouse
		elif pos_end == Vector2.ZERO:
			pos_end = pos_mouse
			var rope = rope_tscn.instance()
			add_child(rope)
			rope.spawn_rope(pos_start, pos_end)
			pos_start = Vector2.ZERO
			pos_end = Vector2.ZERO
