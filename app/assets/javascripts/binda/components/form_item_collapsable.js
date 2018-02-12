/**
 * FORM ITEM
 */

import { setupSelect2 } from "./select2";

// Component Global Variables
let newFormItemId = 1;

class FormItemCollapsable {
	constructor() {}

	isPresent() {
		if ($(".form--list").length > 0) {
			return true;
		} else {
			return false;
		}
	}

	setEvents() {
		$(document).on("click", ".form--add-list-item", addNewItem);
		$(document).on("click", ".form--delete-list-item", deleteItem);
		$(document).on("click", ".form-item--collapse-btn", collapseToggle);
		$(window).resize(resizeCollapsableStacks);
		// Make sure all collapsable items are resized already at every page load
		resizeCollapsableStacks();
	}
}

export let _FormItemCollapsable = new FormItemCollapsable();

/**
 * COMPONENT HELPER FUNCTIONS
 */

/**
 * Adds a new item.
 *
 * @param      {event}  event   The event
 */
function addNewItem(event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	let id = $(this).data("id");
	let $list = $("#form--list-" + id);
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

/**
 * Setup and append new item
 *
 * @param      {string}  newItem  The new item
 * @param      {object}  $list    The list
 */
function setupAndAppend(newItem, $list) {
	// Append the item
	$list.prepend(newItem);
	let collapsable = $list.find(".form-item--collapsable").get(0);

	// Update select input for Select2 plugin
	setupSelect2($list.find("select"));

	// Setup TinyMCE for the newly created item
	var textarea_editor_id = $list
		.find("textarea")
		.last("textarea")
		.attr("id");
	tinyMCE.EditorManager.execCommand("mceAddEditor", true, textarea_editor_id);

	// Prepare collapsable animation
	collapsable.style.maxHeight = "0px";

	// Prepare collapsable stack animation
	openCollapsableStacks(collapsable);

	// Refresh Sortable to update the added item with Sortable features
	$list.sortable("refresh");

	// Run animation 500ms after previous style declaration (see above) otherwise animation doesn't get triggered
	setTimeout(function() {
		collapsable.style.maxHeight = collapsable.scrollHeight + "px";
	}, 50);
}

/**
 * Close collapsable stacks
 *
 * It closes all collapsable stacks inside the collapsable item passed as argument
 *
 * @param      {object, string}  target  The target
 */
export function closeCollapsableStacks(obj) {
	$(obj)
		.addClass("form-item--collapsed")
		.find(".form-item--collapsable-stack")
		.each(function() {
			this.style.maxHeight = "0px";
		});
}

/**
 * Open collapsable stacks
 *
 * It opens all collapsable stacks inside the collapsable item passed as argument
 *
 * @param      {object, string}  target  The target
 */
export function openCollapsableStacks(obj) {
	// Don't execute this if sortable is enabled
	if (
		$(obj)
			.closest(".sortable")
			.hasClass("sortable--enabled")
	) {
		return;
	}
	$(obj)
		.removeClass("form-item--collapsed")
		.find(".form-item--collapsable-stack")
		.each(function() {
			this.style.maxHeight = this.scrollHeight + "px";
		});
}

/**
 * Toggle a collapsable item
 *
 * Basically it opens it or closes it based on its state
 *
 * @param      {event}  event   The event
 */
function collapseToggle(event) {
	// Stop default behaviour
	event.preventDefault();

	let $collapsable = $(this).closest(".form-item--collapsable");

	if ($collapsable.hasClass("form-item--collapsed")) {
		openCollapsableStacks($collapsable);
	} else {
		closeCollapsableStacks($collapsable);
	}
}

/**
 * Delete collapsable item and hide it
 *
 * @param      {event}  event   The event
 */
function deleteItem(event) {
	// Stop default behaviour
	event.preventDefault();
	let record_id = $(this).data("id");
	let targetId = `#form--list-item-${record_id}`;
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
	}).done(function(data){
		console.log(data)

		// Make sure the animation completes before removing the item (it should last 600ms + 50ms)
		setTimeout(function() {
			console.log(data.target_id)
			$(data.target_id).remove();
		}, 700);
	});
	// TODO add a fallback if request fails
}

/**
 */

/**
 * Resize all collapsable item
 *
 * If a target is passed as a argument the function will resize only that target and its children.
 *
 * @param      {object, string}  target  The target
 */
export function resizeCollapsableStacks(target) {
	target = _.isUndefined(target) ? $(".form-item--collapsable-stack") : target;
	$(target).each(function() {
		// If the collapsable item is closed don't go any further
		if (
			$(this).height() === 0 ||
			$(this)
				.closest(".form-item--collapsable")
				.hasClass("form-item--collapsed")
		) {
			this.style.maxHeight = "0px";
		} else {
			// otherwise update the max-height which is needed for the CSS transition
			// NOTE you need to remove the max-height (inside 'style' attribute) to get the real height
			this.style.height = "auto";
			this.style.maxHeight = this.scrollHeight + "px";
		}
	});
}
