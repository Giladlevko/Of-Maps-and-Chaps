extends CharacterBody2D
class_name Player
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var gravity:int = 900
var speed_x:int = 100
var speed_y:int = -200
var gravity_wall:int = 20
var wall_push_force: int = 200
var wall_contact_coyote:float = 0.0
var wall_jump_lock: float = 0.0
var wall_jump_lock_time:float = 0.05
var wall_contact_coyote_time:float = 0.1
var last_pos:Vector2
var dead:bool
var can_move:bool = true
const Y_THRESHOLD:int = 1000
@onready var cam: Camera2D = $Camera2D
@onready var dash_bar: ProgressBar = $CanvasLayer/MarginContainer/ProgressBar
var dash_cooldown:float = 2.0
@onready var run: AudioStreamPlayer2D = $sounds/run
@onready var jump: AudioStreamPlayer2D = $sounds/jump
@onready var dash: AudioStreamPlayer2D = $sounds/dash
@onready var popup: TextureRect = $CanvasLayer/MarginContainer/MarginContainer/Popup
@onready var states: StateMachine = $states




var can_dash:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dash_bar.max_value = dash_cooldown
	dash_bar.value = 0
	dash_bar.modulate = Color(1,1,1,0)
	popup.hide_()
	Dialogic.timeline_started.connect(on_dialog)
	Dialogic.timeline_ended.connect(on_dialog)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !dead:
		if position.y >= Y_THRESHOLD:
			on_dead()

func on_dialog():
	if Dialogic.current_timeline:
		cam.position_smoothing_speed = 1
		cam.position.y += 20
	else:  
		cam.position.y -= 20
		cam.position_smoothing_speed = 5
	pass

func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		popup.popup()


func _on_interact_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		popup.hide_()


func _on_interact_zone_area_entered(area: Area2D) -> void:
	if !dead:
		if area.get_parent().is_in_group("interactable"):
			popup.popup()
		if area.is_in_group("check_points"):
			last_pos = area.position
			if !Global.reached_check_points.has(area.name):
				SignalBus.message_popup.emit("Check-Point Reached!")
				Global.reached_check_points.append(area.name)
		if area.is_in_group("kills"):
			on_dead()
		if area.get_parent().is_in_group("wizard"):
			can_move = false

func _on_interact_zone_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("interactable"):
		popup.hide_()

func on_dead():
	states._transition_to_next_state("dead")
	dead = true
	



func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "dash":
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(dash_bar,"modulate",Color(1,1,1,0.25),0.2)
		tween.tween_property(dash_bar,"value",dash_cooldown,dash_cooldown-0.1)
		tween.chain().tween_property(dash_bar,"modulate",Color(1,1,1,0),0.1)
		await tween.finished
		dash_bar.value = 0
		can_dash = true
		


func _on_animated_sprite_2d_frame_changed() -> void:
	if anim.animation == "run":
		if anim.frame in [2]:
			run.play()



func _on_animated_sprite_2d_animation_changed() -> void:
	if anim.animation == "jump":
		jump.play()
	if anim.animation == "dash":
		dash.play()
