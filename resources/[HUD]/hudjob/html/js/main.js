$(function () {
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue") {
			setValue(event.data.key, event.data.value);
		} else if (event.data.action == "toggle") {
			if (event.data.show) {
				$('#ui').show();
			} else {
				$('#ui').hide();
			}
		}
	});
});

function setValue(key, value) {
	$('#' + key + ' span').html(value);
}

//API Shit
function colourGradient(p, rgb_beginning, rgb_end) {
    var w = p * 2 - 1;
    var w1 = (w + 1) / 2.0;
    var w2 = 1 - w1;
    var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2), parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2), parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];
    return rgb;
};