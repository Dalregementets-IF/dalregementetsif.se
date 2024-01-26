/* vim: set noexpandtab ts=4 sw=4: */
/*
This is an altered JS based on the Nginx Fancyindex module theme
Nginxy by lfelipe1501: https://github.com/lfelipe1501/Nginxy
*/
// Configure Nginxy here:
var websiteName = "Dalregementets IF";
var websiteURL = "";
var parentDirText = "Föregående katalog"
// End of normal settings.

$(document).ready(function(){

// Working on nginx HTML and applying settings.
var text = $("h1").text();
var array = text.split('/');
var last = array[array.length-2];
var dirStructure = $("a").text();
var dirStructure = document.getElementsByTagName('a')[0].href;
var dir = text.substring(10);
var currentDir = last.charAt(0) + last.slice(1);
var dirTrun;

// Truncate long folder names.
if (currentDir.length > 19){
	var currentDir = currentDir.substring(0, 18) + '...';
}

// Updating page title.
document.title = currentDir + ' – ' + websiteName;

// Updating page footer.
$("#footerURL").text(websiteName);
$("#footerURL").attr('href', websiteURL);

// Add back button.
$("h1").html(currentDir);

if (dir.length > 60) {
	dirTrun = dir.replace(/(.{60})/g, "$1\n")
} else {
	dirTrun = dir.substring(0, dir.length - 1);
}

// Establish supported formats.
var list = new Array();
var formats = ["bin", "jpg", "gif", "bmp", "png", "html", "css", "zip", "iso", "tiff", "ico", "psd", "pdf", "exe", "rar", "deb", "swf", "7z", "doc", "docx", "xls", "xlsx", "pptx", "ppt", "txt", "php", "js", "c", "cpp", "torrent", "sql", "wmv", "avi", "mp4", "mp3", "wma", "ogg", "msg", "wav", "py", "java", "gzip", "jpeg", "raw", "cmd", "bat", "sh", "svg"];

// Scan all files in the directory, check the extensions and show the right MIME-type image.
$('td a').each(function(){
	let fileExt = "";
	let parts = $(this).attr('href').split(".");
	if (parts.length > 1) {
		fileExt = parts[parts.length - 1];
	}

	if ($(this).text().indexOf("Parent directory") >= 0) {
		// Add an icon for the go-back link.
		$(this).html('<img class="icons" src="/img/icons/home.webp">' + parentDirText);
	} else if (fileExt.length > 0) {
		let i = formats.indexOf(fileExt.toLowerCase())
		if (i != -1) {
			$(this).html('<img class="icons" src="/img/icons/' + formats[i] + '.webp"></img></a>' + $(this).text());
		} else {
			// File format not supported by Better Listings, so let's load a generic icon.
			$(this).html('<img class="icons" src="/img/icons/error.webp">' + $(this).text());
		}
	} else {
		let name = $(this).text();
		$(this).html('<img class="icons" src="/img/icons/folder.webp">' + name.substring(0, name.length - 1));

		// Fix for annoying jQuery behaviour where inserted spaces are treated as new elements -- which breaks my search.
		let string = ' ' + $($(this)[0].nextSibling).text();

		// Copy the original meta-data string, append a space char and save it over the old string.
		$($(this)[0].nextSibling).remove();
		$(this).after(string);
	}
});
});
