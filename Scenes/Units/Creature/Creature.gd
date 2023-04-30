extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if multiplayer.is_server():
		_ready_server()
	else:
		_ready_client()
	
func _ready_server():
	pass
	
func _ready_client():
	$AnimationPlayer.play("Creature_RotDevourer_Idle_Anim")

