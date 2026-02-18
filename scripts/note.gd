extends Sprite2D
@export var dialog_name:String
var in_area:bool
var playing_timline:bool
var player:CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_started.connect(on_timline_started)
	Dialogic.timeline_ended.connect(on_timline_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area and Input.is_action_just_pressed("interact") and !playing_timline:
		Dialogic.start(dialog_name)
		player.popup.hide()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false

func on_timline_started():
	playing_timline = true

func on_timline_ended():
	playing_timline = false
