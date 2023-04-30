extends Button

@onready var Configuration = $"/root/Configuration" 
@onready var ErrorUtil = $"/root/ErrorUtil"

@onready var auth = $"/root/Auth"
@onready var username_text_edit = $"../UsernameTextEdit"
@onready var password_text_edit = $"../PasswordTextEdit"

func _pressed():
	_attempt_login()
	
func _attempt_login():
	var username = username_text_edit.text
	var password = password_text_edit.text
	
	username_text_edit.text = ""
	password_text_edit.text = ""
	
	print("[Client] Attempting login with [Username: '%s', Password: '%s'] on server [Address: '%s', Port: '%d']" % [
		username,
		password,
		Configuration.SERVER_ADDRESS,
		Configuration.SERVER_PORT
	])
	
	auth.username = username
	auth.password = password
	
	var peer = ENetMultiplayerPeer.new()
	var connection_err = peer.create_client(Configuration.SERVER_ADDRESS, Configuration.SERVER_PORT)
	if connection_err:
		return
	
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(auth.on_connected_to_server)
	multiplayer.connection_failed.connect(auth.on_connection_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_text_submit"):
		_attempt_login()
	
	if Input.is_action_just_pressed("ui_focus_next"):
		if username_text_edit.has_focus():
			username_text_edit.text = username_text_edit.text.strip_edges(true, true)
			get_node(username_text_edit.focus_next).grab_focus()
		elif password_text_edit.has_focus():
			password_text_edit.text = password_text_edit.text.strip_edges(true, true)			
			get_node(password_text_edit.focus_next).grab_focus()
