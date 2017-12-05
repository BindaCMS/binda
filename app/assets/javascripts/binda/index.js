///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -

import { _FormItem }         from './components/form_item'
import { _FormItemRepeater } from './components/form_item_repeater'
import { _FormItemImage }    from './components/form_item_image'
import { _FormItemChoice }   from './components/form_item_choice'
import { _FormItemEditor }   from './components/form_item_editor'
import { _FileUpload }       from './components/fileupload'
import setupSortable         from './components/sortable'
import setupFieldGroupEditor from './components/field_group_editor'
import setupBootstrap        from './components/bootstrap'
import setupSelect2          from './components/select2'

$(document).ready( function()
{
	if ( _FormItem.isSet() )         { _FormItem.setEvents() }
	if ( _FormItemRepeater.isSet() ) { _FormItemRepeater.setEvents() }
	if ( _FormItemImage.isSet() )    { _FormItemImage.setEvents() }
	if ( _FormItemChoice.isSet() )   { _FormItemChoice.setEvents() }
	if ( _FormItemEditor.isSet() )   { _FormItemEditor.setEvents() }
	if ( _FileUpload.isSet() )       { _FileUpload.setEvents() }
	setupSortable()
	setupFieldGroupEditor()
	setupBootstrap()
	setupSelect2()
})