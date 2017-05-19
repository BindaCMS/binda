export function sortableInit() 
{
	if ( $('.sortable').length > 0 ) 
	{
		$('.sortable')
			.sortable({
		  	placeholder: "ui-state-highlight",
		  	update: function () {
					$.post(
						$(this).data('update-url'),
						$(this).sortable('serialize')
					// ).done( 
					// 	function( data ) {
					// 		$('body').append( data );
					// 	}
					)
		  	}
		  })
		  .disableSelection()
	}
}