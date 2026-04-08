extends Control
class_name UI

@export var ink_label:Label
@export var ink_anim: AnimationPlayer
@export var map: NinePatchRect
var prev_ink:int
@export var map_container: MarginContainer
@export var message_label: Label
@export var death_rect: ColorRect
@export var death_label: Label
var menu_buttuns:Array = []
@export var map_button:Button
@export var back_to_game_button:Button
@export var death_screen:MarginContainer
@export var close_menu_button: Button
@export var main_menu_button: Button
@export var menu_button: Button
@export var menu_anim: AnimationPlayer
@export var in_game_menu:MarginContainer
@export var press_sfx:AudioStreamPlayer
@export var hover_sfx:AudioStreamPlayer


@export var map_background: Control


signal screen_finished
signal message_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_rect.modulate = Color(0,0,0,1)
	dark_screen(0)
	SignalBus.update_ink.connect(update_ink_count)
	SignalBus.message_popup.connect(on_message_recived)
	SignalBus.player_died.connect(on_died)
	Dialogic.signal_event.connect(on_dialogic_signal)
	menu_buttuns = [map_button,back_to_game_button,main_menu_button,close_menu_button,menu_button]
	SignalBus.update_map.connect(on_map_update)
	SignalBus.transfer_to_scene.connect(transfer_to_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for button in menu_buttuns:
		if button.is_hovered():
			tween_scale(button,1.2,0.3,self)
		else:
			tween_scale(button,1,0.3,self)


func tween_scale(object,final,dur,bind_object:Node = self):
	object.pivot_offset = object.size / 2
	var tween = get_tree().create_tween().bind_node(bind_object)
	tween.tween_property(object,"scale",final * Vector2.ONE,dur)


func update_ink_count(type:String = "ink_amount"):
	ink_label.text = "Ink:"+str(Global.ink_amount)+"/"+str(Global.max_ink)
	ink_anim.play("shine")
	if type == "ink_amount":
		if prev_ink > Global.ink_amount:
			on_message_recived("Ink Used!")
			prev_ink = Global.ink_amount
		else:
			on_message_recived("Ink Added!")
			prev_ink = Global.ink_amount
	if type == "max_ink":
		on_message_recived("Larger Ink Pouch!")
	await get_tree().create_timer(2).timeout
	ink_anim.stop()

func on_message_recived(message:String):
	if message_label.modulate.a > 0:
		await message_finished
	message_label.text = message
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).bind_node(self)
	tween.tween_property(message_label,"modulate",Color(1,1,1,1),0.75)
	tween.tween_interval(1.25)
	tween.tween_property(message_label,"modulate",Color(1,1,1,0),0.75)
	await tween.finished
	message_finished.emit()


func _draw_map() -> void:
	map_background.queue_redraw()
	map_background.draw_polyline([Vector2(12, 34), Vector2(56, 78),Vector2(100,80)],Color(1,1,1,1),5)
	

func on_died():
	print("1")
	death_screen.visible = true
	var tween = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).bind_node(self)
	tween.tween_property(death_rect,"modulate",Color(0,0,0,1),0.4)
	tween.tween_property(death_label,"modulate",Color(1,1,1,1),0.5)
	tween.tween_interval(0.5)
	SignalBus.death_finished.emit()
	tween.tween_property(death_label,"modulate",Color(1,1,1,0),0.75)
	tween.tween_property(death_rect,"modulate",Color(0,0,0,0),0.75)
	await tween.finished
	death_screen.visible = false

func dark_screen(value:int = 1,dur:float = 1,object:Node = death_rect):
	death_screen.visible = !death_screen.visible
	var tween = self.create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).bind_node(self)
	tween.tween_property(object,"modulate",Color(0,0,0,value),dur)
	await tween.finished
	screen_finished.emit()
	death_screen.visible = !death_screen.visible
	

func on_dialogic_signal(arg:String):
	if arg == "back_to_main":
		transfer_to_scene("main_menu")
	if arg == "try_again":
		dark_screen()
		await screen_finished
		get_tree().reload_current_scene()

func transfer_to_scene(scene_name:String):
	dark_screen()
	await screen_finished
	get_tree().change_scene_to_file("res://scenes/"+scene_name+".tscn")

func _on_map_button_pressed() -> void:
	press_sfx.play()
	dark_screen()
	await screen_finished
	map_container.visible = !map_container.visible
	dark_screen(0)



func _on_map_button_mouse_entered() -> void:
	hover_sfx.play()

func on_map_update(id:int):
	for area in map.get_children():
		if area.area_id == id:
			area.visible = false
	map_background.handle_map_update()
func _on_menu_button_pressed() -> void:
	press_sfx.play()
	if !in_game_menu.visible:
		in_game_menu.visible = true
		menu_anim.play("open")
	else:
		menu_anim.play_backwards("open")
		await menu_anim.animation_finished
		in_game_menu.visible = false
	


func _on_back_to_main_button_pressed() -> void:
	press_sfx.play()
	transfer_to_scene("main_menu")
