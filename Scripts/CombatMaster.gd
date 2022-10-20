extends Node

var bingagingading

signal done

export var enemy_count : int

var player_turn : bool
onready var interface = $Camera/HUD

func _ready():
	$Camera/AnimationPlayer.play("Wiggle")

func _process(delta):
	if player_turn:
		print('cum')
	else:
		print("cock")

