extends Node2D

const Player = preload("res://Scenes/Units/Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if not multiplayer.is_server():
		server_rpc_spawn_player.rpc()
	

@rpc("any_peer", "call_remote", "reliable")
func server_rpc_spawn_player():
	var player = Player.instantiate()
	player.name = "%s" % multiplayer.get_remote_sender_id()
	
	print("[Server] Spawning player for connection %s" % player.name)
	
	#player.set_multiplayer_authority(multiplayer.get_remote_sender_id())
	$Spawner.add_child(player, true)
