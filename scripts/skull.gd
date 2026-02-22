extends AnimatedSprite2D

var front:int = 0
var right:int = 1
var left: int = 2
var in_area:bool
@export_range(0,2,1) var current_dir:int = 0 
@export_range(0,2,1) var desired_dir: int = 0
var is_desired_dir:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = current_dir


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			if current_dir == 2:
				current_dir = 0
			else:
				current_dir += 1
			
			is_desired_dir = (current_dir == desired_dir)
			print("is_desired_dir: ",is_desired_dir)
			if Global.skulls_can_give:
				if is_desired_dir:
					Global.correct_skulls.append(name)
					print("added name")
				elif Global.correct_skulls.has(name):
					Global.correct_skulls.erase(name)
					print("erased_name")
				if Global.correct_skulls.size() == 3:
					Global.ink_amount = clamp(Global.ink_amount+5,0,Global.max_ink)
					SignalBus.update_ink.emit()
					Global.skulls_can_give = false
	frame = current_dir


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		in_area = false
