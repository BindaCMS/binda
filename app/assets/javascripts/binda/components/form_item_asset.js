///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM ASSET
///- - - - - - - - - - - - - - - - - - - -

import { custom_fileupload } from './fileupload_custom_script'

class FormItemAsset
{
	constructor()
	{
		this.target = '.form-item--asset--uploader'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$('.fileupload').each( function () { custom_fileupload( this ) });
	}
}

export var _FormItemAsset = new FormItemAsset()