tool
extends PanelContainer
class_name UnitEditorPanel

var editor_file_system: EditorFileSystem;

func _on_UnitList_UnitDeleted():
	if !editor_file_system:
		return;
	editor_file_system.scan();
