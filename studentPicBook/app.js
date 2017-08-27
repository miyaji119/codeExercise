var express = require("express");
var app = express();
var router = require("./controller/router.js");

app.set("view engine","jade");
app.set("views","./views/pages");
app.locals.pretty = true;

app.use(express.static("public"));

// 显示欢迎首页
app.get("/",router.showAllFolders);
app.get("/:folderOwner",router.showPicsInFolder);

app.use(router.showNotFoundErr);

// app.use(function(req,res){
// 	res.render("404");
// });

app.listen(80,function(){
	console.log("student pic book is running at port 80");
});