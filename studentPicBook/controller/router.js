var files = require("../model/fileMgr.js");

var showAllFolders = function(req,res){	

	files.getAllFolder(function(folders){
		console.log("folders:"+folders);
		res.render("show_all_folders",{
			pageTitle:"同学录相册 所有相册",
			folders:folders
		});
	});
	
};

var showNotFoundErr = function(req,res){
	res.render("404",{
		pageTitle:"同学录相册 链接访问失败"
	});
};

var showPicsInFolder = function(req,res){
	var owner = req.params.folderOwner;
	res.render("show_folder_pics",{
		pageTitle:"同学录相册 "+owner+"的相册",
		folderOwner:owner
	});
};

exports.showAllFolders = showAllFolders;
exports.showNotFoundErr = showNotFoundErr;
exports.showPicsInFolder = showPicsInFolder;