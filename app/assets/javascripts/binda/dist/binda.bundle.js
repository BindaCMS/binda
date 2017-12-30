/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
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
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
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
/******/ 	return __webpack_require__(__webpack_require__.s = 13);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemEditor; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM EDITOR
 */

var FormItemEditor = function () {
	function FormItemEditor() {
		_classCallCheck(this, FormItemEditor);

		this.target = '.form-item--editor';
	}

	_createClass(FormItemEditor, [{
		key: 'isSet',
		value: function isSet() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {
			var _this = this;

			// run resize to set initial size
			this.resize();
			// run resize on each of these events
			$(window).resize(function () {
				_this.resize();
			});
		}
	}, {
		key: 'resize',
		value: function resize() {
			$(this.target).each(function () {
				// If the form item editor is closed don't go any further
				if ($(this).height() === 0) return;
				// otherwise update the max-height which is needed for the CSS transition
				// NOTE you need to remove the max-height (inside 'style' attribute) to get the real height
				$(this).get(0).style.height = 'auto';
				$(this).get(0).style.maxHeight = $(this).get(0).scrollHeight + "px";
			});
		}
	}]);

	return FormItemEditor;
}();

var _FormItemEditor = new FormItemEditor();

/***/ }),
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (immutable) */ __webpack_exports__["b"] = setupSelect2;
/**
 * OPTIONAL (SELECT2 PLUGIN)
 */

/* harmony default export */ __webpack_exports__["a"] = function () {
	setupSelect2('.select2-item');
};

function setupSelect2(target) {
	$(target).each(function () {
		var placeholder = $(this).attr('placeholder');
		if (typeof placeholder == 'undefined') {
			placeholder = 'Select a option';
		}

		$(this).select2({
			minimumResultsForSearch: 32, // 31 are max number of day in a month, which you don't want to be searchable
			placeholder: placeholder
		});
	});
}

/***/ }),
/* 2 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/**
 * BOOSTRAP SCRIPT
 */

/* harmony default export */ __webpack_exports__["a"] = function () {
  // See https://v4-alpha.getbootstrap.com/components/tooltips/#example-enable-tooltips-everywhere
  $('[data-toggle="tooltip"]').tooltip();
};

/***/ }),
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/**
 * FIELD GROUP EDITOR
 */

/* harmony default export */ __webpack_exports__["a"] = function () {
	$('.field_groups-edit #save').on('click', function (event) {
		var instanceType = $(this).data('instance-type');
		var entriesNumber = $(this).data('entries-number');

		// If the current structure have many entries updating the field group
		// might be a slow operation, therefore it's good practice to inform the user
		if (entriesNumber > 500) {
			alert('You have ' + entriesNumber + ' ' + instanceType + '. This operation might take some time to complete. To avoid unexpected behaviour don\'t leave or refresh the page');
		}
	});
};

/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FileUpload; });
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

		this.target = '.fileupload';
	}

	_createClass(FileUpload, [{
		key: 'isSet',
		value: function isSet() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {
			var self = this;

			$(document).on('click', '.fileupload--remove-image-btn', remove_preview);

			$(document).on('change', this.target + ' input.file', handle_file);
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
	var id = event.target.getAttribute('data-id');
	var $parent = $('#fileupload-' + id);
	var $preview = $('#fileupload-' + id + ' .fileupload--preview');

	// Get the selected file from the input
	// This script doesn't consider multiple files upload
	var file = event.target.files[0];

	// Don't go any further if no file has been selected
	if (typeof file === 'undefined') {
		return;
	}

	// Create a new FormData object which will be sent to the server
	var formData = new FormData();

	// Get data from the input element
	$parent.find('input').each(function () {
		if (this.isSameNode(event.target)) {
			// Add the file to the request
			formData.append(this.getAttribute('name'), file, file.name);
		} else {
			// Add secondary values to the request
			formData.append(this.getAttribute('name'), this.getAttribute('value'));
		}
	});

	// If it's inside a repeater add repeater parameters
	var $parent_repeater = $parent.closest('.form-item--repeater-fields');
	if ($parent.closest('.form-item--repeater-fields').length > 0) {
		$parent_repeater.children('.form-group').find('input').each(function () {
			formData.append(this.getAttribute('name'), this.getAttribute('value'));
		});
	}

	// Is this needed? Apparently it works without it. Is it a security issue?
	// let token = document.querySelector('meta[name="csrf-token"]').content
	// formData.append('authenticity_token', token)

	// Display loader
	$('.popup-warning').removeClass('popup-warning--hidden');

	// Open the connection
	$.ajax({
		url: event.target.getAttribute('data-url'),
		type: 'PATCH',
		processData: false, // needed to pass formData with the current format
		contentType: false, // needed to pass formData with the current format
		data: formData
	}).done(function (data) {
		if (data.type == 'image') {
			setup_image_preview(data, id);
		} else if (data.type == 'video') {
			setup_video_preview(data, id);
		} else {
			alert('Something went wrong. No preview has been received.');
		}

		// Hide loaded
		$('.popup-warning').addClass('popup-warning--hidden');

		// Display details and buttons
		$parent.find('.fileupload--details').removeClass('fileupload--details--hidden');
		$parent.find('.fileupload--remove-image-btn').removeClass('fileupload--remove-image-btn--hidden');
	}).fail(function () {
		// Hide loaded
		$('.popup-warning').addClass('popup-warning--hidden');
		alert('Something went wrong. Upload process failed.');
	});
}

function reset_file(event) {
	var input = event.target;

	input.value = '';

	if (!/safari/i.test(navigator.userAgent)) {
		input.type = '';
		input.type = 'file';
	}
}

function remove_preview(event) {
	var id = event.target.getAttribute('data-id');
	var $parent = $('#fileupload-' + id);

	// Reset previews (either image or video)
	$parent.find('.fileupload--preview').css('background-image', '').removeClass('fileupload--preview--uploaded');
	$parent.find('video source').attr('src', '');

	// Reset buttons to initial state
	$parent.find('.fileupload--remove-image-btn').addClass('fileupload--remove-image-btn--hidden');
	$parent.find('.fileupload--details').addClass('fileupload--details--hidden');
}

function setup_image_preview(data, id) {
	var $parent = $('#fileupload-' + id);
	var $preview = $('#fileupload-' + id + ' .fileupload--preview');

	// Update thumbnail
	$preview.css('background-image', 'url(' + data.thumbnailUrl + ')');

	// Remove and add class to trigger css animation
	var uploadedClass = 'fileupload--preview--uploaded';
	$preview.removeClass(uploadedClass).addClass(uploadedClass);

	// Update details
	$parent.find('.fileupload--width').text(data.width);
	$parent.find('.fileupload--height').text(data.height);
	$parent.find('.fileupload--filesize').text(data.size);
	$parent.find('.fileupload--filename').text(data.name);
}

function setup_video_preview(data, id) {
	var $parent = $('#fileupload-' + id);
	var $preview = $('#fileupload-' + id + ' .fileupload--preview');

	$preview.removeClass('fileupload--preview--uploaded').find('video').attr('id', 'video-' + id).find('source').attr('src', data.url).attr('type', 'video/' + data.ext);

	// If video source isn't blank load it (consider that a video tag is always present)
	if ($preview.find('video source').attr('src').length > 0) {
		$preview.find('video').get(0).load();
	}

	// Remove and add class to trigger css animation
	var uploadedClass = 'fileupload--preview--uploaded';
	$preview.removeClass(uploadedClass).addClass(uploadedClass);

	// Update details
	$parent.find('.fileupload--filesize').text(data.size);
	$parent.find('.fileupload--filename').text(data.name);
}

/***/ }),
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__select2__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItem; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM
 */




// Component Global Variables
var newFormItemId = 1;

var FormItem = function () {
	function FormItem() {
		_classCallCheck(this, FormItem);
	}

	_createClass(FormItem, [{
		key: 'isSet',
		value: function isSet() {
			if ($('.form-item').length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {
			$(document).on('click', '.form-item--add-new', addNewItem);

			$(document).on('click', '.form-item--remove-item-with-js', function (event) {
				// Stop default behaviour
				event.preventDefault();
				$(this).closest('.form-item').remove();
			});

			$(document).on('click', '.form-item--collapse-btn', function (event) {
				// This function is temporarely just set for repeaters.
				// TODO: Need refactoring in order to be available also for generic form items

				// Stop default behaviour
				event.preventDefault();

				var $collapsable = $(this).closest('.form-item--collapsable');

				if ($collapsable.hasClass('form-item--collapsed')) {
					$collapsable.find('.form-item--repeater-fields').each(open);
					$collapsable.removeClass('form-item--collapsed');
				} else {
					$collapsable.find('.form-item--repeater-fields').each(close);
					$collapsable.addClass('form-item--collapsed');
				}
			});

			$(document).on('click', '.form-item--toggle-button', function () {

				var $formItem = $(this).closest('.form-item');
				var $formItemEditor = $formItem.children('.form-item--editor');

				if ($formItemEditor.get(0).style.maxHeight === '') {
					// Update height
					$formItemEditor.get(0).style.maxHeight = $formItemEditor.get(0).scrollHeight + "px";

					// Add class to trigger animation
					$formItem.children('.form-item--toggle-button').removeClass('form-item--toggle-button-closed');
				} else {
					// Zero height
					$formItemEditor.get(0).style.maxHeight = null;

					// Add class to trigger animation
					$formItem.children('.form-item--toggle-button').addClass('form-item--toggle-button-closed');
				}
			});
		}
	}]);

	return FormItem;
}();

var _FormItem = new FormItem();

///- - - - - - - - - - - - - - - - - - - -
/// COMPONENT HELPER FUNCTIONS
///- - - - - - - - - - - - - - - - - - - -

// This function could be improved as it generates an issue with 
// input ids which are duplicated after the entire target has been cloned
function addNewItem(event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone 
	// (`this` always refers to the second argument of the $(document).on() method, in this case '.form-item--add-new')
	var id = $(this).data('new-form-item-id');
	var $newChild = $('#' + id);
	// Clone child and remove id and styles from cloned child
	$newChild.clone().insertAfter($newChild);
	// Remove class in order to remove styles, and change id so it's reachable when testing
	$newChild.removeClass('form-item--new').attr('id', 'new-form-item-' + newFormItemId);

	// // Update all ids to avoid duplication
	$newChild.find('[id]').each(function () {
		var oldId = $(this).attr('id');
		var newId = oldId + '-' + newFormItemId;
		$(this).attr('id', newId);
		var $forId = $newChild.find('[for=' + oldId + ']');
		if ($forId.length > 0) {
			$forId.attr('for', newId);
		}
	});

	// Update height (max-height) of the new element
	var $formItemEditor = $('#new-form-item-' + newFormItemId).find('.form-item--editor');

	// override current max-height which is set to 0
	$formItemEditor.get(0).style.maxHeight = $formItemEditor.get(0).scrollHeight + "px";

	__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();

	// Increment global id variable `newFormItemId` in case needs to be used again
	newFormItemId++;

	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_1__select2__["b" /* setupSelect2 */])($formItemEditor.find('select'));
}

function close() {
	this.style.maxHeight = '0px';
}

function open() {
	this.style.maxHeight = this.scrollHeight + "px";
}

/***/ }),
/* 6 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(0);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemChoice; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM CHOICE
 */



var FormItemChoice = function () {
	function FormItemChoice() {
		_classCallCheck(this, FormItemChoice);

		this.target = '.form-item--choice';
	}

	_createClass(FormItemChoice, [{
		key: 'isSet',
		value: function isSet() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {
			$(document).on('click', '.form-item--add-choice', function (event) {
				event.preventDefault();
				// Clone the new choice field
				var choices = $(this).closest('.form-item--choices');
				var newchoice = choices.find('.form-item--new-choice');
				var clone = newchoice.clone().removeClass('form-item--new-choice').toggle();
				clone.find('.form-item--toggle-choice').toggle();
				// Append the clone right after
				choices.prepend(clone);
				// Update form item editor size
				__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
			});

			$(document).on('click', '.form-item--delete-choice', function (event) {
				event.preventDefault();

				var choice = $(this).closest('.form-item--choice');
				var destination = $(this).attr('href');
				var self = this;

				$.ajax({
					url: destination,
					type: 'DELETE',
					success: function success() {
						choice.remove();
						// Update form item editor size
						__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
					}
				});
			});
			$(document).on('click', '.form-item--js-delete-choice', function (event) {
				event.preventDefault();
				$(this).closest('.form-item--choice').remove();
				// Update form item editor size
				__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
			});
		}
	}]);

	return FormItemChoice;
}();

var _FormItemChoice = new FormItemChoice();

/***/ }),
/* 7 */
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

		this.target = '.form-item--image--uploader';
	}

	_createClass(FormItemImage, [{
		key: 'isSet',
		value: function isSet() {
			if ($(this.target).length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {}
	}]);

	return FormItemImage;
}();

var _FormItemImage = new FormItemImage();

/***/ }),
/* 8 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__select2__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemRepeater; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

/**
 * FORM ITEM REPEATER
 */




var FormItemRepeater = function () {
	function FormItemRepeater() {
		_classCallCheck(this, FormItemRepeater);
	}

	_createClass(FormItemRepeater, [{
		key: 'isSet',
		value: function isSet() {
			if ($('.form-item--repeater-section').length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {
			$(document).on('click', '.form-item--repeater-section--add-new', function (event) {
				addNewItem(this, event);
			});

			$(document).on('click', '.form-item--remove-item-with-js', function (event) {
				// Stop default behaviour
				event.preventDefault();
				$(this).parent('.form-item--repeater-section').remove();
				__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
			});

			$(document).on('click', '.form-item--delete-repeater-item', function (event) {
				// Stop default behaviour
				event.preventDefault();

				// if ( !confirm($(this).data('confirm')) ) return

				var record_id = $(this).data('id');
				var target = $('#repeater_' + record_id).get(0);
				// As max-height isn't set you need to set it manually before changing it, 
				// otherwise the animation doesn't get triggered
				target.style.maxHeight = target.scrollHeight + 'px';
				// Change max-height after 50ms to trigger css animation
				setTimeout(function () {
					target.style.maxHeight = 0 + 'px';
				}, 50);

				$.ajax({
					url: $(this).attr('href'),
					data: { id: record_id, isAjax: true },
					method: "DELETE"
				}).done(function () {
					// Make sure the animation completes before removing the item (it should last 600ms + 50ms)
					setTimeout(function () {
						$(target).remove();
					}, 700);
					// _FormItemEditor.resize()
				});
			});
		}
	}]);

	return FormItemRepeater;
}();

var _FormItemRepeater = new FormItemRepeater();

/**
 * COMPONENT HELPER FUNCTIONS
 *
 * @param      {string}  target  The target
 * @param      {object}  event   The event
 */

function addNewItem(target, event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	var id = $(target).data('id');
	var $list = $('#form-item--repeater-setting-' + id);
	var url = $(target).data('url');
	$.post(url, { repeater_setting_id: id }, function (data) {
		// Get repaeter code from Rails
		// Due to the Rails way of creating nested forms it's necessary to 
		// create the nested item inside a different new form, then get just
		// the code contained between the two SPLIT comments
		var parts = data.split('<!-- SPLIT -->');
		var newRepeater = parts[1];

		// Append the item
		$list.prepend(newRepeater);
		var new_repeater_item = $list.find('.form-item--repeater').get(0);

		// Prepare animation
		new_repeater_item.style.maxHeight = 0;

		// Group fields if sotrable is enabled
		if ($list.hasClass('sortable--enabled')) {
			$(new_repeater_item).find('.form-item--repeater-fields').each(function () {
				this.style.maxHeight = 0 + 'px';
			});
		}

		// Setup TinyMCE for the newly created item
		var textarea_editor_id = $list.find('textarea').last('textarea').attr('id');
		tinyMCE.EditorManager.execCommand('mceAddEditor', true, textarea_editor_id);

		// Resize the editor (is it needed with the new configuration?)
		// _FormItemEditor.resize()

		// Update select input for Select2 plugin
		__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_1__select2__["b" /* setupSelect2 */])($list.find('select'));

		// Refresh Sortable to update the added item with Sortable features
		$list.sortable('refresh');

		// Run animation 50ms after previous style declaration (see above) otherwise animation doesn't get triggered
		setTimeout(function () {
			new_repeater_item.style.maxHeight = new_repeater_item.scrollHeight + 'px';
		}, 50);
	});
}

/***/ }),
/* 9 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _Shader; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var Shader = function () {
    function Shader() {
        _classCallCheck(this, Shader);
    }

    _createClass(Shader, [{
        key: 'isSet',
        value: function isSet() {
            if ($('#background-shader').length > 0) {
                return true;
            } else {
                return false;
            }
        }

        // SETUP SHADER

    }, {
        key: 'setup',
        value: function setup() {

            var Container = PIXI.Container,
                autoDetectRenderer = PIXI.autoDetectRenderer,
                loader = PIXI.loader,
                resources = PIXI.loader.resources,
                Sprite = PIXI.Sprite;

            // Create a container object called the `stage`
            this.stage = new Container();

            // Create 'renderer'
            this.renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight);

            // //Add the canvas to the HTML document

            document.getElementById('background-shader').appendChild(this.renderer.view);

            this.renderer.backgroundColor = 0xFF00FF;

            // canvas full window
            this.renderer.view.style.position = "fixed";
            this.renderer.view.style.display = "block";

            var fragmentShader = document.getElementById("fragmentShader").innerHTML;

            var currentTime = Math.sin(Date.now()) + 0.5;

            this.uniforms = {
                uTime: { type: '1f', value: 0.0 },
                uCurrentTime: { type: '1f', value: currentTime },
                uMouse: { type: '2f', value: [window.innerWidth, window.innerHeight] },
                uWindowSize: { type: '2f', value: [window.innerWidth, window.innerHeight] }
            };

            this.customShader = new PIXI.AbstractFilter(null, fragmentShader, this.uniforms);
            this.drawRectagle();
        }

        // DRAW RECTANGLE

    }, {
        key: 'drawRectagle',
        value: function drawRectagle() {

            this.rectangle = new PIXI.Graphics();

            // Set the default background color wo if browser doesn't support the filter we still see the primary color
            var colorWithHash = '#FF00FF';
            var colorWith0x = '0x' + colorWithHash.slice(1, 7);
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
        key: 'start',
        value: function start() {
            animate();
        }

        // MOUSE UPDATE

    }, {
        key: 'mouseUpdate',
        value: function mouseUpdate(event) {

            // If uniforms haven't been set yet don't do anything and exit
            if (typeof this.uniforms === 'undefined') return;

            // udpate mouse coordinates for the shader
            this.customShader.uniforms.uMouse = [event.pageX, event.pageY];
        }

        // RESIZE

    }, {
        key: 'resize',
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
    return result ? {
        // Get a number between 0.00 and 1.00
        r: Math.round(parseInt(result[1], 16) * precision / 255) / precision,
        g: Math.round(parseInt(result[2], 16) * precision / 255) / precision,
        b: Math.round(parseInt(result[3], 16) * precision / 255) / precision
    } : null;
}

// REQUEST ANIMATION POLYFILL
// --------------------------
// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
// requestAnimationFrame polyfill by Erik Möller. fixes from Paul Irish and Tino Zijdel
// MIT license
(function () {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
        window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] || window[vendors[x] + 'CancelRequestAnimationFrame'];
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
/* 10 */
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
		key: 'isSet',
		value: function isSet() {
			if ($('.login--form').length > 0) {
				return true;
			} else {
				return false;
			}
		}
	}, {
		key: 'setEvents',
		value: function setEvents() {
			this.$form = $('.login--form');
			this.$questions = $('ol.login--questions > li');
			this.questionsCount = this.$questions.length;
			this.$nextButton = $('button.login--next');

			// Mark the first question as the current one
			this.$questions.first().addClass('login--current');

			//disable form autocomplete
			this.$form.attr('autocomplete', 'off');

			var self = this;

			// first input
			var firstInput = this.$questions.get(this.current).querySelector('input, textarea, select');

			// focus
			var onFocusStart = function onFocusStart() {
				firstInput.removeEventListener('focus', onFocusStart);
				self.$nextButton.addClass('login--show');
			};
			// show the next question control first time the input gets focused
			firstInput.addEventListener('focus', onFocusStart);

			// show next question
			this.$nextButton.on('click', function (event) {
				event.preventDefault();
				self._nextQuestion();
			});

			// pressing enter will jump to next question
			this.$form.on('keydown', function (event) {
				var keyCode = event.keyCode || event.which;
				// enter
				if (keyCode === 13) {
					event.preventDefault();
					self._nextQuestion();
				}
			});
		}
	}, {
		key: '_nextQuestion',
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
				this.$form.addClass('login--show-next');

				// remove class "current" from current question and add it to the next one
				// current question
				var nextQuestion = this.$questions.get(this.current);
				$(currentQuestion).removeClass('login--current');
				$(nextQuestion).addClass('login--current');
			}

			// after animation ends, remove class "show-next" from form element and change current question placeholder
			var self = this;
			var onEndTransition = function onEndTransition() {
				if (self.isFilled) {
					self.$form.submit();
				} else {
					self.$form.removeClass('login--show-next');
					// force the focus on the next input
					nextQuestion.querySelector('input, textarea, select').focus();
				}
			};

			setTimeout(onEndTransition, 400); // Wait for CSS transition to complete
		}
	}]);

	return LoginForm;
}();

var _LoginForm = new LoginForm();

/***/ }),
/* 11 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony default export */ __webpack_exports__["a"] = function () {
    $('input[name="login"]').click(function () {
        var $radio = $(this);

        // if this was previously checked
        if ($radio.data('waschecked') === true) {
            $radio.prop('checked', false);
            $radio.data('waschecked', false);
        } else $radio.data('waschecked', true);

        // remove was checked from other radios
        $radio.siblings('input[name="login"]').data('waschecked', false);
    });
};

/***/ }),
/* 12 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/**
 * SORTABLE
 */

/* harmony default export */ __webpack_exports__["a"] = function () {
	if ($('.sortable').length > 0) {
		// Initialize sortable item
		$('.sortable').sortable({
			stop: function stop(event, ui) {
				ui.item.css('z-index', 0);
			},
			placeholder: "ui-state-highlight",
			update: function update() {
				if ($('.popup-warning').length > 0) {
					$('.sortable').addClass('sortable--disabled');
					$('.popup-warning').removeClass('popup-warning--hidden');
					$(this).sortable('option', 'disabled', true);
				}
				var url = $(this).data('update-url');
				var data = $(this).sortable('serialize');
				// If there is a pagination update accordingly
				data = data.concat('&id=' + $(this).attr('id'));
				$.post(url, data);
			}
		});

		// Check if sortable item needs handles
		$('.sortable').each(function () {
			if ($(this).find('.sortable--handle').length > 0) {
				$(this).sortable('option', 'handle', '.sortable--handle');
			} else {
				$(this).addClass('sortable--no-handle');
			}
		});

		$('.sortable--disabled').sortable('disable');
	}

	// If there is a sortable toggle button prepare the sortable items accordingly
	if ($('.sortable--toggle').length > 0) {
		setupSortableToggle();
	}

	// Add event to any sortable toggle button
	// TODO: make this event available to element which aren't standard form repeaters
	$(document).on('click', '.standard-form--repeater .sortable--toggle', function (event) {
		event.preventDefault();
		var id = '#' + $(this).data('repeater-id');

		if ($(id).hasClass('sortable--disabled')) {
			$(id).sortable('enable');
			$(id).find('.form-item--repeater-fields').each(close);
			$(id).find('.form-item--collapsable').addClass('form-item--collapsed');
		} else {
			$(id).sortable('disable');
		}

		$(id).toggleClass('sortable--disabled');
		$(id).toggleClass('sortable--enabled');
		$(this).children('.sortable--toggle-text').toggle();
	});
};

function setupSortableToggle() {
	$('.sortable--toggle').each(function () {
		var id = '#' + $(this).data('repeater-id');
		$(id).find('.form-item--collapsable').addClass('form-item--collapsed');
		$(id).find('.form-item--repeater-fields').each(close);
	});
}

function close() {
	this.style.maxHeight = '0px';
}

function open() {
	this.style.maxHeight = this.scrollHeight + "px";
}

/***/ }),
/* 13 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__components_form_item__ = __webpack_require__(5);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__components_form_item_repeater__ = __webpack_require__(8);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__components_form_item_image__ = __webpack_require__(7);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__ = __webpack_require__(6);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__components_fileupload__ = __webpack_require__(4);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__components_login_shader__ = __webpack_require__(9);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__components_login_form__ = __webpack_require__(10);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__components_sortable__ = __webpack_require__(12);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__components_field_group_editor__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__components_bootstrap__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__components_select2__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12__components_radio_toggle__ = __webpack_require__(11);
///- - - - - - - - - - - - - - - - - - - -
/// INDEX OF BINDA'S SCRIPTS
///- - - - - - - - - - - - - - - - - - - -















$(document).ready(function () {
	if (__WEBPACK_IMPORTED_MODULE_0__components_form_item__["a" /* _FormItem */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_0__components_form_item__["a" /* _FormItem */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_1__components_form_item_repeater__["a" /* _FormItemRepeater */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_1__components_form_item_repeater__["a" /* _FormItemRepeater */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_2__components_form_item_image__["a" /* _FormItemImage */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_2__components_form_item_image__["a" /* _FormItemImage */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__["a" /* _FormItemChoice */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__["a" /* _FormItemChoice */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__["a" /* _FormItemEditor */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__["a" /* _FormItemEditor */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_5__components_fileupload__["a" /* _FileUpload */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_5__components_fileupload__["a" /* _FileUpload */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_7__components_login_form__["a" /* _LoginForm */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_7__components_login_form__["a" /* _LoginForm */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_6__components_login_shader__["a" /* _Shader */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_6__components_login_shader__["a" /* _Shader */].setup();
		__WEBPACK_IMPORTED_MODULE_6__components_login_shader__["a" /* _Shader */].start();
	}
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_12__components_radio_toggle__["a" /* default */])();
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_8__components_sortable__["a" /* default */])();
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_9__components_field_group_editor__["a" /* default */])();
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_10__components_bootstrap__["a" /* default */])();
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_11__components_select2__["a" /* default */])();
});

// handle event
window.addEventListener("optimizedResize", function () {
	if (__WEBPACK_IMPORTED_MODULE_6__components_login_shader__["a" /* _Shader */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_6__components_login_shader__["a" /* _Shader */].resize();
	}
});

/***/ })
/******/ ]);