extends Button

@onready var Configuration = $"/root/Configuration" 
@onready var ErrorUtil = $"/root/ErrorUtil"
@onready var Auth = $"/root/Auth"

@onready var server_canvas = $"../../ServerCanvas"
@onready var login_canvas = $".."

func _pressed():
	_start_server()
	
func _start_server():
	print("[Server] Starting server...")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Configuration.SERVER_PORT, Configuration.MAX_PLAYERS)
	
	if error:
		await ErrorUtil.print_err_and_exit("[Server] Failed to start game server. Exiting...", error, get_tree())		
		return
	
	server_canvas.visible = true
	login_canvas.visible = false
	
	print("[Server] Started game server on %s:%d" % [Configuration.SERVER_ADDRESS, Configuration.SERVER_PORT])
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(Auth.on_peer_connected)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/world_scene.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("start_server"):
		_start_server()
	
