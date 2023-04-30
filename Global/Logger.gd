extends Node2D

func info(message: String):
	var net_id = multiplayer.get_unique_id()
	var speaker = multiplayer.is_server() if "Server" else ("Client %s" % net_id)
	print("[INFO] [%s]: " % [speaker, message])
