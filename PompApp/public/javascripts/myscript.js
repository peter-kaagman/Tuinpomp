document.addEventListener("DOMContentLoaded", function() { //{{{1
  console.log("document loaded");
  getStatus();
  getSchedule();

  function getStatus(){//{{{2
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

      // Rows{{{3
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
        });//}}}3
	statusTable.textContent = '';
	statusTable.append(table);
      } // if(statusTable)
  }//}}}2

  function getSchedule(){//{{{2
    console.log("getSchedule()");
    const schedule = document.querySelector('#scheduleCanvas');
    if (schedule){
      console.log("Creating canvas");
      const width = schedule.clientWidth;
      const height = 24;
      const leftBorder = 75;
      const dayWidth = Math.round((width-leftBorder) / 7);
      const daysLong = [
        'Maandag',
        'Dinsdag',
        'Woensdag',
        'Donderdag',
        'Vrijdag',
        'Zaterdag',
        'Zondag'
      ];
      const daysShort = [
        'Maa',
        'Din',
        'Woe',
        'Don',
        'Vri',
        'Zat',
        'Zon'
      ];
      console.log(`Width ${width}`);
      console.log(`Border ${leftBorder}`);
      console.log(`Day ${dayWidth}`);
      const canvasHeader = document.createElement(`canvas`);
      if (canvasHeader.getContext("2d")){
        const ctx = canvasHeader.getContext("2d");
        ctx.canvas.width = width;
        ctx.canvas.height = height;
        //Header canvas {{{3
        ctx.fillStyle = "rgb(200,0,0)";
        ctx.fillRect(leftBorder,0,2,height);//verticale borderline
        ctx.fillRect(width-2,0,2,height);//vertical borderline
        ctx.fillRect(0,20,width,2);//horizontale borderline
        for (let day = 0 ; day < 7; day++){
          let x = leftBorder+(day+1)*dayWidth;
          let middag = Math.round(dayWidth/2);
          ctx.fillStyle = "rgb(0,200,0)";
          ctx.fillRect(x,0,2,height); // verticale daglijn
          ctx.fillRect(x-middag,20,2,height-20); // verticale middaglijn
          ctx.fillStyle = "rgb(0,0,200)";
          ctx.font = "15px sans-serif"
          if (dayWidth > 60){
            ctx.fillText(daysLong[day],x-dayWidth+5,15,dayWidth-10 );
          }else{
            ctx.fillText(daysShort[day],x-dayWidth+5,15,dayWidth-10 );
          }
        }// for day}}}3
        schedule.textContent = '';
        schedule.append(canvasHeader);
        //Row canvas {{{3
        //Fetch the schedules
        fetch("/api/getSchedule")
        .then( res => {
          return res.json();
        })
        .then( data => {
          console.log(data);
          data.forEach(obj => {
            console.log(obj);
          }); // forEach schedule
        })
        .catch( err => {
          console.error(err);
        });//}}}3
      }// if canvas
    }

  }//}}}2


});//}}}1
