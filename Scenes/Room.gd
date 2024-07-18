extends Node2D

@export var starting_room:bool = false

@export var width_in_tiles:int = 0
@export var height_in_tiles:int = 0
@export var starting_location:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.size.x = 64*width_in_tiles
	$ColorRect.size.y = 64*height_in_tiles
	if starting_room == false:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enter_room():
	$AnimationPlayer.play("fade_out")
