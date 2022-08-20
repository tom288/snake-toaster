extends Node

const rope_piece_tscn = preload("res://Parts/RopePiece.tscn")
const piece_length = 16
const rope_close_tolerance = 16

onready var rope_start_piece = $StartPiece
onready var rope_end_piece = $EndPiece

var rope_parts = []

func spawn_rope(start_pos: Vector2, end_pos: Vector2):
	rope_start_piece.global_position = start_pos
	rope_end_piece.global_position = end_pos
	start_pos = rope_start_piece.get_node("CollisionShape2D/PinJoint2D").global_position
	end_pos = rope_end_piece.get_node("CollisionShape2D/PinJoint2D").global_position
	
	var distance = start_pos.distance_to(end_pos)
	var pieces_amount = round(distance / piece_length)
	var spawn_angle = (end_pos - start_pos).angle() - PI / 2 # TODO can this just be (start_pos - end_pos).angle() ?
	if pieces_amount > 0:
		create_rope(pieces_amount, rope_start_piece, end_pos, spawn_angle)

		
func create_rope(pieces_amount, parent: Object, end_pos: Vector2, spawn_angle: float):
	for i in pieces_amount:
		parent = add_piece(parent, i, spawn_angle)
		parent.set_name("rope_piece_%d" % i)
		rope_parts.append(parent)
		
		var joint_pos = parent.get_node("CollisionShape2D/PinJoint2D").global_position
		if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			break
			
	rope_end_piece.get_node("CollisionShape2D/PinJoint2D").node_a = rope_end_piece.get_path()
	rope_end_piece.get_node("CollisionShape2D/PinJoint2D").node_b = rope_parts[-1].get_path()

func add_piece(parent: Object, id: int, spawn_angle: float) -> Object:
	var joint : PinJoint2D = parent.get_node("CollisionShape2D/PinJoint2D") as PinJoint2D
	var piece : Object = rope_piece_tscn.instance() as Object
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return piece
