/**
 * FORM ITEM IMAGE
 */

import { custom_fileupload } from './fileupload_custom_script'

class FormItemImage
{
	constructor()
	{
		this.target = '.form-item--image--uploader'
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

export var _FormItemImage = new FormItemImage()