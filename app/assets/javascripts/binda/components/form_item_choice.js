///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -

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
			var choices = $( this ).parent('.form-item--choices')
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

			var choice = $( this ).parent('.form-item--choice')
			var destination = $( this ).attr('href')
			
			$.ajax({
				url: destination,
				type: 'DELETE',
				success: function() { choice.remove() }
			})
		})
		$(document).on('click', '.form-item--js-delete-choice', function( event )
		{
			event.preventDefault()
			$( this ).parent('.form-item--choice').remove() 
		})
	}
}

export let _FormItemChoice = new FormItemChoice()