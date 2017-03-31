///- - - - - - - - - - - - - - - - - - - -
/// PARENT GROUP FORM
///- - - - - - - - - - - - - - - - - - - -

class ParentGroupForm {
	
	constructor()
	{
		this.target = '.parent-group-form'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$(document).on('click', this.target + '--add-child', ( event )=>{
			// Stop default behaviour
			event.preventDefault()
			// Get the child to clone
			let id = $( event.target ).data( 'new-child-id' )
			let $newChild = $( '#' + id )
			// Clone child and remove id and styles from cloned child
			$newChild.clone().insertAfter( $newChild )
			$newChild.removeClass( 'parent-group-form--new-child' ).removeAttr( 'id' )
		})
	}
}

export let _ParentGroupForm = new ParentGroupForm()