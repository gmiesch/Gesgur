alert("running script");

function removeElement(elementId) {
    // Removes an element from the document
    var element = document.getElementById(elementId);
    element.parentNode.removeChild(element);
}

removeElement('topbar');
var overlay = document.createElement('div');
var center = document.createElement('center');
var text = document.createTextNode('Link');
var imgtitle = document.getElementById('image-title-container');
var img = document.getElementById('image');
var link = document.createElement('a');
link.setAttribute('href', 'http://www.google.com');
link.setAttribute('id', 'test');
link.appendChild(text);
link.setAttribute('id', 'img');
overlay.setAttribute('class', 'dim');
center.appendChild(link);
center.appendChild(imgtitle);
center.appendChild(img);
overlay.appendChild(center);
document.body.appendChild(overlay);

alert("ran script");
