extends Node2D

@onready var ErrorUtil = $"/root/ErrorUtil" 

var username = ""
var password = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	print("main loaded")

func start_server():
	print("pressed start server")

func on_connected_to_server():
	print("[Client] Connected as peer %d" % multiplayer.get_unique_id())
	
	rpc_server_login.rpc(username, password)
	

func on_connection_failed():
	await ErrorUtil.print_err_and_exit("Server connection failed.", ERR_CANT_CONNECT, get_tree())	
	

@rpc("authority", "call_remote", "reliable")
func rpc_client_login_result(success: bool):
	print("[Client] Login %s" % ("successful" if success else "failure"))
	if not success:
		return
	
	var err = get_tree().change_scene_to_file("res://Scenes/world_scene.tscn")
	if err:
		await ErrorUtil.print_err_and_exit("Failed to load World scene.", err, get_tree())
		return
	print("[Client] Loaded World scene.")
	
@rpc("any_peer", "call_remote", "reliable")
func rpc_server_login(username: String, password: String):
	var sender_id =  multiplayer.get_remote_sender_id()
	print("[Server] Peer %s is attempting authentication." % sender_id)
	
	var is_valid_account = server_can_authenticate(username, password)
	rpc_client_login_result.rpc_id(sender_id, is_valid_account)
	
	print("[Server] Peer %s connected as %s" % [sender_id, username])

func server_can_authenticate(username: String, password: String) -> bool:
	var users: Array[Crendetials] = [
		Crendetials.new("admin", "admin"),
		Crendetials.new("user", "user")
	]
	
	for account in users:
		if account.username == username and account.password == password:
			return true
	return false

func on_peer_connected(peer_id: int):
	print("[Server] New connection from peer %d" % peer_id)

class Crendetials:
	var username: String
	var password: String
	
	func _init(username: String, password: String):
		self.username = username
		self.password = password
