$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }
    display(true)
    window.addEventListener('message', function(event) {
        if (event.data.type === "hud") {
            if (event.data.status == true) {
                display(true)
            }
            else {
                display(false)
            }
        }
        else if (event.data.type === "update") {
            document.getElementById("health").style.height = event.data.health + "%";
            document.getElementById("armor").style.height = event.data.armor + "%";
            document.getElementById("hunger").style.height = event.data.food + "%";
            document.getElementById("thirst").style.height = event.data.water + "%";
        }
    }) 
})
