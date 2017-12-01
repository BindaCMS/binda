/**
 * FILE UPLOAD
 * 
 * see https://tympanus.net/codrops/2015/09/15/styling-customizing-file-inputs-smart-way/
 * 
 */

class FileUpload {
	
	constructor(){
		this.target = '.fileupload'
	}

	isSet()
	{
		if ( $( this.target ).length > 0 ) { return true }
		else { return false }
	}

	setEvents()
	{
		let self = this

		$(document).on('click', '.fileupload--remove-image-btn', remove_preview)

		$(document).on('change', `${this.target} input.file`, handle_file)
	}
}

export let _FileUpload = new FileUpload()


/**
 * HELPER FUNCTIONS
 */

// Reference --> http://blog.teamtreehouse.com/uploading-files-ajax
function handle_file(event) 
{
	let id = event.target.getAttribute('data-id')
	let $parent = $('#fileupload-'+id)
	let $preview = $('#fileupload-'+id+' .fileupload--preview')

	// Get the selected file from the input
	// This script doesn't consider multiple files upload
	let file = event.target.files[0]

	// Create a new FormData object which will be sent to the server
	let formData = new FormData()

	// Get data from the input element
	$parent.find('input').each(function()
	{
		if ( this.isSameNode(event.target) )
		{
			// Add the file to the request
			formData.append(this.getAttribute('name'), file, file.name)
		} else {
			// Add secondary values to the request
			formData.append(this.getAttribute('name'), this.getAttribute('value'))
		}
	})

	// Is this needed? Apparently it works without it. Is it a security issue?
	// let token = document.querySelector('meta[name="csrf-token"]').content
	// formData.append('authenticity_token', token)

	// Open the connection
	$.ajax(
	{
		url: event.target.getAttribute('data-url'), 
		type: 'PATCH',
	  processData: false, // needed to pass formData with the current format
	  contentType: false, // needed to pass formData with the current format
		data: formData
	}).done( function(data)
	{
		// Update thumbnail
		$preview.css('background-image', `url(${data.thumbnailUrl})`)
		// Remove and add class to trigger css animation
		let uploadedClass = 'fileupload--preview--uploaded'
		$preview.removeClass(uploadedClass).addClass(uploadedClass)
		// Update details
		$parent.find('.fileupload--width').text(data.width)
		$parent.find('.fileupload--height').text(data.height)
		$parent.find('.fileupload--filename').text(data.name)
		// Display details and buttons
		$parent.find('.fileupload--details').removeClass('fileupload--details--hidden')
		$parent.find('.fileupload--remove-image-btn').removeClass('fileupload--remove-image-btn--hidden')
	})
}

function reset_file(event) 
{
	let input = event.target
	
	input.value = ''

	if(!/safari/i.test(navigator.userAgent)){
	  input.type = ''
	  input.type = 'file'
	}
}

function remove_preview(event) 
{
	let id = event.target.getAttribute('data-id')
	let $parent = $('#fileupload-'+id)

	$parent.find('.fileupload--preview').css('background-image','').removeClass('fileupload--preview--uploaded')
	$parent.find('.fileupload--remove-image-btn').addClass('fileupload--remove-image-btn--hidden')
	$parent.find('.fileupload--details').addClass('fileupload--details--hidden')
}