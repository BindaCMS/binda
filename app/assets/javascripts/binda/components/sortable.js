export function sortableInit() 
{
	if ( $('.sortable').length > 0 ) 
	{
		// Initialize sortable item
		$('.sortable')
			.sortable({
		  	placeholder: "ui-state-highlight",
		  	update: function () {
					$.post(
						$(this).data('update-url'),
						$(this).sortable('serialize')
					)
		  	}
		  })
		  .disableSelection()
		  .addClass('sortable--no-handle')

		// Check if sortable item needs handles
		if ( $('.sortable--handle').length > 0 ) 
		{
			$('.sortable--handle')
				.parents('.sortable')
				.removeClass('sortable--no-handle')
				.sortable('option', 'handle', '.sortable--handle')
		}

	  $('.sortable--disabled').sortable('disable')
	}

	$(document).on( 'click', '.sortable--toggle', function( event )
	{
		event.preventDefault()
		let id = '#' + $( this ).data( 'repeater-id' )

		if ( $( id ).hasClass('sortable--disabled') )
			{ $( id ).sortable('enable') }
		else
			{ $( id ).sortable('disable') }


		console.log('oi')
	 	$( id ).toggleClass('sortable--disabled')
	 	$( id ).toggleClass('sortable--enabled')
	 	$( this ).children('.sortable--toggle-text').toggle()
	})
}