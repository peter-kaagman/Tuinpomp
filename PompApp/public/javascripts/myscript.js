document.addEventListener("DOMContentLoaded", function() {
  console.log("document loaded");
  getStatus();
  getSchedule();

  function getStatus(){
    console.log("getStatus()");
    var statusTable = document.querySelector('#statusTable');
    if (statusTable){

      const table = document.createElement(`table`);
      table.style.cssText += "border-collapse: collapse;"
      const aRow = document.createElement(`tr`);
      const aCell = document.createElement(`td`);
      const aHead = document.createElement(`th`);

      // Headers{{{3
      const row = aRow.cloneNode();
      const headerName  = aHead.cloneNode();
      headerName.textContent = 'Naam';
      row.append(headerName);
      const headerKlep = aHead.cloneNode();
      headerKlep.textContent = 'Klep pin';
      row.append(headerKlep);
      const headerStatus = aHead.cloneNode();
      headerStatus.textContent = 'Status';
      row.append(headerStatus);
      table.append(row);//}}}

      fetch("/api/getStatus")
        .then( res => {
          return res.json();
        })
        .then( data => {
          data.forEach(obj =>{
	    const row = aRow.cloneNode();
            row.style.cssText += `border-bottom: 2pt solid ${obj.color};`;
	    //Name
	    const cellName = aCell.cloneNode();
	    cellName.textContent = obj.name;
	    row.append(cellName);
	    //Gpio
	    const cellKlep = aCell.cloneNode();
	    cellKlep.textContent = obj.gpio;
	    row.append(cellKlep);
	    //Status
	    const cellStatus = aCell.cloneNode();
	    cellStatus.textContent = obj.status;
	    row.append(cellStatus);
	    //Append row to table
	    table.append(row);
            //console.log(obj);
          });
       })
        .catch( err => {
          console.error(err);
        });
	statusTable.textContent = '';
	statusTable.append(table);
      } // if(statusTable)
  }

  function getSchedule(){
    console.log("getSchedule()");
    const schedule = document.querySelector('#scheduleCanvas');
    if (schedule){
      console.log("Creating canvas");
      const canvas = document.createElement(`canvas`);
      if (canvas.getContext("2d")){
        const ctx = canvas.getContext("2d");
        ctx.fillStyle = "rgb(200,0,0)";
        ctx.fillRect(10,10,50,50);
        ctx.fillStyle = "rgba(0,0,200,0.5)";
        ctx.fillRect(30,30,50,50);
      }
      schedule.textContent = '';
      schedule.append(canvas);
    }

  }


});
