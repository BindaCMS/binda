import { _ParentGroupForm } from './components/parent_group_form.js'

$(document).ready( function()
{
	if ( _ParentGroupForm.isSet() ) { _ParentGroupForm.setEvents() }
})