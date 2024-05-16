$(function () {
    $("#container").hide();
});

window.addEventListener("message", (event) => {
    function update() {
        const users = event.data.users;
        const usersDiv = document.getElementById("users");
        usersDiv.children[1].innerHTML = users;
        const staff = event.data.staff;
        const staffDiv = document.getElementById("staff");
        staffDiv.children[1].innerHTML = staff;
        const ticketDiv = document.getElementById("ticket");
        const ticket = event.data.ticket;
        ticketDiv.children[1].innerHTML = ticket;
    }

    if (event.data.type === "show") {
        $("#container").show();
        update();
    } else if (event.data.type === "hide") {
        $("#container").hide();
    } else if (event.data.type === "update") {
        update();
    } else if (event.data.type === "updateTicket") {
        const ticketDiv = document.getElementById("ticket");
        const ticket = event.data.ticket;
        ticketDiv.children[1].innerHTML = ticket;
    } else if (event.data.type == "updateElement") {
        if (event.data.element == "spectate") {
            const spectate = document.getElementsByClassName("spectate")[0];
            if (event.data.disable) {
                spectate.style.display = "block";
            } else {
                spectate.style.display = "none";
            }
        } else if (event.data.element == "noclip") {
            const noclip = document.getElementsByClassName("noclip")[0];
            if (event.data.disable) {
                noclip.style.display = "block";
            } else {
                noclip.style.display = "none";
            }
        } else if (event.data.element == "invincibility") {
            const invincibility = document.getElementsByClassName("invincibility")[0];
            if (event.data.disable) {
                invincibility.style.display = "block";
            } else {
                invincibility.style.display = "none";
            }
        } else if (event.data.element == "invisible") {
            const invisible = document.getElementsByClassName("invisible")[0];
            if (event.data.disable) {
                invisible.style.display = "block";
            } else {
                invisible.style.display = "none";
            }
        } else if (event.data.element == "playersNames") {
            const playersNames = document.getElementsByClassName("playersNames")[0];
            if (event.data.disable) {
                playersNames.style.display = "block";
            } else {
                playersNames.style.display = "none";
            }
        } else if (event.data.element == "blips") {
            const blips = document.getElementsByClassName("blips")[0];
            if (event.data.disable) {
                blips.style.display = "block";
            } else {
                blips.style.display = "none";
            }
        }
    } else if (event.data.type == "message") {
        const message = document.getElementById("message");
        message.innerHTML = event.data.message;
        message.style.display = "block";
        setTimeout(() => {
            message.style.display = "none";
        }, 9000);
    }
});
