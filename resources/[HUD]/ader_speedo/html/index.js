$(function () {

  window.addEventListener('message', function (event) {

    if (event.data.isInVehicle) {
      $(".container").addClass('isInVehicle');
      $(".gear").html(Math.round(event.data.gear) + "");
      $(".velo").html(Math.round(event.data.speed) + "");
      $(".percent-fuel").css("width", (event.data.fuel) + "%");
    } else {
      $(".container").removeClass('isInVehicle');
    }
  });
});
