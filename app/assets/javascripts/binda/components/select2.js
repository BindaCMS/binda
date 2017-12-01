/**
 * OPTIONAL
 */

export default function ()
{
	$('select').select2({ minimumResultsForSearch: 32 }) // 31 are max number of day in a month, which you don't want to be searchable
}