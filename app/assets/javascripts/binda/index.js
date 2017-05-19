///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -

import { _FormItem } from './components/form_item'
import { _FormItemRepeater } from './components/form_item_repeater'
import { sortableInit } from './components/sortable'

$(document).ready( function()
{
	if ( _FormItem.isSet() )         { _FormItem.setEvents() }
	if ( _FormItemRepeater.isSet() ) { _FormItemRepeater.setEvents() }
	sortableInit()
})