extends Node2D


func _enter_tree():
	var speaker = "Server" if multiplayer.is_server() else ("Connection %s" % multiplayer.get_unique_id())
	print("[%s] Setting authority %d to Player %s" % [speaker, multiplayer.get_unique_id(), name])
	set_multiplayer_authority(str(name).to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
	#$ColorRect.color = Color(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255), 255)
	$Camera2D.enabled = str(name).to_int() == get_multiplayer_authority()	
	$Camera2D/IdLabel.text = "Server" if multiplayer.is_server() else str(multiplayer.get_unique_id())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var new_pos = position + input_direction * 4.0
	
	if not new_pos.is_equal_approx(position):
		rpc_server_move_player.rpc(new_pos.x, new_pos.y)
	#position = new_pos
	
	
@rpc("authority", "call_local", "unreliable_ordered")
func rpc_server_move_player(x: float, y: float):
	position = Vector2(x, y)
