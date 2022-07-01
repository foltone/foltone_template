$(function () {
  let height = 25.5;
  window.addEventListener("message", function (event) {
    

    if (event.data.type == "updateStatusHud") {
      $("#varSetHealth")
        .find(".progressBar")
        .attr("style", "width: " + event.data.varSetHealth + "%;");
      $("#varSetArmor")
        .find(".progressBar")
        .attr("style", "width: " + event.data.varSetArmor + "%;");

      widthHeightSplit(
        event.data.varSetHunger,
        $("#varSetHunger").find(".progressBar")
      );
      widthHeightSplit(
        event.data.varSetThirst,
        $("#varSetThirst").find(".progressBar")
      );


      changeColor($(".progress-health"), event.data.varSetHealth, false)
      changeColor($(".progress-armor"), event.data.varSetArmor, false)
      changeColor($(".progress-burger"), event.data.varSetHunger, false)
      changeColor($(".progress-water"), event.data.varSetThirst, false)
      setProgressZentih(event.data.varSetHealth,'.progress-health')
      setProgressZentih(event.data.varSetHunger,'.progress-burger')
      setProgressZentih(event.data.varSetThirst,'.progress-water')
      setProgressZentih(event.data.varSetArmor,'.progress-armor')            

      if (event.data.varSetArmor <= 0) {
        $("#varSetArmor").find(".barIcon").removeClass("danger");
      }

      if (event.data.colorblind === true) {
        $(".progressBar").addClass("colorBlind");
      } else {
        $(".progressBar").removeClass("colorBlind");
      }
    }
  });

  function widthHeightSplit(value, ele) {
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.attr(
      "style",
      "height: " + eleHeight + "px; top: " + leftOverHeight + "px;"
    );
  }

  function changeColor(ele, value, flip) {
    let add = false;
    if (flip) {
      if (value > 85) {
        add = true;
      }
    } else {
      if (value < 25) {
        add = true;
      }
    }

    if (add) {
      // ele.find(".barIcon").addClass("danger")
      ele.find(".progressBar").addClass("dangerGrad");
    } else {
      // ele.find(".barIcon").removeClass("danger")
      ele.find(".progressBar").removeClass("dangerGrad");
    }
  }
});


function setProgressZentih(value, element){
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');
  var percent = value*100/100;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent*99)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  var predkosc = Math.floor(value * 1.8)
  if (predkosc == 81 || predkosc == 131) {
    predkosc = predkosc - 1
  }

  html.text(predkosc);
}