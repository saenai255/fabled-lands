extends Node2D

func print_err_and_exit(message: String, error: Error):
	printerr(message)
	printerr("Error: ", error_string(error))
	await get_tree().create_timer(1.0).timeout
	get_tree().quit(error)
