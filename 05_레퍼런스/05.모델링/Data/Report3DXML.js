String.prototype.startsWith = function (a) {
    return this.substr(0, a.length) === a;
}

String.prototype.endsWith = function (a) {
    return this.substr(this.length - a.length) === a;
}

function toggle_visibility_by_id(hideShowId, hideShowImg) {
    var elemToHideShow = document.getElementById(hideShowId);
    var imgToHideShow = document.getElementById(hideShowImg);
    if (elemToHideShow != null) {
        if (hideShowImg.startsWith('plusminus')) {
            if (imgToHideShow.src.endsWith('Plus.gif')) {
                elemToHideShow.style.display = 'block';
                imgToHideShow.src = "Data\\Minus.gif";
            }
            else {
                elemToHideShow.style.display = 'none';
                imgToHideShow.src = "Data\\Plus.gif";
            }
        }
    }
}
