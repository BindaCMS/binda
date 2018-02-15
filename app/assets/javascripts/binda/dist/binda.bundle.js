/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 2);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemCollapsable; });
/* harmony export (immutable) */ __webpack_exports__["b"] = closeCollapsableStacks;
/* harmony export (immutable) */ __webpack_exports__["c"] = openCollapsableStacks;
/* harmony export (immutable) */ __webpack_exports__["d"] = resizeCollapsableStacks;
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__select2__ = __webpack_require__(1);
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM
 */



// Component Global Variables
var newFormItemId = 1;

var FormItemCollapsable = function () {
	function FormItemCollapsable() {
		_classCallCheck(this, FormItemCollapsable);
	}

	_createClass(FormItemCollapsable, [{
		key: "isPresent",
		value: function isPresent() {
			if ($(".form--list").length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: "setEvents",
		value: function setEvents() {
			$(document).on("click", ".form--add-list-item", addNewItem);
			$(document).on("click", ".form--delete-list-item", deleteItem);
			$(document).on("click", ".form-item--collapse-btn", collapseToggle);
			$(window).resize(resizeCollapsableStacks);
			// Make sure all collapsable items are resized already at every page load
			resizeCollapsableStacks();
		}
	}]);

	return FormItemCollapsable;
}();

var _FormItemCollapsable = new FormItemCollapsable();

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
	var id = $(this).data("id");
	var $list = $("#form--list-" + id);
	var url = $(this).data("url");
	var data = $list.sortable("serialize");
	var params = $(this).data("params");
	if (params) {
		data = data.concat("&" + params);
	}
	$.ajax({
		url: url,
		data: data,
		method: "POST"
	}).done(function (data) {
		// Get repaeter code from Rails
		// Due to the Rails way of creating nested forms it's necessary to
		// create the nested item inside a different new form, then get just
		// the code contained between the two SPLIT comments
		var parts = data.split("<!-- SPLIT -->");
		var newItem = parts[1];
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
	var collapsable = $list.find(".form-item--collapsable").get(0);

	// Update select input for Select2 plugin
	Object(__WEBPACK_IMPORTED_MODULE_0__select2__["b" /* setupSelect2 */])($list.find("select"));

	setupTinyMCE($list.find("textarea"));

	// Prepare collapsable animation
	collapsable.style.maxHeight = "0px";

	// Prepare collapsable stack animation
	openCollapsableStacks(collapsable);

	// Refresh Sortable to update the added item with Sortable features
	$list.sortable("refresh");

	// Run animation 500ms after previous style declaration (see above) otherwise animation doesn't get triggered
	setTimeout(function () {
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
function closeCollapsableStacks(obj) {
	$(obj).addClass("form-item--collapsed").find(".form-item--collapsable-stack").each(function () {
		this.style.maxHeight = "0px";
		this.style.pointerEvents = "none";
	});
}

/**
 * Open collapsable stacks
 *
 * It opens all collapsable stacks inside the collapsable item passed as argument
 *
 * @param      {object, string}  target  The target
 */
function openCollapsableStacks(obj) {
	// Don't execute this if sortable is enabled
	if ($(obj).closest(".sortable").hasClass("sortable--enabled")) {
		return;
	}
	$(obj).removeClass("form-item--collapsed").find(".form-item--collapsable-stack").each(function () {
		this.style.maxHeight = this.scrollHeight + "px";
		this.style.pointerEvents = "auto";
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
	var $collapsable = $(this).closest(".form-item--collapsable");
	if ($collapsable.hasClass("form-item--collapsed")) {
		$collapsable.each(function () {
			openCollapsableStacks(this);
		});
	} else {
		$collapsable.each(function () {
			closeCollapsableStacks(this);
		});
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
	var record_id = $(this).data("id");
	var targetId = "#form--list-item-" + record_id;
	var target = $(targetId).get(0);
	// As max-height isn't set you need to set it manually before changing it,
	// otherwise the animation doesn't get triggered
	target.style.maxHeight = target.scrollHeight + "px";
	// Change max-height after 50ms to trigger css animation
	setTimeout(function () {
		target.style.maxHeight = "0px";
		target.style.pointerEvents = "none";
	}, 50);
	$.ajax({
		url: $(this).attr("href"),
		data: { id: record_id, target_id: targetId, isAjax: true },
		method: "DELETE"
	}).done(function (data) {
		// Make sure the animation completes before removing the item (it should last 600ms + 50ms)
		setTimeout(function () {
			$(data.target_id).remove();
		}, 700);
	});
	// TODO add a fallback if request fails
}

/**
 * Resize all collapsable item
 *
 * If a target is passed as a argument the function will resize only that target and its children.
 *
 * @param      {object, string}  target  The target.
 */
function resizeCollapsableStacks(target) {
	target = _.isUndefined(target) ? ".form-item--collapsable-stack" : target;
	// target CANNOT BE a jquery object because it leads to the following error
	// TypeError: undefined is not an object (evaluating 't.ownerDocument.defaultView')
	$(target).each(function () {
		// If the collapsable item is closed don't go any further
		if ($(this).height() === 0 || $(this).closest(".form-item--collapsable").hasClass("form-item--collapsed")) {
			this.style.maxHeight = "0px";
			this.style.pointerEvents = "none";
		} else {
			// otherwise update the max-height which is needed for the CSS transition
			// NOTE you need to remove the max-height (inside 'style' attribute) to get the real height
			this.style.height = "auto";
			this.style.maxHeight = this.scrollHeight + "px";
			this.style.pointerEvents = "auto";
		}
	});
}

/**
 * Setup TinyMCE
 *
 * @param      {jQuery object}  $textareas  The textareas
 */
function setupTinyMCE($textareas) {
	$textareas.each(function () {
		// tinyMCE.createEditor(this.getAttribute('id'));
		tinyMCE.once('mceAddEditor', function (event) {
			console.log({ event: event });
			resizeCollapsableStacks();
		});
		tinyMCE.EditorManager.execCommand("mceAddEditor", true, this.getAttribute('id'));
	});
}

/***/ }),
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (immutable) */ __webpack_exports__["b"] = setupSelect2;
/**
 * OPTIONAL (SELECT2 PLUGIN)
 */

/* harmony default export */ __webpack_exports__["a"] = (function () {
	setupSelect2(".select2-item");
});

function setupSelect2(target) {
	$(target).each(function () {
		var placeholder = $(this).attr("placeholder");
		if (typeof placeholder == "undefined") {
			placeholder = "Select a option";
		}

		var allowClear = false;
		if ($(this).hasClass("select2-item-include-blank")) {
			allowClear = true;
		}

		$(this).select2({
			minimumResultsForSearch: 32, // 31 are max number of day in a month, which you don't want to be searchable
			placeholder: placeholder,
			allowClear: allowClear
		});
	});
}

/***/ }),
/* 2 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__components_form_item_collapsable__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__components_form_item_image__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__components_field_setting_choices__ = __webpack_require__(4);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__components_fileupload__ = __webpack_require__(5);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__components_login_shader__ = __webpack_require__(6);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__components_login_form__ = __webpack_require__(7);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__components_sortable__ = __webpack_require__(8);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__components_field_group_editor__ = __webpack_require__(9);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__components_bootstrap__ = __webpack_require__(10);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__components_select2__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__components_radio_toggle__ = __webpack_require__(11);
///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -













$(document).ready(function () {
	if (__WEBPACK_IMPORTED_MODULE_0__components_form_item_collapsable__["a" /* _FormItemCollapsable */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_0__components_form_item_collapsable__["a" /* _FormItemCollapsable */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_1__components_form_item_image__["a" /* _FormItemImage */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_1__components_form_item_image__["a" /* _FormItemImage */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_2__components_field_setting_choices__["a" /* _FieldSettingChoices */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_2__components_field_setting_choices__["a" /* _FieldSettingChoices */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_3__components_fileupload__["a" /* _FileUpload */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_3__components_fileupload__["a" /* _FileUpload */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_5__components_login_form__["a" /* _LoginForm */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_5__components_login_form__["a" /* _LoginForm */].init();
	}
	if (__WEBPACK_IMPORTED_MODULE_4__components_login_shader__["a" /* _Shader */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_4__components_login_shader__["a" /* _Shader */].setup();
		__WEBPACK_IMPORTED_MODULE_4__components_login_shader__["a" /* _Shader */].start();
	}
	Object(__WEBPACK_IMPORTED_MODULE_10__components_radio_toggle__["a" /* default */])();
	Object(__WEBPACK_IMPORTED_MODULE_6__components_sortable__["a" /* default */])();
	Object(__WEBPACK_IMPORTED_MODULE_7__components_field_group_editor__["a" /* default */])();
	Object(__WEBPACK_IMPORTED_MODULE_8__components_bootstrap__["a" /* default */])();
	Object(__WEBPACK_IMPORTED_MODULE_9__components_select2__["a" /* default */])();
});

// handle event
window.addEventListener("optimizedResize", function () {
	if (__WEBPACK_IMPORTED_MODULE_4__components_login_shader__["a" /* _Shader */].isPresent()) {
		__WEBPACK_IMPORTED_MODULE_4__components_login_shader__["a" /* _Shader */].resize();
	}
});

/***/ }),
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemImage; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM IMAGE
 */

var FormItemImage = function () {
	function FormItemImage() {
		_classCallCheck(this, FormItemImage);

		this.target = ".form-item--image--uploader";
	}

	_createClass(FormItemImage, [{
		key: "isPresent",
		value: function isPresent() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: "setEvents",
		value: function setEvents() {}
	}]);

	return FormItemImage;
}();

var _FormItemImage = new FormItemImage();

/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FieldSettingChoices; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__ = __webpack_require__(0);
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM CHOICE
 */



var FieldSettingChoices = function () {
	function FieldSettingChoices() {
		_classCallCheck(this, FieldSettingChoices);

		this.target = ".field-setting-choices--choice";
	}

	_createClass(FieldSettingChoices, [{
		key: "isPresent",
		value: function isPresent() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: "setEvents",
		value: function setEvents() {
			$(document).on("click", ".field-setting-choices--add-choice", addChoice);

			$(document).on("click", ".field-setting-choices--delete-choice", deleteChoice);

			$(document).on("click", ".field-setting-choices--js-delete-choice", function (event) {
				event.preventDefault();
				$(this).closest(".field-setting-choices--choice").remove();
				// Update form item editor size
				Object(__WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__["d" /* resizeCollapsableStacks */])();
			});
		}
	}]);

	return FieldSettingChoices;
}();

var _FieldSettingChoices = new FieldSettingChoices();

/**
 * HELPER FUNCTIONS
 */

function addChoice(event) {
	event.preventDefault();
	// Clone the new choice field
	var choices_id = $(this).data("choices-id");
	var choices = $("#" + choices_id);
	var newchoice = choices.find(".field-setting-choices--new-choice");
	var clone = newchoice.clone().removeClass("field-setting-choices--new-choice").toggle();
	clone.find(".field-setting-choices--toggle-choice").toggle();
	// Append the clone right after
	choices.prepend(clone);
	// Update form item editor size
	Object(__WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__["d" /* resizeCollapsableStacks */])();
}

function deleteChoice(event) {
	event.preventDefault();

	var choice = $(this).closest(".field-setting-choices--choice");
	var destination = $(this).attr("href");
	var self = this;

	$.ajax({
		url: destination,
		type: "DELETE"
	}).done(function () {
		choice.remove();
		// Update form item editor size
		Object(__WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__["d" /* resizeCollapsableStacks */])();
	}).fail(function (data) {
		alert(data.responseJSON.errors);
	});
}

/***/ }),
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FileUpload; });
var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FILE UPLOAD
 *
 * see https://tympanus.net/codrops/2015/09/15/styling-customizing-file-inputs-smart-way/
 *
 */

var FileUpload = function () {
	function FileUpload() {
		_classCallCheck(this, FileUpload);

		this.target = ".fileupload";
	}

	_createClass(FileUpload, [{
		key: "isPresent",
		value: function isPresent() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: "setEvents",
		value: function setEvents() {
			var self = this;

			$(document).on("click", ".fileupload--remove-image-btn", remove_preview);

			$(document).on("change", this.target + " input.file", handle_file);
		}
	}]);

	return FileUpload;
}();

var _FileUpload = new FileUpload();

/**
 * HELPER FUNCTIONS
 */

// Reference --> http://blog.teamtreehouse.com/uploading-files-ajax
function handle_file(event) {
	var id = event.target.getAttribute("data-id");
	var $parent = $("#fileupload-" + id);

	// Get the selected file from the input
	// This script doesn't consider multiple files upload
	var file = event.target.files[0];

	// Don't go any further if no file has been selected
	if (typeof file == "undefined") {
		return;
	}

	// Create a new FormData object which will be sent to the server
	var formData = new FormData();

	// Get data from the input element
	$parent.find("input").each(function () {
		if (this.isSameNode(event.target)) {
			// Add the file to the request
			formData.append(this.getAttribute("name"), file, file.name);
		} else {
			// Add secondary values to the request
			formData.append(this.getAttribute("name"), this.getAttribute("value"));
		}
	});

	// If it's inside a repeater add repeater parameters
	var $parent_repeater = $parent.closest(".form-item--repeater-fields");
	if ($parent.closest(".form-item--repeater-fields").length > 0) {
		gatherData($parent_repeater, formData);
	}

	// Is this needed? Apparently it works without it. Is it a security issue?
	// let token = document.querySelector('meta[name="csrf-token"]').content
	// formData.append('authenticity_token', token)

	// Display loader
	$(".popup-warning--message").text($parent.data("message"));
	$(".popup-warning").removeClass("popup-warning--hidden");

	// Once form data are gathered make the request
	makeRequest(event, formData);
}

function gatherData($parent_repeater, formData) {
	$parent_repeater.children(".form-group").find("input").each(function () {
		formData.append(this.getAttribute("name"), this.getAttribute("value"));
	});
}

function makeRequest(event, formData) {
	var id = event.target.getAttribute("data-id");
	var $parent = $("#fileupload-" + id);
	// Make request
	$.ajax({
		url: event.target.getAttribute("data-url"),
		type: "PATCH",
		processData: false, // needed to pass formData with the current format
		contentType: false, // needed to pass formData with the current format
		data: formData
	}).done(function (data) {
		updateFileuploadField(data, id);
	}).fail(function (dataFail) {
		// Hide loaded
		$(".popup-warning").addClass("popup-warning--hidden");
		alert($parent.data("error"));
	});
}

function updateFileuploadField(data, id) {
	var $parent = $("#fileupload-" + id);

	if (data.type == "image") {
		setup_image_preview(data, id);
	} else if (data.type == "video") {
		setup_video_preview(data, id);
	} else {
		alert("Something went wrong. No preview has been received.");
	}

	// Hide loaded
	$(".popup-warning").addClass("popup-warning--hidden");

	// Display details and buttons
	$parent.find(".fileupload--details").removeClass("fileupload--details--hidden");
	$parent.find(".fileupload--remove-image-btn").removeClass("fileupload--remove-image-btn--hidden");
}

function reset_file(input) {
	input.value = "";

	if (!/safari/i.test(navigator.userAgent)) {
		input.type = "";
		input.type = "file";
	}
}

function remove_preview(event) {
	var id = event.target.getAttribute("data-id");
	var $parent = $("#fileupload-" + id);

	// Reset previews (either image or video)
	$parent.find(".fileupload--preview").css("background-image", "").removeClass("fileupload--preview--uploaded");
	$parent.find("video source").removeAttr("src");

	// Clear input field
	reset_file($parent.find("input[type=file]").get(0));

	// Reset buttons to initial state
	$parent.find(".fileupload--remove-image-btn").addClass("fileupload--remove-image-btn--hidden");
	$parent.find(".fileupload--details").addClass("fileupload--details--hidden");
}

function setup_image_preview(data, id) {
	var $parent = $("#fileupload-" + id);
	var $preview = $("#fileupload-" + id + " .fileupload--preview");

	// Update thumbnail
	$preview.css("background-image", "url(" + data.thumbnailUrl + ")");

	// Remove and add class to trigger css animation
	var uploadedClass = "fileupload--preview--uploaded";
	$preview.removeClass(uploadedClass).addClass(uploadedClass);

	// Update details
	$parent.find(".fileupload--width").text(data.width);
	$parent.find(".fileupload--height").text(data.height);
	$parent.find(".fileupload--filesize").text(data.size);
	$parent.find(".fileupload--filename").text(data.name);
}

function setup_video_preview(data, id) {
	var $parent = $("#fileupload-" + id);
	var $preview = $("#fileupload-" + id + " .fileupload--preview");

	$preview.removeClass("fileupload--preview--uploaded").find("video").attr("id", "video-" + id).find("source").attr("src", data.url).attr("type", "video/" + data.ext);

	// If video source isn't blank load it (consider that a video tag is always present)
	if (_typeof($preview.find("video source").attr("src")) != undefined) {
		$preview.find("video").get(0).load();
	}

	// Remove and add class to trigger css animation
	var uploadedClass = "fileupload--preview--uploaded";
	$preview.removeClass(uploadedClass).addClass(uploadedClass);

	// Update details
	$parent.find(".fileupload--filesize").text(data.size);
	$parent.find(".fileupload--filename").text(data.name);
	$parent.find(".fileupload--videolink a").attr("href", data.url);
}

/***/ }),
/* 6 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _Shader; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var Shader = function () {
  function Shader() {
    _classCallCheck(this, Shader);

    this.uniforms = {
      uTime: { type: "1f", value: 0.0 },
      uCurrentTime: { type: "1f", value: Math.sin(Date.now()) + 0.5 },
      uMouse: {
        type: "2f",
        value: [window.innerWidth, window.innerHeight]
      },
      uWindowSize: {
        type: "2f",
        value: [window.innerWidth, window.innerHeight]
      }
    };
  }

  _createClass(Shader, [{
    key: "isPresent",
    value: function isPresent() {
      if ($("#background-shader").length > 0) {
        return true;
      } else {
        return false;
      }
    }

    // SETUP SHADER

  }, {
    key: "setup",
    value: function setup() {
      // Create a container object called the `stage`
      this.stage = new PIXI.Container();

      // Create 'renderer'
      this.renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight);

      // //Add the canvas to the HTML document

      document.getElementById("background-shader").appendChild(this.renderer.view);

      this.renderer.backgroundColor = 0xff00ff;

      // canvas full window
      this.renderer.view.style.position = "fixed";
      this.renderer.view.style.display = "block";

      var fragmentShader = document.getElementById("fragmentShader").innerHTML;

      this.customShader = new PIXI.AbstractFilter(null, fragmentShader, this.uniforms);
      this.drawRectagle();
    }

    // DRAW RECTANGLE

  }, {
    key: "drawRectagle",
    value: function drawRectagle() {
      this.rectangle = new PIXI.Graphics();

      // Set the default background color wo if browser doesn't support the filter we still see the primary color
      var colorWithHash = "#FF00FF";
      var colorWith0x = "0x" + colorWithHash.slice(1, 7);
      this.rectangle.beginFill(colorWith0x);

      // Create the background rectanlge
      this.rectangle.drawRect(0, 0, window.innerWidth, window.innerHeight);
      this.rectangle.endFill();

      // Setup the filter (shader)
      this.rectangle.filters = [this.customShader];

      // Add background to stage
      this.stage.addChild(this.rectangle);
    }

    // START ANIMATION

  }, {
    key: "start",
    value: function start() {
      animate();
    }

    // MOUSE UPDATE

  }, {
    key: "mouseUpdate",
    value: function mouseUpdate(event) {
      // If uniforms haven't been set yet don't do anything and exit
      if (typeof this.uniforms === "undefined") return;

      // udpate mouse coordinates for the shader
      this.customShader.uniforms.uMouse = [event.pageX, event.pageY];
    }

    // RESIZE

  }, {
    key: "resize",
    value: function resize() {
      // let scale = scaleToWindow( this.renderer.view )
      var prevWidth = this.renderer.view.style.width;
      var prevHeight = this.renderer.view.style.height;
      this.renderer.view.style.width = window.innerWidth + "px";
      this.renderer.view.style.height = window.innerHeight + "px";
      this.customShader.uniforms.uWindowSize = [window.innerWidth, window.innerHeight];

      // Plese check this out ↴↴↴
      // this.rectangle.scale.x = window.innerWidth / prevWidth
      // this.rectangle.scale.y = window.innerHeight / prevHeight
    }
  }]);

  return Shader;
}();

var _Shader = new Shader();

// ANIMATE
// -------
function animate() {
  // start the timer for the next animation loop
  requestAnimationFrame(animate);
  _Shader.customShader.uniforms.uTime += 0.01;
  // this is the main render call that makes pixi draw your container and its children.
  _Shader.renderer.render(_Shader.stage);
}

// CONVERT HEX TO RGB COLORS
// -------------------------
function hexToShaderRgb(hex) {
  // Precision of the float number
  var precision = 100;
  // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
  var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
  hex = hex.replace(shorthandRegex, function (m, r, g, b) {
    return r + r + g + g + b + b;
  });

  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  if (result) {
    return {
      // Get a number between 0.00 and 1.00
      r: Math.round(parseInt(result[1], 16) * precision / 255) / precision,
      g: Math.round(parseInt(result[2], 16) * precision / 255) / precision,
      b: Math.round(parseInt(result[3], 16) * precision / 255) / precision
    };
  } else {
    return null;
  }
}

// REQUEST ANIMATION POLYFILL
// --------------------------
// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
// requestAnimationFrame polyfill by Erik Möller. fixes from Paul Irish and Tino Zijdel
// MIT license
(function () {
  var lastTime = 0;
  var vendors = ["ms", "moz", "webkit", "o"];
  for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"];
    window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] || window[vendors[x] + "CancelRequestAnimationFrame"];
  }

  if (!window.requestAnimationFrame) window.requestAnimationFrame = function (callback, element) {
    var currTime = new Date().getTime();
    var timeToCall = Math.max(0, 16 - (currTime - lastTime));
    var id = window.setTimeout(function () {
      callback(currTime + timeToCall);
    }, timeToCall);
    lastTime = currTime + timeToCall;
    return id;
  };

  if (!window.cancelAnimationFrame) window.cancelAnimationFrame = function (id) {
    clearTimeout(id);
  };
})();

// Mozilla MDN optimized resize
// https://developer.mozilla.org/en-US/docs/Web/Events/resize
(function () {
  var throttle = function throttle(type, name, obj) {
    obj = obj || window;
    var running = false;
    var func = function func() {
      if (running) {
        return;
      }
      running = true;
      requestAnimationFrame(function () {
        obj.dispatchEvent(new CustomEvent(name));
        running = false;
      });
    };
    obj.addEventListener(type, func);
  };

  /* init - you can init any event */
  throttle("resize", "optimizedResize");
})();

/***/ }),
/* 7 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _LoginForm; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * LOGIN FORM
 *
 * https://tympanus.net/Development/MinimalForm/
 * https://github.com/codrops/MinimalForm/blob/master/js/stepsForm.js
 */

var LoginForm = function () {
	function LoginForm() {
		_classCallCheck(this, LoginForm);

		this.current = 0;
		this.isFilled = false;
	}

	_createClass(LoginForm, [{
		key: "isPresent",
		value: function isPresent() {
			if ($(".login--form").length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: "init",
		value: function init() {
			this.$form = $(".login--form");
			this.$questions = $("ol.login--questions > li");
			this.questionsCount = this.$questions.length;
			this.$nextButton = $("button.login--next");

			// Mark the first question as the current one
			this.$questions.first().addClass("login--current");

			//disable form autocomplete
			this.$form.attr("autocomplete", "off");
			this.setEvents();
		}
	}, {
		key: "setEvents",
		value: function setEvents() {
			var _this = this;

			var self = this;

			// first input
			var firstInput = this.$questions.get(this.current).querySelector("input, textarea, select");

			// focus
			var onFocusStart = function onFocusStart() {
				firstInput.removeEventListener("focus", onFocusStart);
				self.$nextButton.addClass("login--show");
			};
			// show the next question control first time the input gets focused
			firstInput.addEventListener("focus", onFocusStart);

			// show next question
			this.$nextButton.on("click", function (event) {
				event.preventDefault();
				_this._nextQuestion();
			});

			// pressing enter will jump to next question
			this.$form.on("keydown", function (event) {
				var keyCode = event.keyCode || event.which;
				// enter
				if (keyCode === 13) {
					event.preventDefault();
					_this._nextQuestion();
				}
			});
		}
	}, {
		key: "_nextQuestion",
		value: function _nextQuestion() {
			// check if form is filled
			if (this.current === this.questionsCount - 1) {
				this.isFilled = true;
			}

			// current question
			var currentQuestion = this.$questions.get(this.current);

			// increment current question iterator
			++this.current;

			if (!this.isFilled) {
				// add class "show-next" to form element (start animations)
				this.$form.addClass("login--show-next");

				// remove class "current" from current question and add it to the next one
				// current question
				var nextQuestion = this.$questions.get(this.current);
				$(currentQuestion).removeClass("login--current");
				$(nextQuestion).addClass("login--current");
			}

			// after animation ends, remove class "show-next" from form element and change current question placeholder
			var self = this;
			var onEndTransition = function onEndTransition() {
				if (self.isFilled) {
					self.$form.submit();
				} else {
					self.$form.removeClass("login--show-next");
					// force the focus on the next input
					nextQuestion.querySelector("input, textarea, select").focus();
				}
			};

			setTimeout(onEndTransition, 400); // Wait for CSS transition to complete
		}
	}]);

	return LoginForm;
}();

var _LoginForm = new LoginForm();

/***/ }),
/* 8 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__ = __webpack_require__(0);
/**
 * SORTABLE
 */



var sortableOptions = {
	stop: function stop(event, ui) {
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
/* harmony default export */ __webpack_exports__["a"] = (function () {
	if ($(".sortable").length > 0) {
		// Initialize sortable item
		$(".sortable").sortable(sortableOptions);

		// Check if sortable item needs handles
		$(".sortable").each(function () {
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
});

/* Setup Sortable Toggle
 *
 * It sets up each toggle button and add the events needed to enable or disable Sortable.
 */
function setupSortableToggle() {
	$(".sortable--toggle").each(function () {
		var id = "#" + $(this).data("sortable-target-id");
		Object(__WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__["b" /* closeCollapsableStacks */])(id);
	});
	// Add event to any sortable toggle button
	$(document).on("click", ".sortable--toggle", toggleSortable);
}

function toggleSortable(event) {
	event.preventDefault();
	var id = "#" + $(this).data("sortable-target-id");

	if ($(id).hasClass("sortable--disabled")) {
		$(id).sortable("enable");
		Object(__WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__["b" /* closeCollapsableStacks */])(id);
	} else {
		$(id).sortable("disable");
		Object(__WEBPACK_IMPORTED_MODULE_0__form_item_collapsable__["c" /* openCollapsableStacks */])(id);
	}

	$(id).toggleClass("sortable--disabled");
	$(id).toggleClass("sortable--enabled");
	$(this).children(".sortable--toggle-text").toggle();
}

function updateSortable() {
	if ($(".popup-warning").length > 0) {
		$(this).addClass("sortable--disabled");
		$(".popup-warning--message").text($(this).data("message"));
		$(".popup-warning").removeClass("popup-warning--hidden");
		$(this).sortable("option", "disabled", true);
	}
	var url = $(this).data("update-url");
	var data = $(this).sortable("serialize");
	// If there is a pagination update accordingly
	data = data.concat("&id=" + $(this).attr("id"));
	$.post(url, data).done(function (doneData) {
		$(doneData.id).sortable("option", "disabled", false);
		$(".popup-warning").addClass("popup-warning--hidden");
		$(doneData.id).removeClass("sortable--disabled");
	}).fail(function (failData) {
		$(".popup-warning").addClass("popup-warning--hidden");
		alert("Error: " + failData.message);
	});
}

/***/ }),
/* 9 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/**
 * FIELD GROUP EDITOR
 */

/* harmony default export */ __webpack_exports__["a"] = (function () {
	$(".field_groups-edit #save").on("click", function (event) {
		var instanceType = $(this).data("instance-type");
		var entriesNumber = $(this).data("entries-number");

		// If the current structure have many entries updating the field group
		// might be a slow operation, therefore it's good practice to inform the user
		if (entriesNumber > 500) {
			alert("You have " + entriesNumber + " " + instanceType + ". This operation might take some time to complete. To avoid unexpected behaviour don't leave or refresh the page");
		}
	});
});

/***/ }),
/* 10 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/**
 * BOOSTRAP SCRIPT
 */

/* harmony default export */ __webpack_exports__["a"] = (function () {
  // See https://v4-alpha.getbootstrap.com/components/tooltips/#example-enable-tooltips-everywhere
  $('[data-toggle="tooltip"]').tooltip();
});

/***/ }),
/* 11 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony default export */ __webpack_exports__["a"] = (function () {
    $('input[name="login"]').click(function () {
        var $radio = $(this);

        // if this was previously checked
        if ($radio.data("waschecked") === true) {
            $radio.prop("checked", false);
            $radio.data("waschecked", false);
        } else $radio.data("waschecked", true);

        // remove was checked from other radios
        $radio.siblings('input[name="login"]').data("waschecked", false);
    });
});

/***/ })
/******/ ]);