extends Node

var rope_piece_tscn = preload("res://Parts/RopePiece.tscn")
var piece_length = 10
var rope_parts = []

onready var rope_start_piece = $StartPiece
onready var rope_end_piece = $EndPiece

func spawn_rope(start_pos: Vector2, end_pos: Vector2):
	var distance = start_pos.distance_to(end_pos)
	var segment_amount = round(distance / piece_length)
	
	rope_start_piece.global_position = start_pos
	rope_end_piece.global_position = end_pos
	
	for i in segment_amount:
		print(i)

func add_piece(parent: Object, id: int, spawn_angle: float) -> Object:
	var joint : PinJoint2D = parent.get_node("CollisionShape2D/PinJoint2d")
	var piece : Object = rope_piece_tscn.instance() as Object
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path
	joint.node_b = parent.get_path
	return piece
