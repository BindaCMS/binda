/**
 * OPTIONAL (SELECT2 PLUGIN)
 */

export default function ()
{
	setupSelect2('.select2-item')
}

export function setupSelect2(target)
{
	$(target).each(function()
	{
		let placeholder = $(this).attr('placeholder')
		if ( typeof placeholder == 'undefined' ) { placeholder = 'Select a option' }

		$(this).select2({ 
			minimumResultsForSearch: 32, // 31 are max number of day in a month, which you don't want to be searchable
			placeholder: placeholder
		})
	}) 
}