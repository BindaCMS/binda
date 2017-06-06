///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -

import { _FormItem }         from './components/form_item'
import { _FormItemRepeater } from './components/form_item_repeater'
import { _FormItemAsset }    from './components/form_item_asset'
import setupSortable         from './components/sortable'

$(document).ready( function()
{
	if ( _FormItem.isSet() )         { _FormItem.setEvents() }
	if ( _FormItemRepeater.isSet() ) { _FormItemRepeater.setEvents() }
	if ( _FormItemAsset.isSet() )    { _FormItemAsset.setEvents() }
	setupSortable()
})