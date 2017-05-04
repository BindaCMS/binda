///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -

class FormItem {
	
	constructor()
	{
		this.target = '.form-item'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', this.target + '--add-new', function( event ) 
		{
			// Stop default behaviour
			event.preventDefault()
			// Get the child to clone
			let id = $( event.target ).data( 'new-child-id' )
			let $newChild = $( '#' + id )
			// Clone child and remove id and styles from cloned child
			$newChild.clone().insertAfter( $newChild )
			$newChild.removeClass( 'form-item--new' ).removeAttr( 'id' )
		})

		$(document).on('click', '.form-item--remove-item-with-js', function( event )
		{
			// Stop default behaviour
			event.preventDefault()
			$( this ).parent('.form-item').remove()
		})
	}
}

export let _FormItem = new FormItem()