$(function(){
  
  var humidity,wear,car,trip,train,ray;  //湿度，穿衣，洗车，出行，锻炼，紫外线
  var date,week,temp,weather,wind;  //日期，星期，温度，天气，风力
  var url = "http://v.juhe.cn/weather/ip?format=2&key=904697dc82940e31b5b2b1fba543c8bb&ip="+returnCitySN["cip"];

  // 获取今天天气
  var today = function(data){
    
    humidity = data['result']['sk']['humidity'];
    wear = data['result']['today']['dressing_index'];
    car = data['result']['today']['wash_index'];
    trip = data['result']['today']['travel_index'];
    train = data['result']['today']['exercise_index'];
    ray = data['result']['today']['uv_index'];
    
    $(".humidity").append(humidity);
    $(".wear").append(wear);
    $(".car").append(car);
    $(".trip").append(trip);
    $(".train").append(train);
    $(".ray").append(ray);
  };

  // 未来6天天气
  var futureDay = function(data){

    for(var i=0;i<6;i++){
      let str = null;

      date = data['result']['future'][i]['date'].replace(/^(\d{4})(\d{2})(\d{2})$/, "$1-$2-$3");
      week = data['result']['future'][i]['week'];
      temp = data['result']['future'][i]['temperature'];
      weather = data['result']['future'][i]['weather'];
      wind = data['result']['future'][i]['wind'];

      str += "<td>"+date+"</td><td>"+week+"</td><td>"+temp+"</td><td>"+weather+"</td><td>"+wind+"</td>";

      $(".table>tbody").append("<tr>"+str+"</tr>");
    }
    
  };
  
  $.ajax({
    type:"GET",
    url:"http://v.juhe.cn/weather/ip?format=2&key=904697dc82940e31b5b2b1fba543c8bb&ip="+returnCitySN["cip"],
    dataType:"JSONP",
    // crossDomain:true,
    success:function(data){
      today(data);
      futureDay(data);
    }
  });
  
})