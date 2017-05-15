///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -

class FormItemRepeater {
	
	constructor()
	{
		this.target = '.form-item--repeater'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', this.target + '--add-new', addNewItem )
		$(document).on('click', '.form-item--remove-item-with-js', function( event )
		{
			// Stop default behaviour
			event.preventDefault()
			$( this ).parent( this.target ).remove()
		})
	}
}

export let _FormItemRepeater = new FormItemRepeater()


function addNewItem( event ) 
{
	// Stop default behaviour
	event.preventDefault()
	// Get the child to clone
	let id = $( event.target ).data( 'id' )
	let url = $( event.target ).data( 'url' )
	$.post( url, { repeater_setting_id: id }, function( data )
	{
		let parts = data.split('<!-- SPLIT -->')
		let newRepeater = parts[1]
		$('#form-item--repeater-' + id ).append(newRepeater)
	})
}