///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -

import { _FormItemCollapsable } from "./components/form_item_collapsable";
import { _FormItemImage } from "./components/form_item_image";
import { _FieldSettingChoices } from "./components/field_setting_choices";
import { _FileUpload } from "./components/fileupload";
import { _Shader } from "./components/login-shader";
import { _LoginForm } from "./components/login_form";
import setupSortable from "./components/sortable";
import setupFieldGroupEditor from "./components/field_group_editor";
import setupBootstrap from "./components/bootstrap";
import setupSelect2 from "./components/select2";
import setupRadioToggle from "./components/radio-toggle";

$(document).ready(function() {
	if (_FormItemCollapsable.isPresent()) {
		_FormItemCollapsable.setEvents();
	}
	if (_FormItemImage.isPresent()) {
		_FormItemImage.setEvents();
	}
	if (_FieldSettingChoices.isPresent()) {
		_FieldSettingChoices.setEvents();
	}
	if (_FileUpload.isPresent()) {
		_FileUpload.setEvents();
	}
	if (_LoginForm.isPresent()) {
		_LoginForm.init();
	}
	if (_Shader.isPresent()) {
		_Shader.setup();
		_Shader.start();
	}
	setupRadioToggle();
	setupSortable();
	setupFieldGroupEditor();
	setupBootstrap();
	setupSelect2();
});

// handle event
window.addEventListener("optimizedResize", function() {
	if (_Shader.isPresent()) {
		_Shader.resize();
	}
});
