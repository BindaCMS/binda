/**
 * FORM ITEM EDITOR
 */

class FormItemEditor {
	
	constructor()
	{
		this.target = '.form-item--editor'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		// run resize to set initial size
		this.resize()
		// run resize on each of these events
		$(window).resize( ()=>{ this.resize() } )
	}

	resize()
	{
		$( this.target ).each( function(){
			// If the form item editor is closed don't go any further
			if ( $(this).height() === 0 ) return
			// otherwise update the max-height which is needed for the CSS transition
			// NOTE you need to remove the max-height (inside 'style' attribute) to get the real height
			$(this).get(0).style.height = 'auto'
			$(this).get(0).style.maxHeight = $(this).get(0).scrollHeight + "px";
		})
	}
}

export let _FormItemEditor = new FormItemEditor()