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
			$( this ).closest('.form-item').remove()
		})

		$(document).on('click', '.form-item--collapse-btn', function( event )
		{
			// This function is temporarely just set for repeaters.
			// TODO: Need refactoring in order to be available also for generic form items
 
 			// Stop default behaviour
			event.preventDefault()

			let $collapsable = $(this).closest('.form-item--collapsable')

			if ( $collapsable.hasClass('form-item--collapsed') ) 
			{
				$collapsable.find('.form-item--repeater-fields').each(open)
				$collapsable.removeClass('form-item--collapsed')
			}
			else
			{
				$collapsable.find('.form-item--repeater-fields').each(close)
				$collapsable.addClass('form-item--collapsed')
			}
		})

		$(document).on('click', '.form-item--toggle-button', function()
		{

			let $formItem = $( this ).closest('.form-item')
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

	// override current max-height which is set to 0
	$formItemEditor.get(0).style.maxHeight = $formItemEditor.get(0).scrollHeight + "px";

	_FormItemEditor.resize()

	// Increment global id variable `newFormItemId` in case needs to be used again
	newFormItemId++

	setupSelect2( $formItemEditor.find('select') )
}

function close()
{
	this.style.maxHeight = '0px'
}

function open()
{
	this.style.maxHeight = this.scrollHeight + "px";
}