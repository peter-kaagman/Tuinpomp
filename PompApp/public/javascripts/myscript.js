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
    // Settings {{{3
    const schedule = document.querySelector('#scheduleCanvas');
    if (schedule){
      schedule.addEventListener("mouseover", (event) =>{
        console.log(`${event.clientX} : ${event.clientY}`);
      });
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
      // }}} 3
        fetch("/api/getSchedule")
        .then( res => {
          return res.json();
        })
        .then( data => {
          const aantal_circuits = Object.keys(data).length;
          // Hier weten we hoeveel circuits er zijn en kunnen we een canvas maken
          // Eerst maken en dan per circuit toevoegen gaat niet om dat een canvas bij
          // een resize gecleared wordt.
          // Header en grid {{{3
          console.log("Creating canvas");
          //console.log(`Aantal circuit is ${aantal_circuits}`);
          const width = schedule.clientWidth;
          const height = 24+(aantal_circuits*24);
          const leftBorder = 75;
          // Start en einde zijn per dag gegeven in minuten vanaf middennacht/.
          const pix_per_minuut = (width-leftBorder) / (7*24*60*60);
          //console.log(`Pixels per minuut: ${pix_per_minuut}`);
          const dayWidth = Math.round((width-leftBorder) / 7);
          //console.log(`Width ${width}`);
          //console.log(`Border ${leftBorder}`);
          //console.log(`Day ${dayWidth}`);
          const canvas = document.createElement(`canvas`);
          if (canvas.getContext("2d")){
            const ctx = canvas.getContext("2d");
            ctx.canvas.height = height;
            ctx.canvas.width = width;
            ctx.fillStyle = "black";
            ctx.fillRect(leftBorder,0,2,height);//verticale borderline
            ctx.fillRect(width-2,0,2,height);//vertical borderline
            // Horizontal lines
            for (let x = 0; x <= aantal_circuits; x++){
              let y = 24 + (x*24)-2;
              ctx.fillRect(0, y-2, width, 2);
            }
            //ctx.fillRect(0,20,width,2);//horizontale borderline
            for (let day = 0 ; day < 7; day++){
              let x = leftBorder+(day+1)*dayWidth;
              let middag = Math.round(dayWidth/2);
              ctx.fillStyle = "black";
              ctx.fillRect(x,0,2,height); // verticale daglijn
              ctx.fillRect(x-middag,20,1,height-20); // verticale middaglijn
              ctx.fillStyle = "rgb(0,0,200)";
              ctx.font = "15px sans-serif"
              if (dayWidth > 60){
                ctx.fillText(daysLong[day],x-dayWidth+5,15,dayWidth-10 );
              }else{
                ctx.fillText(daysShort[day],x-dayWidth+5,15,dayWidth-10 );
              }
            }// for day
            // Header en grid }}}
            // Rows {{{3
            let row = 0;
            for (const [circuit, schedule_ids] of Object.entries(data)){
              row++;
              //console.log(circuit);
              //console.log(schedule_ids.name);
              //console.log(schedule_ids.color);
              //console.log(schedule_ids.schedules);
              ctx.fillStyle = schedule_ids.color;
              ctx.font = "15px sans-serif"
              ctx.fillText(schedule_ids.name,2,row*24+15,65);
              ctx.strokeStyle = schedule_ids.color;
              for (const [id, vallue] of Object.entries(schedule_ids.schedules)){
                ctx.beginPath();
                let x1 = Math.round(leftBorder + (vallue.day * dayWidth) + (vallue.start * pix_per_minuut));
                let x2 = Math.round(leftBorder + (vallue.day * dayWidth) + (vallue.end * pix_per_minuut));
                let y = 24+(24*row)-12;
                //console.log(` ${x1}:${y} => ${x2}:${y}`)
                ctx.moveTo(x1,y);
                ctx.lineTo(x2,y);
                ctx.stroke();
              }
            } // for [circuit, schedule_ids]
            // Rows }}}
          }// if canvas.getContect 
          schedule.append(canvas);
        }) //thendata
        .catch( err => {
          console.error(err);
        });
    } // if schedule

  }//}}}2


});//}}}1
