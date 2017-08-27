var fs = require("fs");
var path = require("path");

exports.getAllFolder = function(callback){
	// 相册文件夹名称数组
	var folders = [];

	fs.readdir("./upload",function(err,files){
		// 通过readdir得到的文件名称数组中可能含有文件信息，而不是目录
		// 在此需要过滤，以确保得到的都是目录名称

		// for(var i=0;i<files.length;i++){
		// 	fs.stat("./upload"+files[0],function(err,stats){
		// 		if(stats.isDirectory())
		// 			folders.push(files[0]);
		// 	});
		// }

		(function iterator(idx){

			if(idx == files.length){
				console.log(folders);
				callback(folders);
				return;
			}
			fs.stat(path.join("./upload/",files[idx]),function(err,stats){
				if(stats.isDirectory())
					folders.push(files[idx]);
				iterator(++idx);
			});

		})(0);
		
	});
};