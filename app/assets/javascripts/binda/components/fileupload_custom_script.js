
export function custom_fileupload ( target ) {

		let $this = $( target )
		$this.fileupload({

			url: $this.data('url'), // This should return json, not a proper page
			dropZone: $this,
			dataType: 'json',
			autoUpload: true,
			acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
			maxFileSize: 999000, // originally 999000
			// Enable image resizing, except for Android and Opera,
			// which actually support image resizing, but fail to
			// send Blob objects via XHR requests:
			disableImageResize: /Android(?!.*Chrome)|Opera/
					.test(window.navigator.userAgent),
			previewMaxWidth: 100,
			previewMaxHeight: 100,
			previewCrop: true

		}).on('fileuploadadd', function (e, data) {

			data.context = $this.find('.details');
			$.each(data.files, function (index, file) {
				$('.fileupload--filename').text(file.name)
			});
			$('.fileupload--details').removeClass('fileupload--details--hidden') 

		}).on('fileuploadprocessalways', function (e, data) {

			var index = data.index,
				file = data.files[index],
				node = $(data.context.children()[index]);
			if (file.error) {
				node
					.append('<br>')
					.append($('<span class="text-danger"/>').text(file.error));
			}
			if (index + 1 === data.files.length) {
				data.context.find('button')
					.text('Upload')
					.prop('disabled', !!data.files.error);
			}

		}).on('fileuploadprogressall', function (e, data) {

			var progress = parseInt(data.loaded / data.total * 100, 10);
			$('.fileupload--details .progress .progress-bar').css(
				'width',
				progress + '%'
			)

		}).on('fileuploaddone', function (e, data) {

			$.each(data.result.files, function (index, file) {
				if (file.url) {
					setTimeout( function() { 
						// remove context
						data.context.remove() 
						// reset progress bar
						$('.fileupload--details .progress .progress-bar').css('width', '0%')
						// append/replace image
						$this.find('.form-item--asset--image').attr('src', file.url).attr('alt', file.name)
						$this.find('.fileupload--remove-image-btn').removeClass('invisible')
					}, 500 )	// this 500ms of timeout is based on a .2s CSS transition. See fileupload stylesheets
					setTimeout( function() { 
						$('.fileupload--details').addClass('fileupload--details--hidden')
					}, 300 )
				} else if (file.error) {
					var error = $('<span class="text-danger"/>').text(file.error);
					$(data.context.children()[index])
						.append('<br>')
						.append(error);
				}
			});

		}).on('fileuploadfail', function (e, data) {

			$('.fileupload--details').addClass('fileupload--details--hidden')

			alert('Uplaod failed')

			// $.each(data.files, function (index) {
				// var error = $('<span class="text-danger"/>').text('File upload failed.');
				// $(data.context.children()[index])
				// 	.append('<br>')
				// 	.append(error);
			// });

		}).prop('disabled', !$.support.fileInput)
				.parent().addClass($.support.fileInput ? undefined : 'disabled');
}