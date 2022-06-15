tool
extends EditorPlugin

const editor = preload("res://addons/UnitCreator/Scenes/Editor.tscn");
var instance: Control = null;

func _enter_tree():
	instance = editor.instance();
	add_control_to_bottom_panel(instance, get_plugin_name());

func make_visible(visible):
	if !instance:
		return;
	instance.visible = visible;

func _exit_tree():
	if !instance:
		return;
	remove_control_from_bottom_panel(instance);
	instance.queue_free();
	

func get_plugin_name():
	return "Unit Editor";
