tool
extends Control

onready var fileInputZip = $TabContainer/Settings/VBoxContainer/FileInputZip



onready var iconLabels = [
	$TabContainer/Settings/VBoxContainer/IconLabelInfo,
	$TabContainer/Settings/VBoxContainer/IconLabelFileDoesNotExist,
	$TabContainer/Settings/VBoxContainer/IconLabelFileNotValid,
	$TabContainer/Settings/VBoxContainer/IconLabelFileValid
]

func _ready():
	if Atlasica.ei:
		# Dialogs must be in editor base control
		fileInputZip.file_dialog_root = Atlasica.ei.get_base_control()
		
		var themed_node:Control = Atlasica.ei.get_inspector()
		for iconLabel in get_tree().get_nodes_in_group("IconLabel"):
			iconLabel.themed_node = themed_node
			
func _on_FileInputZip_value_changed(value):
	Atlasica.get_state().path_zip = value
	
func _on_state_changed(state):
	iconLabels[0].visible = !state.has_configured_zip_path()
	iconLabels[1].visible = !state.has_valid_zip_path()
	iconLabels[2].visible = !state.has_valid_zip()
	iconLabels[3].visible = !iconLabels[2].visible
	
	var is_all_valid = state.is_valid()
	$TabContainer.set_tab_disabled(1, !is_all_valid)
	$TabContainer.set_tab_disabled(2, !is_all_valid)

func _on_BtnUpdateAtlas_pressed():
	if Atlasica.get_state().has_valid_zip():
		Atlasica.update_resources()

func _on_TabContainer_tab_changed(tab):
	if tab == 1: update_tab_atlas()
	if tab == 2: update_tab_list()
	
func update_tab_atlas():
	var state = Atlasica.get_state()
	$TabContainer/Atlas/ViewAtlas.init(state.get_atlas_image(), state.get_atlas_layout())
func update_tab_list():
	var state = Atlasica.get_state()
	$"TabContainer/List of Sprites/ViewList".init(state.get_atlas_image(), state.get_atlas_layout())
