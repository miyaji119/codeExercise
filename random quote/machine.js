$(function(){

  var author,quote;
  // var quoteLeft = '<i class="fa fa-quote-left" aria-hidden="true"></i>   ';

  // 产生新quote
  $(".new-btn").click(function(){
    // 更改颜色
    var rgb = randomColor();
    $("body").animate({backgrounColor:rgb},800);
    $(".new-btn>button").animate({backgroundColor:rgb},800);
    $(".share-btn>a").animate({backgroundColor:rgb},800);
    $(".quote>p").animate({color:rgb});

    // 文字渐变效果
    $(".quote>p").animate({
      opacity:0
    },800,function(){
      // 调用一言api
      getNewQuote();
      $(this).animate({
        opacity:1
      });
    });

  });

  // 推特分享
  $(".twitter-share").click(function(event){
    event.preventDefault();
    window.open("http://twitter.com/intent/tweet?text="+encodeURIComponent(quote+"by"+author));
  });

  // 汤不热分享
  $(".tumblr-share").click(function(event){
    event.preventDefault();
    window.open("http://tumblr.com//widgets/share/tool?posttype="+encodeURIComponent(quote+"by"+author));
  });

  // 随机颜色
  var randomColor = function(){
    var r = Math.random()*255;
    var g = Math.random()*255;
    var b = Math.random()*255;
    return "rgb("+r+","+g+","+b+")";
  };

  // 获取随机quote，并添加到页面中
  var getNewQuote = function(){
    $.getJSON("https://sslapi.hitokoto.cn/?encode=json",function(json){
      quote = json["hitokoto"];  // 获得格言
      author = json["from"];  // 获得作者

      $(".quote>p:first-child").html('<i class="fa fa-quote-left" aria-hidden="true"></i>   '+quote);
      $(".quote>p:last-child").html("- "+author);
    });
  };
})
