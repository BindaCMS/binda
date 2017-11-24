/**
 * CUSTOM FILE UPLOAD
 *
 * @param      {string}  target  The target
 */

export function custom_fileupload ( target ) {

		let $this = $( target )
		
		// SETTINGS
		// 
		$this.fileupload({
			url: $this.data('url'), // This should return json, not a proper page
			dropZone: $this,
			dataType: 'json',
			autoUpload: true,
			acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
		})


		// ADD EVENT
		// 
		$this.on('fileuploadadd', function (e, data) {
			data.context = $this.find('.details')
			$.each(data.files, function (index, file) {
				$('.fileupload--filename').text(file.name)
			})
			$('.fileupload--details').removeClass('fileupload--details--hidden') 
		})


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
		})


		// DONE EVENT
		// 
		$this.on('fileuploaddone', function (e, data) {
			$.each(data.result.files, function (index, file) {
				if (file.url) {
					setTimeout( function() { 
						// remove context
						data.context.remove() 
						// append/replace image
						$this.find('.form-item--image--image').attr('src', file.url).attr('alt', file.name)
						$this.find('.fileupload--remove-image-btn').removeClass('invisible')
					}, 500 )	// this 500ms of timeout is based on a .2s CSS transition. See fileupload stylesheets
					setTimeout( function() { 
						$('.fileupload--details').addClass('fileupload--details--hidden')
					}, 300 )
				} else if (file.error) {
					var error = $('<span class="text-danger"/>').text(file.error)
					$(data.context.children()[index])
						.append('<br>')
						.append(error)
				}
			})
		})


		// FAIL EVENT
		// 
		$this.on('fileuploadfail', function (e, data) {
			console.error(data)
			console.error(data.files[data.index].error)
			$('.fileupload--details').addClass('fileupload--details--hidden')
			alert('Uplaod failed')
		})


		// what is this doing?
		// not sure... see --> http://blueimp.github.io/jQuery-File-Upload/index.html
		$this.prop('disabled', !$.support.fileInput)
				.parent().addClass($.support.fileInput ? undefined : 'disabled')
}