export default function() 
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

		// Check if sortable item needs handles
		$('.sortable').each( function()
		{			
			if ( $(this).find('.sortable--handle').length > 0 ) 
				{ $(this).sortable('option', 'handle', '.sortable--handle') }
			else
				{ $(this).addClass('sortable--no-handle') }
		})

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

	 	$( id ).toggleClass('sortable--disabled')
	 	$( id ).toggleClass('sortable--enabled')
	 	$( this ).children('.sortable--toggle-text').toggle()
	})
}