/**
 * FORM ITEM REPEATER
 */

import { _FormItemEditor } from './form_item_editor'

class FormItemRepeater {
	
	constructor()
	{
		this.target = '.form-item--repeater-section'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', this.target + '--add-new', function(event){ addNewItem(this, event)} )
		
		$(document).on('click', '.form-item--remove-item-with-js', function( event )
		{
			// Stop default behaviour
			event.preventDefault()
			$( this ).parent( this.target ).remove()
			_FormItemEditor.resize()
		})

		$(document).on('click', '.form-item--delete-repeater-item', function( event )
		{
			// Stop default behaviour
			event.preventDefault()

			if ( !confirm($(this).data('confirm')) ) return

			$.ajax({
				url: $( this ).attr('href'),
				data: { id: $( this ).data('id'), isAjax: true },
				method: "DELETE"
			}).done( ()=>{
				$( this ).parents('.form-item--repeater').remove()
				_FormItemEditor.resize()
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
		let parts = data.split('<!-- SPLIT -->')
		let newRepeater = parts[1]
		$list.append( newRepeater )
		var editor_id = $list.find('textarea').last('textarea').attr('id')
		tinyMCE.EditorManager.execCommand('mceAddEditor',true, editor_id);
		_FormItemEditor.resize()
	})
}