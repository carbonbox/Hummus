for (var col = 0; col < 15; col++) {
    document.write('<div class=grid-col style="left:' + (2 + col * 5) + 'em"></div>');
}

for (var row = 0; row < 40; row++) {
    document.write('<div class=grid-row style="top:' + (2 + row) + 'em"></div>');
}

document.write('<div class=grid-toggle>grid</div>');

window.addEvent('domready', function() {
    document.getElement('.grid-toggle').addEvent('click', togglegrid);
});


function togglegrid() {
    document.getElement('body').toggleClass('grid');
}
