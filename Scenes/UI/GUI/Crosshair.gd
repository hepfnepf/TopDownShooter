extends Node2D

onready var outer_crosshair = $OuterCrosshair
onready var inner_crosshair = $InnerCrosshair

export (float)var max_size = 1.0
export (float)var min_size = 0.5
export (float)var SIZE_SCALER = 0.2
export (float)var spread_scaler = 50.0

var dynamic:bool = true
var size:float = 1.0
var active:bool = true # wheather the current crosshait type contains crosshair, needed to check if the crosshair should be made visible again, after leaving pause menu

func _ready() -> void:
	init_values()
	EventBus.connect("crosshair_color_change",self,"_on_crosshair_color_change")
	EventBus.connect("crosshair_is_dynamic",self,"_on_crosshair_is_dynamic_change")
	EventBus.connect("crosshair_size_change",self,"_on_crosshair_size_change")
	EventBus.connect("settings_reset",self,"init_values")
	EventBus.connect("crosshair_type_changed",self,"_on_crosshair_type_change")
	EventBus.connect("hide_crosshair",self,"_on_hide_crosshair")

# warning-ignore:unused_argument
func _process(delta) -> void:
	global_position = get_viewport().get_mouse_position()

func init_values()->void:
	var color = Color(SaveManager.current_save_options["crosshair_color"])
	dynamic = SaveManager.current_save_options["crosshair_is_dynamic"]
	size = SaveManager.current_save_options["crosshair_size"]
	outer_crosshair.material.set("shader_param/color",color)
	inner_crosshair.material.set("shader_param/color",color)

	if !dynamic:
		set_static()

	_on_crosshair_type_change(SaveManager.current_save_options["crosshair_type"])


func set_spread(new_spread) -> void:
	if dynamic:
		var _spread =new_spread*spread_scaler*size
		_spread = sqrt(_spread)+(1/pow((_spread+1),2))*1/8
		_spread = clamp(_spread*1.1,min_size,max_size)
		outer_crosshair.scale = Vector2(_spread,_spread)

func set_static()->void:
	outer_crosshair.scale = Vector2(1.0,1.0)

func _on_crosshair_color_change(new_color:Color)->void:
	outer_crosshair.material.set("shader_param/color",new_color)
	inner_crosshair.material.set("shader_param/color",new_color)

func _on_crosshair_is_dynamic_change(is_dynamic:bool)->void:
	dynamic = is_dynamic
	if not dynamic:
		set_static()

func _on_crosshair_size_change(_size:float)->void:
	size = clamp(_size*SIZE_SCALER,min_size,max_size)
	scale = Vector2(size,size)

func _on_crosshair_type_change(new_crosshair_type:int)->void:
	if new_crosshair_type in [Globals.CrosshairType.CROSSHAIR,Globals.CrosshairType.BOTH]:
		visible = true
		active = true
	else:
		visible = false
		active = false

#Gets toggled when entering/exiting pause menu
func _on_hide_crosshair(hide:bool)->void:
	if hide:
		visible=false
	else:
		if active:
			visible = true
		else:
			visible = false
