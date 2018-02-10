/**
 * FORM ITEM
 */

import { _FormItemEditor } from "./form_item_editor";
import { setupSelect2 } from "./select2";

// Component Global Variables
let newFormItemId = 1;

class FormItem {
	constructor() {}

	isSet() {
		if ($(".form-item--add-new").length > 0) {
			return true;
		} else {
			return false;
		}
	}

	setEvents() {
		$(document).on("click", ".form-item--add-new", addNewItem);
		$(document).on("click", ".form-item--delete-item", deleteItem);
		$(document).on("click", ".form-item--collapse-btn", collapseToggle);
	}
}

export let _FormItem = new FormItem();

///- - - - - - - - - - - - - - - - - - - -
/// COMPONENT HELPER FUNCTIONS
///- - - - - - - - - - - - - - - - - - - -

function addNewItem(event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	let id = $(this).data("id");
	let $list = $("#form-item--field-list-" + id);
	let url = $(this).data("url");
	let data = $list.sortable("serialize");
	let params = $(this).data("params");
	if (params) {
		data = data.concat(`&${params}`);
	}

	$.post(url, data, function(data) {
		// Get repaeter code from Rails
		// Due to the Rails way of creating nested forms it's necessary to
		// create the nested item inside a different new form, then get just
		// the code contained between the two SPLIT comments
		let parts = data.split("<!-- SPLIT -->");
		let newItem = parts[1];
		setupAndAppend(newItem, $list);
	});
}

function setupAndAppend(newItem, $list) {
	// Append the item
	$list.prepend(newItem);
	let collapsable = $list.find(".form-item--collapsable").get(0);

	// Prepare collapsable animation
	collapsable.style.maxHeight = "0px";

	// Setup TinyMCE for the newly created item
	var textarea_editor_id = $list
		.find("textarea")
		.last("textarea")
		.attr("id");
	tinyMCE.EditorManager.execCommand("mceAddEditor", true, textarea_editor_id);

	// Prepare collapsable stack animation
	$(collapsable)
		.find(".form-item--collapsable-stack")
		.each(function() {
			if (!$list.hasClass("sortable--enabled")) {
				// Prepare field stack for collapsable animation
				this.style.maxHeight = collapsable.scrollHeight + "px";
			}
		});

	// Resize the editor (is it needed with the new configuration?)
	// _FormItemEditor.resize()

	// Update select input for Select2 plugin
	setupSelect2($list.find("select"));

	// Refresh Sortable to update the added item with Sortable features
	$list.sortable("refresh");

	// Run animation 500ms after previous style declaration (see above) otherwise animation doesn't get triggered
	setTimeout(function() {
		collapsable.style.maxHeight = collapsable.scrollHeight + "px";
	}, 50);
}

// This function could be improved as it generates an issue with
// input ids which are duplicated after the entire target has been cloned
function DEPRECATEDaddNewItem(event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	// (`this` always refers to the second argument of the $(document).on() method, in this case '.form-item--add-new')
	let id = $(this).data("new-form-item-id");
	let $newChild = $("#" + id);
	// Clone child and remove id and styles from cloned child
	$newChild.clone().insertAfter($newChild);
	// Remove class in order to remove styles, and change id so it's reachable when testing
	$newChild
		.removeClass("form-item--new")
		.attr("id", "new-form-item-" + newFormItemId);

	// // Update all ids to avoid duplication
	$newChild.find("[id]").each(function() {
		let oldId = $(this).attr("id");
		let newId = oldId + "-" + newFormItemId;
		$(this).attr("id", newId);
		let $forId = $newChild.find("[for=" + oldId + "]");
		if ($forId.length > 0) {
			$forId.attr("for", newId);
		}
	});

	// Update height (max-height) of the new element
	let $formItemEditor = $("#new-form-item-" + newFormItemId).find(
		".form-item--editor"
	);

	// override current max-height which is set to 0
	$formItemEditor.get(0).style.maxHeight =
		$formItemEditor.get(0).scrollHeight + "px";

	_FormItemEditor.resize();

	// Increment global id variable `newFormItemId` in case needs to be used again
	newFormItemId++;

	setupSelect2($formItemEditor.find("select"));
}

function close() {
	this.style.maxHeight = "0px";
}

function open() {
	this.style.maxHeight = this.scrollHeight + "px";
}

function collapseToggle(event) {
	// This function is temporarely just set for repeaters.
	// TODO: Need refactoring in order to be available also for generic form items

	// Stop default behaviour
	event.preventDefault();

	let $collapsable = $(this).closest(".form-item--collapsable");

	if ($collapsable.hasClass("form-item--collapsed")) {
		$collapsable.find(".form-item--collapsable-stack").each(open);
		$collapsable.find(".form-item--editor").each(open);
		$collapsable.removeClass("form-item--collapsed");
	} else {
		$collapsable.find(".form-item--collapsable-stack").each(close);
		$collapsable.find(".form-item--editor").each(close);
		$collapsable.addClass("form-item--collapsed");
	}
}

function deleteItem(event) {
	// Stop default behaviour
	event.preventDefault();
	let record_id = $(this).data("id");
	let targetId = `#form-item-${record_id}`
	let target = $(targetId).get(0);
	// As max-height isn't set you need to set it manually before changing it,
	// otherwise the animation doesn't get triggered
	target.style.maxHeight = target.scrollHeight + "px";
	// Change max-height after 50ms to trigger css animation
	setTimeout(function() {
		target.style.maxHeight = "0px";
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
	// TODO add a fallback if request fails
}
