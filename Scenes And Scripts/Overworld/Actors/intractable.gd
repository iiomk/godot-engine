extends Node2D

class_name intractable

enum type{
	CollosionShape2D,
	Area2D_
}

export(type) var I_am
export var When_I_Get_intracted_with:Script

func intracted():
	var Node_ = Node.new()
	add_child(Node_)
	Node_.set_script(When_I_Get_intracted_with)
	if Node_.has_method("_On_start"):
		Node_.call("_On_start")
	Node_.set_physics_process(true)
	Node_.set_process(true)

func _ready() -> void:
	if I_am == 1:
		$collosion.queue_free()
		var area = Area2D.new()
		var collosion = CollisionShape2D.new()
		collosion.shape = RectangleShape2D
		area.add_child(collosion)
		add_child(area)
		area.connect("body_entered",self,"Got_trigered")

func Got_trigered(the_triger:Node):
	if the_triger.is_in_group("player"):
		intracted()
