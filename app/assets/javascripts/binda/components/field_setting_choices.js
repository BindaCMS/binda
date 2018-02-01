/**
 * FORM ITEM CHOICE
 */

import { _FormItemEditor } from "./form_item_editor";

class FieldSettingChoices {
	constructor() {
		this.target = ".field-setting-choices--choice";
	}

	isSet() {
		if ($(this.target).length > 0) {
			return true;
		} else {
			return false;
		}
	}

	setEvents() {
		$(document).on(
			"click", 
			".field-setting-choices--add-choice", 
			addChoice
		);

		$(document).on(
			"click",
			".field-setting-choices--delete-choice",
			deleteChoice
		);

		$(document).on(
			"click",
			".field-setting-choices--js-delete-choice",
			function(event) {
				event.preventDefault();
				$(this)
					.closest(".field-setting-choices--choice")
					.remove();
				// Update form item editor size
				_FormItemEditor.resize();
			}
		);
	}
}

export let _FieldSettingChoices = new FieldSettingChoices();

/**
 * HELPER FUNCTIONS
 */

function addChoice(event) {
	event.preventDefault();
	// Clone the new choice field
	var choices_id = $(this).data("choices-id");
	var choices = $(`#${choices_id}`);
	var newchoice = choices.find(".field-setting-choices--new-choice");
	var clone = newchoice
		.clone()
		.removeClass("field-setting-choices--new-choice")
		.toggle();
	clone.find(".field-setting-choices--toggle-choice").toggle();
	// Append the clone right after
	choices.prepend(clone);
	// Update form item editor size
	_FormItemEditor.resize();
}

function deleteChoice(event) {
	event.preventDefault();

	var choice = $(this).closest(".field-setting-choices--choice");
	var destination = $(this).attr("href");
	var self = this;

	$.ajax({
		url: destination,
		type: "DELETE"
	}).done(function() {
		choice.remove();
		// Update form item editor size
		_FormItemEditor.resize();
	}).fail(function(data){
		alert(data.responseJSON.errors);
	});
}
