extends CanvasLayer

var poses = [15,415]
var text_arr = []
var sound_arr = []
var speed_arr = []
var animation_arr = []
var can_skip_arr = []
var hide_panel_arr = []

enum{
	ready,
	running,
	done
}

var current_state = ready

func _ready() -> void:
	add_text(["img[res://Sprites/sanshead1.png]test","ssssssssssssssssuas"])

func add_text(text:Array,sound=[],speed:Array=[],animation:Array=[],can_skip:Array=[],hide_panel:Array=[]):
	text_arr = text
	if speed.size() == text.size():
		speed_arr = speed
	else:
		for i in range(text.size()):
			speed_arr.push_front(1)
	if sound.size() == text.size():
		sound_arr = sound
	else:
		for i in range(text.size()):
			sound_arr.push_front(preload("res://Sounds/sans_underswap.ogg"))
	

func hide_():
	hide()
	$text/text.text = ""
	$text/start.text = ""


func change_state(new_state):
	current_state = new_state

var time = 0
var sound = null

func begin():
	$text/sprite_animation.texture = null
	var text = text_arr[time]
	var speed = speed_arr[time]
	sound = sound_arr[time]
	print(speed)
	var img = false
	var img2 = false
	var img_path = ""
	var img_path2 = ""
	if "img[" in text:
		for i in text:
			var a = text.find(i)
			if img:
				if not img2:
					img_path += i
				else:
					img_path2 += i
				if i == "]":
					text[a] = ""
					break
				if i == ",":
					img2 = true
			if i == "[":
				img = true
			text[a] = ""
	if img_path != "":
		img_path[-1] = ""
		image_1 = load(img_path)
		$text/sprite_animation.texture = image_1
		if img_path2 != "":
			img_path2[-1] = ""
			image_2 = img_path2
	$text/text.percent_visible = 0.0
	$text/text.bbcode_text = text
	$Tween.interpolate_property($text/text,"percent_visible",0.0,1.0,len(text)*0.05*speed)
	$Tween.start()
	time += 1

var image_1 = null
var image_2 = null

func _physics_process(delta: float) -> void:
	match current_state:
		ready:
			if text_arr.size() == time:
				hide_()
				time = 0
				text_arr = []
				speed_arr = []
				sound_arr = []
			else:
				show()
				begin()
				$AudioStreamPlayer.stream = sound
				$AudioStreamPlayer.play()
				change_state(running)
		running:
			if Input.is_action_pressed("ui_cancel"):
				$Tween.remove_all()
				$text/text.percent_visible = 1.0
			if $text/text.text[$text/text.visible_characters] in [".","?","!"] and $text/text.percent_visible != 1.0:
				var i = int($text/text.visible_characters/25)
				for i_ in range(i):
					$text/start.text+="/n"
				$text/start.text+="*"
			if $text/text.percent_visible == 1.0:
				change_state(done)
		done:
			$AudioStreamPlayer.stop()
			if Input.is_action_just_pressed("ui_accept"):
				change_state(ready)
