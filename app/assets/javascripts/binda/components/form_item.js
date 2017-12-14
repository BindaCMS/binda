/**
 * FORM ITEM
 */

import { _FormItemEditor } from './form_item_editor'
import { setupSelect2 } from './select2' 

// Component Global Variables
let newFormItemId = 1

class FormItem {
	
	constructor(){}

	isSet()
	{
		if ( $('.form-item').length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', '.form-item--add-new', addNewItem )

		$(document).on('click', '.form-item--remove-item-with-js', function( event )
		{
			// Stop default behaviour
			event.preventDefault()
			$( this ).parent('.form-item').remove()
		})

		$(document).on('click', '.form-item--toggle-button', function()
		{

			let $formItem = $( this ).parent('.form-item')
			let $formItemEditor = $formItem.children('.form-item--editor')
			
			if ( $formItemEditor.get(0).style.maxHeight === '' ) 
			{
				// Update height
				$formItemEditor.get(0).style.maxHeight = $formItemEditor.get(0).scrollHeight + "px";

				// Add class to trigger animation
				$formItem.children('.form-item--toggle-button').removeClass('form-item--toggle-button-closed')
			}
			else
			{
				// Zero height
				$formItemEditor.get(0).style.maxHeight = null;
		      
				// Add class to trigger animation
				$formItem.children('.form-item--toggle-button').addClass('form-item--toggle-button-closed')
			}
		})
	}
}

export let _FormItem = new FormItem()


///- - - - - - - - - - - - - - - - - - - -
/// COMPONENT HELPER FUNCTIONS
///- - - - - - - - - - - - - - - - - - - -

// This function could be improved as it generates an issue with 
// input ids which are duplicated after the entire target has been cloned
function addNewItem(event) 
{
	// Stop default behaviour
	event.preventDefault()
	// Get the child to clone 
	// (`this` always refers to the second argument of the $(document).on() method, in this case '.form-item--add-new')
	let id = $( this ).data( 'new-form-item-id' )
	let $newChild = $( '#' + id )
	// Clone child and remove id and styles from cloned child
	$newChild.clone().insertAfter( $newChild )
	// Remove class in order to remove styles, and change id so it's reachable when testing
	$newChild.removeClass( 'form-item--new' ).attr( 'id', 'new-form-item-'+newFormItemId )

	// // Update all ids to avoid duplication
	$newChild.find('[id]').each(function(){
		let oldId = $(this).attr('id')
		let newId = oldId + '-' + newFormItemId
		$(this).attr('id', newId )
		let $forId = $newChild.find('[for='+ oldId +']')
		if ( $forId.length > 0 ) { $forId.attr('for', newId) }
	})

	// Update height (max-height) of the new element
	let $formItemEditor = $('#new-form-item-'+newFormItemId).find('.form-item--editor')
	$formItemEditor.get(0).style.maxHeight = $formItemEditor.get(0).scrollHeight + "px";

	// Increment global id variable `newFormItemId` in case needs to be used again
	newFormItemId++
	_FormItemEditor.resize()

	setupSelect2( $formItemEditor.find('select') )
}