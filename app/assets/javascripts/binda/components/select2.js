/**
 * OPTIONAL (SELECT2 PLUGIN)
 */

export default function ()
{
	setupSelect2('select')
}

export function setupSelect2(target)
{
	$(target).select2({ minimumResultsForSearch: 32 }) // 31 are max number of day in a month, which you don't want to be searchable
}