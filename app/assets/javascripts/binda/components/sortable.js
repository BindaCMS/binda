/**
 * SORTABLE
 */

export default function() 
{
	if ( $('.sortable').length > 0 ) 
	{
		// Initialize sortable item
		$('.sortable')
			.sortable({
				stop: function(event, ui){
					ui.item.css('z-index', 0)
				},
		  	placeholder: "ui-state-highlight",
		  	update: function () {
		  		if ( $('.popup-warning').length > 0 ) {
		  			$('.sortable').addClass('sortable--disabled')
		  			$('.popup-warning').removeClass('popup-warning--hidden')
		  			$(this).sortable('option','disabled', true)
		  		}
					let url = $(this).data('update-url')
					let data = $(this).sortable('serialize')
					// If there is a pagination update accordingly
					data = data.concat(`&id=${$(this).attr('id')}`)
					$.post( url, data )
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

	// If there is a sortable toggle button prepare the sortable items accordingly
	if ( $('.sortable--toggle').length > 0 ) { setupSortableToggle() }

	// Add event to any sortable toggle button
	// TODO: make this event available to element which aren't standard form repeaters
	$(document).on('click', '.standard-form--repeater .sortable--toggle', function( event )
	{
		event.preventDefault()
		let id = '#' + $( this ).data('repeater-id')

		if ( $( id ).hasClass('sortable--disabled') )
		{ 
			$( id ).sortable('enable')
			$( id ).find('.form-item--repeater-fields').each(close)
			$( id ).find('.form-item--collapsable').addClass('form-item--collapsed')
		}
		else
		{ 
			$( id ).sortable('disable')
		}

	 	$( id ).toggleClass('sortable--disabled')
	 	$( id ).toggleClass('sortable--enabled')
	 	$( this ).children('.sortable--toggle-text').toggle()
	})
}


function setupSortableToggle() 
{
	$('.sortable--toggle').each(function()
	{
		let id = '#' + $( this ).data('repeater-id')
		$( id ).find('.form-item--collapsable').addClass('form-item--collapsed')
		$( id ).find('.form-item--repeater-fields').each(close)
	})
}

function close()
{
	this.style.maxHeight = '0px'
}

function open()
{
	this.style.maxHeight = this.scrollHeight + "px";
}