/**
 * FORM ITEM IMAGE
 */

class FormItemImage {
	constructor() {
		this.target = ".form-item--image--uploader";
	}

	isPresent() {
		if ($(this.target).length > 0) {
			return true;
		} else {
			return false;
		}
	}

	setEvents() {}
}

export var _FormItemImage = new FormItemImage();
