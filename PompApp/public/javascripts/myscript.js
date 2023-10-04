document.addEventListener("DOMContentLoaded", function() {
	console.log("document loaded");
	getStatus()

	function getStatus(){
		fetch("/api/getStatus")
		.then( res => {
			return res.json();
		})
		.then( data => {
			console.log(data);
			console.log("Mijn naam is ",data.name);
			console.log("en ik ben ",data.status);
		})
		.catch( err => {
			console.error(error);
		});

	}
});
