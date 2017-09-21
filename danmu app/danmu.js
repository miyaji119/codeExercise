$(function(){
  var $danmu = $("input[name='msg']");
  var $wall = $(".wall");
  var $word = $(".wall>div");

  //清屏
  $(".clear").click(function(){
    $wall.empty();
  });

  //发射
  $(".send").click(function(){
    // 添加文字
    $wall.append('<div style="color:'+randomColor()+';margin-top:'+randomeLocation()+';left:1380px;" class="pull-right">'+$danmu.val()+'</div>');
    $danmu.val("");

  });

  // 产生一个随机rgb颜色
  var randomColor = function(){
    //产生一个0-255的随机数
    var r = Math.round(Math.random(0,256)*255);
    var g = Math.round(Math.random(0,256)*255);
    var b = Math.round(Math.random(0,256)*255);

    var rgbColorStr = "rgb("+r+","+g+","+b+")";

    return rgbColorStr;
  };

  // 产生一个随机位置
  var randomeLocation = function(){
    return  Math.round(Math.random(0,380)*380)+"px";
  };


});
