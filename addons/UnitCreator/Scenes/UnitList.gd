tool
extends ItemList
class_name UnitResouceList
signal UnitSelected(unit, id);
signal UnitDeselected;

export(String, DIR) var units_directory; 

onready var unit_script = preload("res://Resources/UnitRes/UnitRes.gd");
var should_exectue: bool = false;
var unit_list: Array = [];
var current_selected_unit: UnitResource = null;

func _ready():
	if units_directory == "":
		printerr("Unit Editor: units directory have to be provided");
		should_exectue = false;
		return;
	
	load_units();

func load_units() -> void:
	clear();
	unit_list.clear();
	var dir = Directory.new();
	if dir.open(units_directory) != OK:
		printerr("Unit Editor: could not open units directory");
		should_exectue = false;
		return;
	
	dir.list_dir_begin();
	var file_name = dir.get_next();
	var paths: Array = [];
	
	while file_name != "":
		if !dir.current_is_dir():
			paths.append(dir.get_current_dir() + "/" + file_name)
		file_name = dir.get_next();
	
	dir.list_dir_end();
	
	for file_path in paths:
		var resource = ResourceLoader.load(file_path);
		if !(resource is UnitResource):
			continue;
		unit_list.append(resource as UnitResource);
		add_item(resource.unit_name);
	should_exectue = true;

func on_select(id: int) -> void:
	if !should_exectue || id > unit_list.size() - 1:
		return;
		
	current_selected_unit = unit_list[id];
	emit_signal("UnitDeselected", current_selected_unit, id);

func on_deselect() -> void:
	pass;

func create_new_unit() -> void:
	if !should_exectue:
		return;

	var new_unit = unit_script.new();
	new_unit.unit_name = "New Unit";
	var err = ResourceSaver.save(units_directory + "/" + new_unit.unit_name + str(unit_list.size()) + ".tres", new_unit);
	
func delete_unit() -> void:
	if !should_exectue || !current_selected_unit:
		return;
	var path_to_unit = current_selected_unit.resource_path;
	var dir = Directory.new();
	var err = dir.remove(path_to_unit);
	
	if err != OK:
		print("Unit Editor: could not delete unit file");
		return;
	
	current_selected_unit = null;
	load_units();
	
func _on_CreateBTN_pressed():
	create_new_unit();
	load_units();

func _on_UnitList_item_selected(index):
	on_select(index);
	pass # Replace with function body.

func _on_DeleteBTN_pressed():
	delete_unit();
	pass # Replace with function body.
