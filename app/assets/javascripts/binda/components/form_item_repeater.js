/**
 * FORM ITEM REPEATER
 */

import { _FormItemEditor } from "./form_item_editor";
import { setupSelect2 } from "./select2";

class FormItemRepeater {
	constructor() {}

	isSet() {
		if ($(".form-item--repeater-section").length > 0) {
			return true;
		} else {
			return false;
		}
	}

	setEvents() {
		$(document).on("click", ".form-item--repeater-section--add-new", addNewItem);
		$(document).on("click", ".form-item--delete-repeater-item", deleteRepeter);
	}
}

export let _FormItemRepeater = new FormItemRepeater();

/**
 * COMPONENT HELPER FUNCTIONS
 */

function addNewItem(event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	let id = $(this).data("id");
	let $list = $("#form-item--repeater-setting-" + id);
	let url = $(this).data("url");
	let data = $list.sortable("serialize");
	data = data.concat(`&repeater_setting_id=${id}`);

	$.post(url, data, function(data) {
		// Get repaeter code from Rails
		// Due to the Rails way of creating nested forms it's necessary to
		// create the nested item inside a different new form, then get just
		// the code contained between the two SPLIT comments
		let parts = data.split("<!-- SPLIT -->");
		let newRepeater = parts[1];
		setupAndAppend(newRepeater, $list);
	});
}

function setupAndAppend(newRepeater, $list) {
	// Append the item
	$list.prepend(newRepeater);
	let new_repeater_item = $list.find(".form-item--repeater").get(0);

	// Prepare repeater animation
	new_repeater_item.style.maxHeight = "0px";

	// Setup TinyMCE for the newly created item
	var textarea_editor_id = $list
		.find("textarea")
		.last("textarea")
		.attr("id");
	tinyMCE.EditorManager.execCommand("mceAddEditor", true, textarea_editor_id);

	// // Prepare collapsable stack animation
	// $(new_repeater_item)
	// 	.find(".form-item--collapsable-stack")
	// 	.each(function() {
	// 		if (!$list.hasClass("sortable--enabled")) {
	// 			// Prepare field stack for collapsable animation
	// 			this.style.maxHeight = new_repeater_item.scrollHeight + "px";
	// 		}
	// 	});

	// Resize the editor (is it needed with the new configuration?)
	// _FormItemEditor.resize()

	// Update select input for Select2 plugin
	setupSelect2($list.find("select"));

	// Refresh Sortable to update the added item with Sortable features
	$list.sortable("refresh");

	// Run animation 50ms after previous style declaration (see above) otherwise animation doesn't get triggered
	setTimeout(function() {
		new_repeater_item.style.maxHeight = new_repeater_item.scrollHeight + "px";
	}, 50);
}

function deleteRepeter(event) {
	// Stop default behaviour
	event.preventDefault();

	let record_id = $(this).data("id");
	let targetId = `#repeater_${record_id}`
	let target = $(targetId).get(0);
	// As max-height isn't set you need to set it manually before changing it,
	// otherwise the animation doesn't get triggered
	target.style.maxHeight = target.scrollHeight + "px";
	// Change max-height after 50ms to trigger css animation
	setTimeout(function() {
		target.style.maxHeight = 0 + "px";
	}, 50);

	$.ajax({
		url: $(this).attr("href"),
		data: { id: record_id, target_id: targetId, isAjax: true },
		method: "DELETE"
	}).done(data => {
		// Make sure the animation completes before removing the item (it should last 600ms + 50ms)
		setTimeout(function() {
			$(data.target_id).remove();
		}, 700);
	});
}
