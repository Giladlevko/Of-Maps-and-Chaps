extends UI
@export var start_button:Button
@export var quit_button:Button
@export var credits_button:Button
@onready var color_rect_container: MarginContainer = $color_rect_container
@onready var credits_container: MarginContainer = $credits_container
@export var back_to_main_button:Button
@onready var music: AudioStreamPlayer = $music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_buttuns = [start_button,quit_button,credits_button,back_to_main_button]
	dark_screen(0)
	handle_music()

func handle_music(value:int = -5):
	get_tree().create_tween().tween_property(music,"volume_db",value,2)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for button in menu_buttuns:
		if button:
			if button.is_hovered():
				tween_scale(button,1.2,0.3,self)
			else:
				tween_scale(button,1,0.3,self)


func _on_button_mouse_entered() -> void:
	hover_sfx.play()


func _on_button_mouse_exited() -> void:
	pass # Replace with function body.


func _on_start_button_pressed() -> void:
	press_sfx.play()
	dark_screen()
	handle_music(-50)
	await screen_finished
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_button_pressed() -> void:
	press_sfx.play()
	dark_screen()
	handle_music(-50)
	await screen_finished
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	press_sfx.play()
	dark_screen()
	await screen_finished
	credits_container.visible = !credits_container.visible
	dark_screen(0)
