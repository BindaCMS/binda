///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM ASSET
///- - - - - - - - - - - - - - - - - - - -

class FormItemAsset
{
	constructor()
	{
		this.target = '.form-item--asset'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		// here code to setup assets via ajax
	}
}

export var _FormItemAsset = new FormItemAsset()