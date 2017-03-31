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
			event.preventDefault()
			let $newChild = $( this.target + '--new-child' )
			$newChild.clone().insertAfter( $newChild )
			$newChild.removeClass( 'parent-group-form--new-child' )
			// let url = $( event.target ).data('add-child-path')
			// $.post( url, '', function( response ) 
			// {
			//	// some code...
			// })
		})
	}
}

export let _ParentGroupForm = new ParentGroupForm()