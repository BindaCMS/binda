///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -

import { _FormItem }                 from './components/form_item'
import { _FormItemRepeater }         from './components/form_item_repeater'
import { _FormItemImage }            from './components/form_item_image'
import { _FieldSettingChoices }      from './components/field_setting_choices'
import { _FormItemEditor }           from './components/form_item_editor'
import { _FileUpload }               from './components/fileupload'
import { _Shader }                   from './components/login-shader'
import { _LoginForm }                from './components/login_form'
import setupSortable                 from './components/sortable'
import setupFieldGroupEditor         from './components/field_group_editor'
import setupBootstrap                from './components/bootstrap'
import setupSelect2                  from './components/select2'
import setupRadioToggle              from './components/radio-toggle'

$(document).ready( function()
{
	if ( _FormItem.isSet() )                 { _FormItem.setEvents() }
	if ( _FormItemRepeater.isSet() )         { _FormItemRepeater.setEvents() }
	if ( _FormItemImage.isSet() )            { _FormItemImage.setEvents() }
	if ( _FieldSettingChoices.isSet() )   { _FieldSettingChoices.setEvents() }
	if ( _FormItemEditor.isSet() )           { _FormItemEditor.setEvents() }
	if ( _FileUpload.isSet() )               { _FileUpload.setEvents() }
  if ( _LoginForm.isSet() )                { _LoginForm.setEvents() }
  if ( _Shader.isSet() ) 
  {
		_Shader.setup()
		_Shader.start()
  }
	setupRadioToggle()
	setupSortable()
	setupFieldGroupEditor()
	setupBootstrap()
	setupSelect2()
})

// handle event
window.addEventListener("optimizedResize", function() {
  if ( _Shader.isSet() ) { _Shader.resize() }
});