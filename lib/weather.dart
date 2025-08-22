import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/weather_model.dart';

class HomePage extends StatelessWidget{
  Future<WeatherDetailsModel?> fetchWeather()async{
    final url = "https://api.openweathermap.org/data/2.5/weather?lat=26.3880&lon=73.5300&appid=1ec740d44c3cb490faea63166ffcb578&units=metric";


    http.Response res =await http.get(Uri.parse(url));

    if(res.statusCode == 200){
      dynamic mData =jsonDecode(res.body);
      WeatherDetailsModel mWeatherModel =WeatherDetailsModel.fromJson(mData);
      return mWeatherModel;
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: FutureBuilder<WeatherDetailsModel?>(
         future: fetchWeather(),
         builder: (context, snapshot){
          ///Time---------------------------------------------------------------
           int dt = snapshot.data!.dt;
           int tz = snapshot.data!.timezone;

           final utc = DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true);
           final localAtLocation = utc.add(Duration(seconds: tz));

          /// Base time (current location time)
           final baseTime = DateTime(
             localAtLocation.year,
             localAtLocation.month,
             localAtLocation.day,
             localAtLocation.hour,
             0,
           ); // minutes ko 0 kiya for clean round hour

           ///------------------------------------------------------------------

           if(snapshot.connectionState==ConnectionState.waiting){
             return Center(
               child: CircularProgressIndicator(),
             );
           }
           if(snapshot.hasError){
             return Center(
               child: Text("Error : ${snapshot.error}"),
             );
           }
           if(snapshot.hasData){
             return SingleChildScrollView(
               child: Column(
                 children: [
                   Container(
                     padding: EdgeInsets.only(top: 50,left: 12,right: 12),
                     width: double.infinity,
                     height: 450,
                     decoration: BoxDecoration(
                         color: Colors.blue.shade200
                     ),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("${snapshot.data!.name}",style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 25,
                                 fontWeight: FontWeight.w500
                             ),),
                             Icon(Icons.menu_open_outlined,color: Colors.white,size: 35,)
                           ],
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("${snapshot.data!.main.temp.toInt()}",style: TextStyle(
                                     fontSize: 100,
                                     color: Colors.white
                                 ),),
                                 Text("°c",style: TextStyle(
                                     fontSize: 50,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.white
                                 ),)
                               ],
                             ),
                             Text("${snapshot.data!.weather[0].description}",style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 22,
                                 fontWeight: FontWeight.w500
                             ),),
                             Text("${snapshot.data!.main.temp_min.toInt()}" " ~ " "${snapshot.data!.main.temp_max.toInt()}" "°C Feels like " "${snapshot.data!.main.feels_like.toInt()}",style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 21,
                                 fontWeight: FontWeight.w500
                             ),)
                           ],
                         ),
                         SizedBox(height: 50,),
                         SizedBox(
                           height: 100,
                           child: ListView.builder(
                             itemCount: 23,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (context, index){
                               // Current + index hours
                               final futureTime = baseTime.add(Duration(hours: index));

                               // Format hour + minute (24h)
                               final hourText = DateFormat('HH:mm').format(futureTime);

                               return Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   children: [
                                     Image.network("http://openweathermap.org/img/wn/${snapshot.data!.weather[0].icon}@2x.png",width: 50,),
                                     Text(hourText),
                                     // Text(dateText),
                                   ],
                                 ),
                               );
                             },
                           ),
                         )
                       ],
                     ),
                   ),
                   ListView.builder(
                     physics: NeverScrollableScrollPhysics(),
                     padding: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
                     shrinkWrap: true,
                     itemCount: 7,
                     itemBuilder: (context, index) {
                       return Row(
                         children: [
                           Expanded(flex: 2, child: Text("08/20",style: TextStyle(
                               fontWeight: FontWeight.w600,
                               fontSize: 19
                           ),)),
                           Expanded(flex: 2, child: Text("Today",style: TextStyle(
                               color: Colors.grey,
                               fontWeight: FontWeight.w600,
                               fontSize: 19
                           ),)),
                           Expanded(flex: 3, child: Row(
                             children: [
                               Image.asset("lib/assets/Img/cloud.png",width: 40,height: 40,),
                               SizedBox(width: 8),
                               Text("98%",style: TextStyle(
                                   color: Colors.blueAccent,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 18
                               ),)
                             ],
                           )),
                           Expanded(flex: 1, child: Text("27",style: TextStyle(
                               color: Colors.grey,
                               fontWeight: FontWeight.w600,
                               fontSize: 19
                           ),)),
                           Expanded(flex: 1, child: Text("35",style: TextStyle(
                               fontWeight: FontWeight.w600,
                               fontSize: 19
                           ),)),
                         ],
                       );
                     },
                   ),
                   SizedBox(height: 15,),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 26,vertical: 10),
                     decoration: BoxDecoration(
                       color: Colors.grey.shade500,
                       borderRadius: BorderRadius.circular(35),
                     ),
                     child: Text("View More",style: TextStyle(
                         fontSize: 22,
                         fontWeight: FontWeight.w700
                     ),),
                   ),
                   SizedBox(
                       height: 400,
                       child: GridView(
                         physics: NeverScrollableScrollPhysics(),
                         padding: EdgeInsets.symmetric(vertical: 35),
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                         children: [
                           Column(
                             children: [
                               Image.asset("lib/assets/Img/temp.png",width: 40,),
                               Text("Feels like",style: TextStyle(
                                   color: Colors.grey
                               ),),
                               Text("${snapshot.data!.main.feels_like.toInt()} °C")
                             ],
                           ),
                           Column(
                             children: [
                               Image.asset("lib/assets/Img/wind.png",width: 40,),
                               Text("ENE",style: TextStyle(
                                   color: Colors.grey
                               ),),
                               Text("Force ${snapshot.data!.wind.speed.toInt()}")
                             ],
                           ),
                           Column(
                             children: [
                               Image.asset("lib/assets/Img/humidity.png",width: 40,),
                               Text("Humidity",style: TextStyle(
                                   color: Colors.grey
                               ),),
                               Text("${snapshot.data!.main.humidity} %")
                             ],
                           ),
                           Column(
                             children: [
                               Image.asset("lib/assets/Img/uv.png",width: 40,),
                               Text("UV",style: TextStyle(
                                   color: Colors.grey
                               ),),
                               Text("Weaker")
                             ],
                           ),
                           Column(
                             children: [
                               Image.asset("lib/assets/Img/vision.png",width: 40,),
                               Text("Visibility",style: TextStyle(
                                   color: Colors.grey
                               ),),
                               Text("${snapshot.data!.visibility} M")
                             ],
                           ),
                           Column(
                             children: [
                               Image.asset("lib/assets/Img/pressure.png",width: 40,),
                               Text("Pressure",style: TextStyle(
                                   color: Colors.grey
                               ),),
                               Text("${snapshot.data!.main.pressure} hPa")
                             ],
                           ),
                         ],
                       )
                   )
                 ],
               ),
             );
           }
           return Container();
         },
     ),
   );
  }
}