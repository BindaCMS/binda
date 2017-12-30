/**
 * FORM ITEM REPEATER
 */

import { _FormItemEditor } from './form_item_editor'
import { setupSelect2 } from './select2' 

class FormItemRepeater {
	
	constructor(){}

	isSet()
	{
		if ( $('.form-item--repeater-section').length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', '.form-item--repeater-section--add-new', function(event){ addNewItem(this, event)} )
		
		$(document).on('click', '.form-item--remove-item-with-js', function( event )
		{
			// Stop default behaviour
			event.preventDefault()
			$( this ).parent('.form-item--repeater-section').remove()
			_FormItemEditor.resize()
		})

		$(document).on('click', '.form-item--delete-repeater-item', function( event )
		{
			// Stop default behaviour
			event.preventDefault()

			// if ( !confirm($(this).data('confirm')) ) return
			
			let record_id = $( this ).data('id') 
			let target = $('#repeater_' + record_id).get(0)
			// As max-height isn't set you need to set it manually before changing it, 
			// otherwise the animation doesn't get triggered
			target.style.maxHeight = target.scrollHeight + 'px'	
			// Change max-height after 50ms to trigger css animation
			setTimeout( function(){ target.style.maxHeight = 0 + 'px'	}, 50)

			$.ajax({
				url: $( this ).attr('href'),
				data: { id: record_id, isAjax: true },
				method: "DELETE"
			}).done( ()=>{
				// Make sure the animation completes before removing the item (it should last 600ms + 50ms)
				setTimeout( function(){ $(target).remove() }, 700)
				// _FormItemEditor.resize()
			})
		})
	}
}

export let _FormItemRepeater = new FormItemRepeater()


/**
 * COMPONENT HELPER FUNCTIONS
 *
 * @param      {string}  target  The target
 * @param      {object}  event   The event
 */

function addNewItem( target, event ) 
{
	// Stop default behaviour
	event.preventDefault()
	// Get the child to clone
	let id = $( target ).data( 'id' )
	let $list = $('#form-item--repeater-setting-' + id )
	let url = $( target ).data( 'url' )
	$.post( url, { repeater_setting_id: id }, function( data )
	{
		// Get repaeter code from Rails
		// Due to the Rails way of creating nested forms it's necessary to 
		// create the nested item inside a different new form, then get just
		// the code contained between the two SPLIT comments
		let parts = data.split('<!-- SPLIT -->')
		let newRepeater = parts[1]

		// Append the item
		$list.prepend( newRepeater )
		let new_repeater_item = $list.find('.form-item--repeater').get(0)

		// Prepare animation
		new_repeater_item.style.maxHeight = 0

		// Group fields if sotrable is enabled
		if ( $list.hasClass('sortable--enabled') ) 
		{
			$(new_repeater_item).find('.form-item--repeater-fields').each(function()
			{
				this.style.maxHeight = 0 + 'px'
			})
		}

		// Setup TinyMCE for the newly created item
		var textarea_editor_id = $list.find('textarea').last('textarea').attr('id')
		tinyMCE.EditorManager.execCommand('mceAddEditor',true, textarea_editor_id);
		
		// Resize the editor (is it needed with the new configuration?)
		// _FormItemEditor.resize()
		
		// Update select input for Select2 plugin
		setupSelect2( $list.find('select') )

		// Refresh Sortable to update the added item with Sortable features
		$list.sortable('refresh')
	
		// Run animation 50ms after previous style declaration (see above) otherwise animation doesn't get triggered
		setTimeout( function()
		{
			new_repeater_item.style.maxHeight = new_repeater_item.scrollHeight + 'px' 
		}, 50)
	})
}