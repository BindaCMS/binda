/**
 * FIELD GROUP EDITOR
 */

export default function() {
	$(".field_groups-edit #save").on("click", function(event) {
		let instanceType = $(this).data("instance-type");
		let entriesNumber = $(this).data("entries-number");

		// If the current structure have many entries updating the field group
		// might be a slow operation, therefore it's good practice to inform the user
		if (entriesNumber > 500) {
			alert(
				`You have ${entriesNumber} ${instanceType}. This operation might take some time to complete. To avoid unexpected behaviour don't leave or refresh the page`
			);
		}
	});
}
