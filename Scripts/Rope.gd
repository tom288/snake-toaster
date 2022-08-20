extends Node

var piece_length = 10

var rope_parts = []

func spawn_rope(start_pos:Vector2, end_pos:Vector2):
	var distance = start_pos.distance_to(end_pos)
	var segment_amount = round(distance / piece_length)
	
	for i in segment_amount:
		print(i)
