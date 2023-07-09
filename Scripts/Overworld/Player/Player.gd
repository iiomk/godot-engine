extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 160

func _physics_process(delta):
	move()
	anime()
	velocity = move_and_slide(velocity)

func move():
	var num = 6000
	var input = Vector2(
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
	)
	if Input.is_action_pressed("ui_cancel"):
		num = 12000
	var delta = get_physics_process_delta_time()
	velocity = input * num * delta

func anime():
	pass
