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
/******/ 	return __webpack_require__(__webpack_require__.s = 8);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemEditor; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -

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
				// If the form item edito is closed don't go any further
				if ($(this).height() === 0) return;
				// otherwise update the max-height which is needed for the CSS transition
				// NOTE you need to remove the max-height (inside 'style' attribute) to get the real height
				$(this).css("max-height", $(this).removeAttr('style').height());
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
/* harmony export (immutable) */ __webpack_exports__["a"] = custom_fileupload;
function custom_fileupload(target) {

	var $this = $(target);

	// SETTINGS
	// 
	$this.fileupload({
		url: $this.data('url'), // This should return json, not a proper page
		dropZone: $this,
		dataType: 'json',
		autoUpload: true,
		acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
	});

	// ADD EVENT
	// 
	$this.on('fileuploadadd', function (e, data) {
		data.context = $this.find('.details');
		$.each(data.files, function (index, file) {
			$('.fileupload--filename').text(file.name);
		});
		$('.fileupload--details').removeClass('fileupload--details--hidden');
	});

	// PROCESS ALWAYS EVENT
	// No matter if upload succeded or not, this event gets triggered
	// 
	$this.on('fileuploadprocessalways', function (e, data) {
		// var index = data.index,
		// 	file = data.files[index],
		// 	node = $(data.context.children()[index])
		// if (file.error) {
		// 	node
		// 		.append('<br>')
		// 		.append($('<span class="text-danger"/>').text(file.error))
		// }
		// if (index + 1 === data.files.length) {
		// 	data.context.find('button')
		// 		.text('Upload')
		// 		.prop('disabled', !!data.files.error)
		// }
	});

	// DONE EVENT
	// 
	$this.on('fileuploaddone', function (e, data) {
		$.each(data.result.files, function (index, file) {
			if (file.url) {
				setTimeout(function () {
					// remove context
					data.context.remove();
					// append/replace image
					$this.find('.form-item--image--image').attr('src', file.url).attr('alt', file.name);
					$this.find('.fileupload--remove-image-btn').removeClass('invisible');
				}, 500); // this 500ms of timeout is based on a .2s CSS transition. See fileupload stylesheets
				setTimeout(function () {
					$('.fileupload--details').addClass('fileupload--details--hidden');
				}, 300);
			} else if (file.error) {
				var error = $('<span class="text-danger"/>').text(file.error);
				$(data.context.children()[index]).append('<br>').append(error);
			}
		});
	});

	// FAIL EVENT
	// 
	$this.on('fileuploadfail', function (e, data) {
		console.error(data);
		console.error(data.files[data.index].error);
		$('.fileupload--details').addClass('fileupload--details--hidden');
		alert('Uplaod failed');
	});

	// what is this doing?
	// not sure... see --> http://blueimp.github.io/jQuery-File-Upload/index.html
	$this.prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
}

/***/ }),
/* 2 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
///- - - - - - - - - - - - - - - - - - - -
/// FIELD GROUP EDITOR
///- - - - - - - - - - - - - - - - - - - -

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
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(0);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItem; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -



var FormItem = function () {
	function FormItem() {
		_classCallCheck(this, FormItem);

		this.target = '.form-item';
	}

	_createClass(FormItem, [{
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
			$(document).on('click', this.target + '--add-new', addNewItem);

			$(document).on('click', '.form-item--remove-item-with-js', function (event) {
				// Stop default behaviour
				event.preventDefault();
				$(this).parent(this.target).remove();
			});

			$(document).on('click', '.form-item--open-button, .form-item--close-button', function () {
				var formItemEditor = $(this).parent('.form-item').children('.form-item--editor');

				// Make sure form-item--editor max-height correspond to the actual height
				// this is needed for the CSS transition which is trigger clicking open/close button
				if (!formItemEditor.hasClass('form-item--editor-close')) {
					__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
				}

				// Update classes
				formItemEditor.toggleClass('form-item--editor-close');
				$(this).parent('.form-item').children('.form-item--open-button, .form-item--close-button').toggle();
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
	var id = $(event.target).data('new-child-id');
	var $newChild = $('#' + id);
	// Clone child and remove id and styles from cloned child
	$newChild.clone().insertAfter($newChild);
	$newChild.removeClass('form-item--new').removeAttr('id');
	__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
}

/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(0);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemChoice; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -



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
				var choices = $(this).parent('.form-item--choices');
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

				var choice = $(this).parent('.form-item--choice');
				var destination = $(this).attr('href');

				$.ajax({
					url: destination,
					type: 'DELETE',
					success: function success() {
						choice.remove();
					}
				});
			});
			$(document).on('click', '.form-item--js-delete-choice', function (event) {
				event.preventDefault();
				$(this).parent('.form-item--choice').remove();
			});
		}
	}]);

	return FormItemChoice;
}();

var _FormItemChoice = new FormItemChoice();

/***/ }),
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__fileupload_custom_script__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemImage; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM IMAGE
///- - - - - - - - - - - - - - - - - - - -



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
		value: function setEvents() {
			$('.fileupload').each(function () {
				__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__fileupload_custom_script__["a" /* custom_fileupload */])(this);
			});
		}
	}]);

	return FormItemImage;
}();

var _FormItemImage = new FormItemImage();

/***/ }),
/* 6 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__fileupload_custom_script__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__form_item_editor__ = __webpack_require__(0);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemRepeater; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM
///- - - - - - - - - - - - - - - - - - - -




var FormItemRepeater = function () {
	function FormItemRepeater() {
		_classCallCheck(this, FormItemRepeater);

		this.target = '.form-item--repeater-section';
	}

	_createClass(FormItemRepeater, [{
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
			$(document).on('click', this.target + '--add-new', function (event) {
				addNewItem(this, event);
			});

			$(document).on('click', '.form-item--remove-item-with-js', function (event) {
				// Stop default behaviour
				event.preventDefault();
				$(this).parent(this.target).remove();
				__WEBPACK_IMPORTED_MODULE_1__form_item_editor__["a" /* _FormItemEditor */].resize();
			});

			$(document).on('click', '.form-item--delete-repeater-item', function (event) {
				var _this = this;

				// Stop default behaviour
				event.preventDefault();

				if (!confirm("Are you sure you want do delete it?")) return;

				$.ajax({
					url: $(this).attr('href'),
					data: { id: $(this).data('id'), isAjax: true },
					method: "DELETE"
				}).done(function () {
					$(_this).parents('.form-item--repeater').remove();
					__WEBPACK_IMPORTED_MODULE_1__form_item_editor__["a" /* _FormItemEditor */].resize();
				});
			});
		}
	}]);

	return FormItemRepeater;
}();

var _FormItemRepeater = new FormItemRepeater();

///- - - - - - - - - - - - - - - - - - - -
/// COMPONENT HELPER FUNCTIONS
///- - - - - - - - - - - - - - - - - - - -

function addNewItem(target, event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	var id = $(target).data('id');
	var $list = $('#form-item--repeater-setting-' + id);
	var url = $(target).data('url');
	$.post(url, { repeater_setting_id: id }, function (data) {
		var parts = data.split('<!-- SPLIT -->');
		var newRepeater = parts[1];
		$list.append(newRepeater);
		var editor_id = $list.find('textarea').last('textarea').attr('id');
		tinyMCE.EditorManager.execCommand('mceAddEditor', true, editor_id);
		__WEBPACK_IMPORTED_MODULE_1__form_item_editor__["a" /* _FormItemEditor */].resize();
		__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__fileupload_custom_script__["a" /* custom_fileupload */])($list.find('.fileupload').last('.fileupload').get(0));
	});
}

/***/ }),
/* 7 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony default export */ __webpack_exports__["a"] = function () {
	if ($('.sortable').length > 0) {
		// Initialize sortable item
		$('.sortable').sortable({
			placeholder: "ui-state-highlight",
			update: function update() {
				if ($('.sortable-warning').length > 0) {
					$('.sortable').addClass('sortable--disabled');
					$('.sortable-warning').removeClass('sortable-warning--hidden');
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

	$(document).on('click', '.sortable--toggle', function (event) {
		event.preventDefault();
		var id = '#' + $(this).data('repeater-id');

		if ($(id).hasClass('sortable--disabled')) {
			$(id).sortable('enable');
		} else {
			$(id).sortable('disable');
		}

		$(id).toggleClass('sortable--disabled');
		$(id).toggleClass('sortable--enabled');
		$(this).children('.sortable--toggle-text').toggle();
	});
};

/***/ }),
/* 8 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__components_form_item__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__components_form_item_repeater__ = __webpack_require__(6);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__components_form_item_image__ = __webpack_require__(5);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__ = __webpack_require__(4);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__components_sortable__ = __webpack_require__(7);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__components_field_group_editor__ = __webpack_require__(2);
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
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_5__components_sortable__["a" /* default */])();
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_6__components_field_group_editor__["a" /* default */])();
});

/***/ })
/******/ ]);