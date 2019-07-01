extends Node2D

var speed: float = 125

func _process(delta):
	if Input.is_key_pressed(KEY_RIGHT):
		position.x += speed * delta
	if Input.is_key_pressed(KEY_LEFT):
		position.x -= speed * delta
	if Input.is_key_pressed(KEY_UP):
		position.y -= speed * delta
	if Input.is_key_pressed(KEY_DOWN):
		position.y += speed * delta