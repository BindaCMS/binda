/**
 * FORM ITEM CHOICE
 */

import { _FormItemEditor } from './form_item_editor'


class FormItemChoice {
	
	constructor()
	{
		this.target = '.form-item--choice'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', '.form-item--add-choice', function( event )
		{
			event.preventDefault()
			// Clone the new choice field
			var choices = $( this ).closest('.form-item--choices')
			var newchoice = choices.find('.form-item--new-choice')
			var clone = newchoice.clone().removeClass('form-item--new-choice').toggle()
			clone.find('.form-item--toggle-choice').toggle()
			// Append the clone right after
			choices.prepend( clone )
			// Update form item editor size
			_FormItemEditor.resize()
		})
		
		$(document).on('click', '.form-item--delete-choice', function( event )
		{
			event.preventDefault()

			var choice = $( this ).closest('.form-item--choice')
			var destination = $( this ).attr('href')
			var self = this

			$.ajax({
				url: destination,
				type: 'DELETE',
				success: function() { 
					choice.remove()
					// Update form item editor size
					_FormItemEditor.resize()
				}
			})
		})
		$(document).on('click', '.form-item--js-delete-choice', function( event )
		{
			event.preventDefault()
			$( this ).closest('.form-item--choice').remove()
			// Update form item editor size
			_FormItemEditor.resize()
		})
	}
}

export let _FormItemChoice = new FormItemChoice()