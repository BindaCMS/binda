/**
 * SORTABLE
 */

import { openCollapsableStacks, closeCollapsableStacks } from './form_item_collapsable';

var sortableOptions = {
	stop: function(event, ui) {
		ui.item.css("z-index", 0);
	},
	placeholder: "ui-state-highlight",
	update: updateSortable
};

/* Initialize jQuery Sortable
 * 
 * This function handles several things:
 * - it sets Sortable for each ".sortable" element
 * - it adds handles only if required
 * - it disable itself if it finds ".sortable--disabled" class
 * - it sets up a toggle button and behaviour if required 
 */
export default function() {
	if ($(".sortable").length > 0) {
		// Initialize sortable item
		$(".sortable").sortable(sortableOptions);

		// Check if sortable item needs handles
		$(".sortable").each(function() {
			if ($(this).find(".sortable--handle").length > 0) {
				$(this).sortable("option", "handle", ".sortable--handle");
			} else {
				$(this).addClass("sortable--no-handle");
			}
		});

		$(".sortable--disabled").sortable("disable");
	}

	// If there is a sortable toggle button prepare the sortable items accordingly
	if ($(".sortable--toggle").length > 0) {
		setupSortableToggle();
	}
}

/* Setup Sortable Toggle
 *
 * It sets up each toggle button and add the events needed to enable or disable Sortable.
 */
function setupSortableToggle() {
	$(".sortable--toggle").each(function() {
		let id = "#" + $(this).data("sortable-target-id");
		closeCollapsableStacks(id);
	});
	// Add event to any sortable toggle button
	$(document).on("click", ".sortable--toggle", toggleSortable);
}

function toggleSortable(event) {
	event.preventDefault();
	let id = "#" + $(this).data("sortable-target-id");

	if ($(id).hasClass("sortable--disabled")) {
		$(id).sortable("enable");
		closeCollapsableStacks(id);
	} else {
		$(id).sortable("disable");
		openCollapsableStacks(id);
	}

	$(id).toggleClass("sortable--disabled");
	$(id).toggleClass("sortable--enabled");
	$(this)
		.children(".sortable--toggle-text")
		.toggle();
}

function updateSortable() {
	if ($(".popup-warning").length > 0) {
		$(this).addClass("sortable--disabled");
		$(".popup-warning--message").text($(this).data("message"));
		$(".popup-warning").removeClass("popup-warning--hidden");
		$(this).sortable("option", "disabled", true);
	}
	let url = $(this).data("update-url");
	let data = $(this).sortable("serialize");
	// If there is a pagination update accordingly
	data = data.concat(`&id=${$(this).attr("id")}`);
	$.post(url, data)
		.done(function(doneData) {
			$(doneData.id).sortable("option", "disabled", false);
			$(".popup-warning").addClass("popup-warning--hidden");
			$(doneData.id).removeClass("sortable--disabled");
		})
		.fail(function(failData) {
			$(".popup-warning").addClass("popup-warning--hidden");
			alert("Error: " + failData.message);
		});
}
