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
/******/ 	return __webpack_require__(__webpack_require__.s = 5);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(6);
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
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return _FormItemAsset; });
var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM ASSET
///- - - - - - - - - - - - - - - - - - - -

var FormItemAsset = function () {
	function FormItemAsset() {
		_classCallCheck(this, FormItemAsset);

		this.target = '.form-item--asset';
	}

	_createClass(FormItemAsset, [{
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
			// here code to setup assets via ajax
			// 
		}
	}]);

	return FormItemAsset;
}();

var _FormItemAsset = new FormItemAsset();

/***/ }),
/* 2 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(6);
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
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__form_item_editor__ = __webpack_require__(6);
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
			$(document).on('click', this.target + '--add-new', addNewItem);

			$(document).on('click', '.form-item--remove-item-with-js', function (event) {
				// Stop default behaviour
				event.preventDefault();
				$(this).parent(this.target).remove();
				__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
			});

			$(document).on('click', '.form-item--delete-repeater-item', function (event) {
				var _this = this;

				// Stop default behaviour
				event.preventDefault();

				$.ajax({
					url: $(this).attr('href'),
					data: { id: $(this).data('id'), isAjax: true },
					method: "DELETE"
				}).done(function () {
					$(_this).parent('li').remove();
					__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
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

function addNewItem(event) {
	// Stop default behaviour
	event.preventDefault();
	// Get the child to clone
	var id = $(event.target).data('id');
	var $list = $('#form-item--repeater-setting-' + id);
	var url = $(event.target).data('url');
	$.post(url, { repeater_setting_id: id }, function (data) {
		var parts = data.split('<!-- SPLIT -->');
		var newRepeater = parts[1];
		$list.append(newRepeater);
		var editor_id = $list.find('textarea').last('textarea').attr('id');
		tinyMCE.EditorManager.execCommand('mceAddEditor', true, editor_id);
		__WEBPACK_IMPORTED_MODULE_0__form_item_editor__["a" /* _FormItemEditor */].resize();
	});
}

/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony default export */ __webpack_exports__["a"] = function () {
	if ($('.sortable').length > 0) {
		// Initialize sortable item
		$('.sortable').sortable({
			placeholder: "ui-state-highlight",
			update: function update() {
				$.post($(this).data('update-url'), $(this).sortable('serialize'));
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
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__components_form_item__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__components_form_item_repeater__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__components_form_item_asset__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__ = __webpack_require__(6);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__components_sortable__ = __webpack_require__(4);
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
	if (__WEBPACK_IMPORTED_MODULE_2__components_form_item_asset__["a" /* _FormItemAsset */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_2__components_form_item_asset__["a" /* _FormItemAsset */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__["a" /* _FormItemChoice */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_3__components_form_item_choice__["a" /* _FormItemChoice */].setEvents();
	}
	if (__WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__["a" /* _FormItemEditor */].isSet()) {
		__WEBPACK_IMPORTED_MODULE_4__components_form_item_editor__["a" /* _FormItemEditor */].setEvents();
	}
	__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_5__components_sortable__["a" /* default */])();
});

/***/ }),
/* 6 */
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

/***/ })
/******/ ]);