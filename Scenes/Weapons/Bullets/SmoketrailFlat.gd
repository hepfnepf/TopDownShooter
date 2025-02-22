extends Line2D
class_name Smoketrail

signal dead

export var length:float = 500

onready var tween:Tween = $Decay

func _ready():
	#clear_points()
	points[1] = get_parent().global_position
	points[0] = get_parent().global_position
	connect("dead",get_parent(),"_on_trail_faded")
	set_as_toplevel(true)


func add_point(point_pos:Vector2, _at_po :=-1):#playce in space to be spawned at, position in the array to be spawned at
	update_position(to_local(point_pos))

func update_position(point_pos:Vector2):
	points[0] = point_pos
	if points[1].distance_squared_to(points[0]) > length*length:
		points[1]= points[0].direction_to(points[1]).normalized()*length+points[0]
	update()

func fade_out(time=2.0):
	tween.interpolate_property(self,"modulate:a",1.0,0.0,time,Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.start()

func _on_Decay_tween_all_completed():
	emit_signal("dead")
	disable()

# ---------------- For Object Pooling --------------
#Gets called from parent
func reset():
	set_process(true)
	set_physics_process(true)
	points[1] = get_parent().global_position
	points[0] = get_parent().global_position
	modulate.a = 1.0
	visible = true

func disable():
	visible = false
	set_process(false)
	set_physics_process(false)
