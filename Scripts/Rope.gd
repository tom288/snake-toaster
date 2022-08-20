extends CanvasItem

const rope_piece_tscn = preload("res://Parts/RopePiece.tscn")
const piece_length = 16
const rope_close_tolerance = 16

onready var rope_start_piece = $StartPiece
onready var rope_end_piece = $EndPiece
onready var rope_start_joint = $StartPiece/CollisionShape2D/PinJoint2D
onready var rope_end_joint = $EndPiece/CollisionShape2D/PinJoint2D

var rope_parts = []
var rope_points: PoolVector2Array = []

func _process(_delta):
	get_rope_points()
	if !rope_points.empty():
		update()
	

func spawn_rope(start_pos: Vector2, end_pos: Vector2):
	rope_start_piece.global_position = start_pos
	rope_end_piece.global_position = end_pos
	start_pos = rope_start_joint.global_position
	end_pos = rope_end_joint.global_position
	
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
			
	rope_end_joint.node_a = rope_end_piece.get_path()
	rope_end_joint.node_b = rope_parts[-1].get_path()

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
	
func get_rope_points():
	rope_points = []
	rope_points.append(rope_start_joint.global_position)
	for r in rope_parts:
		rope_points.append(r.global_position)
	rope_points.append(rope_end_joint.global_position)
	
func _draw():
	draw_polyline(rope_points, Color.black)
