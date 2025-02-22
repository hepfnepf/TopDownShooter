extends MarginContainer


onready var game_tab = $"%Game"
onready var ui_tab = $"%UI"
onready var controls_tab = $"%Controls"
onready var sound_tab = $"%Sound"
onready var language_tab = $"%Language"


func _ready() -> void:
	load_settings()
	EventBus.connect("settings_reset",self,"load_settings")

func _on_ExitButton_pressed()->void:
	visible = false
	store_settings()

func hide_background_color():
	$ColorRect.color = Color(0,0,0,0)


func load_settings()->void:
	var sg = SaveManager.get_options_save()

	ui_tab.blood_on_screen_toggle.pressed = sg["blood_overlay_enabled"]
	ui_tab.crosshair_dynamic_toggle.pressed=sg["crosshair_is_dynamic"]
	ui_tab.crosshair_color_picker.color= Color(sg["crosshair_color"])
	ui_tab.crosshair_size.value= sg["crosshair_size"]
	ui_tab.current_crosshair=sg["crosshair_type"]
	ui_tab.crosshair_cone_dynamic_toggle.pressed=sg["cone_crosshair_is_dynamic"]
	ui_tab.crosshair_cone_color_picker.color=sg["crosshair_color"]
	ui_tab.crosshair_cone_size.value=sg["cone_crosshair_size"]


	game_tab.max_enemy_count_slider.value = sg["max_enemy_count"]
	game_tab.set_enemy_count_label(sg["max_enemy_count"])

func store_settings()->void:
	var sg = SaveManager.get_options_save()

	sg["sfx_volume"] = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	sg["music_volume"] = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sg["sfx_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	sg["music_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))

	sg["fullscreen_enabled"] = OS.window_fullscreen
	sg["vsync_enabled"]= OS.vsync_enabled

	sg["zooming_inverted"]=controls_tab.zoom_inverted_toggle_button.pressed

	sg["blood_overlay_enabled"]=ui_tab.blood_on_screen_toggle.pressed
	sg["crosshair_type"] = ui_tab.current_crosshair
	sg["crosshair_is_dynamic"]=ui_tab.crosshair_dynamic_toggle.pressed
	sg["crosshair_color"] = ui_tab.crosshair_color_picker.color.to_html()
	sg["crosshair_size"] = ui_tab.crosshair_size.value
	sg["cone_crosshair_is_dynamic"] = ui_tab.crosshair_cone_dynamic_toggle.pressed
	sg["cone_crosshair_size"] = ui_tab.crosshair_cone_size.value

	sg["max_enemy_count"] = game_tab.max_enemy_count_slider.value
	sg["language"] = TranslationServer.get_locale()
	sg["key_bindings"] = controls_tab.get_key_binding_dict()


	SaveManager.set_options_save(sg)
