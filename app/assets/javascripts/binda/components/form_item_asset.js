///- - - - - - - - - - - - - - - - - - - -
/// FORM ITEM ASSET
///- - - - - - - - - - - - - - - - - - - -

class FormItemAsset
{
	constructor()
	{
		this.target = '.form-item--asset--uploader'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		$('.fileupload').each(function () {
			$(this).fileupload({
				dropZone: $(this),
				dataType: 'json',
				done: function (e, data) {
					$.each(data.result.files, function (index, file) {
						$('<p/>').text(file.name).appendTo('#files');
					});
				},
				progressall: function (e, data) {
					var progress = parseInt(data.loaded / data.total * 100, 10);
					$('#progress .progress-bar').css(
						'width',
						progress + '%'
					);
				}
			}).prop('disabled', !$.support.fileInput)
				.parent().addClass($.support.fileInput ? undefined : 'disabled');
		});
	}
}

export var _FormItemAsset = new FormItemAsset()