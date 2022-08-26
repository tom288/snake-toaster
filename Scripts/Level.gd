extends Node2D

var rope_tscn = preload("res://Parts/Rope.tscn")
var pos_head = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and !event.is_pressed():
		var pos_mouse = get_global_mouse_position()
		if pos_head == Vector2.ZERO:
			pos_head = pos_mouse
		else:
			var rope = rope_tscn.instance()
			add_child(rope)
			rope.spawn_rope(pos_head, pos_mouse)
			pos_head = Vector2.ZERO
