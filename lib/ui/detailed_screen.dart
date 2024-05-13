import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_time_weather/components/weather_item.dart';
import 'package:real_time_weather/constants.dart';

class DetailedScreen extends StatefulWidget {
  final dailyForecastWeather;
  const DetailedScreen({Key? key, this.dailyForecastWeather}) : super(key: key);

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  final Constants myConstants = Constants();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var weatherData = widget.dailyForecastWeather;

    //function to get weather
    Map getForecastWeather(int index){
      int maxWindSpeed = weatherData[index]['day']['maxwind_kph'].toInt();
      int avgHumidity = weatherData[index]['day']['avghumidity'].toInt();
      int chanceOfRain = weatherData[index]['day']['daily_chance_of_rain'].toInt();

      var parsedDate = DateTime.parse(weatherData[index]['date']);
      var forecastDate = DateFormat('EEEE d, MMMM').format(parsedDate);

      String weatherName = weatherData[index]['day']['condition']['text'];
      String weatherIcon = weatherName.replaceAll(' ', '').toLowerCase() + '.png';

      int minTemperature = weatherData[index]['day']['mintemp_c'].toInt();
      int maxTemperature = weatherData[index]['day']['maxtemp_c'].toInt();

      var forecastData = {
        'maxWindSpeed' : maxWindSpeed,
        'avgHumidity'  : avgHumidity,
        'chanceOfRain' : chanceOfRain,
        'forecastDate' : forecastDate,
        'weatherName' : weatherName,
        'weatherIcon' : weatherIcon,
        'minTemperature' : minTemperature,
        'maxTemperature' : maxTemperature
      };
      return forecastData;
    }

    return Scaffold(
      backgroundColor: myConstants.primaryColor,
      appBar: AppBar(
        title: const Text('Forecasts'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(onPressed: (){
              print('settings');
            }, icon: const Icon (Icons.settings)),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height*.75,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)
                  )
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                        top: -50,
                        right: 20,
                        left: 20,
                        child: Container(
                          height: 300,
                          width: size.width *.7,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5)
                              ]
                            ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(.1),
                                  offset: const Offset(0, 25),
                                  blurRadius: 3,
                                  spreadRadius: -10
                                )
                              ],
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                child: Image.asset('assets/' + getForecastWeather(0)['weatherIcon']), width: 120,),
                              Positioned(
                                  top: 150,
                                  left:30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(getForecastWeather(0)['weatherName'], style: const TextStyle(
                                      fontSize: 20, color: Colors.white
                                    ),),
                                  )),
                              Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Container(
                                    width: size.width*.8,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      WeatherItem(
                                          value: getForecastWeather(0)['maxWindSpeed'] ,
                                          unit: 'km/h',
                                          imageUrl: 'assets/windspeed.png'),
                                        WeatherItem(
                                            value: getForecastWeather(0)['avgHumidity'] ,
                                            unit: '%',
                                            imageUrl: 'assets/humidity.png'),
                                        WeatherItem(
                                            value: getForecastWeather(0)['chanceOfRain'] ,
                                            unit: '%',
                                            imageUrl: 'assets/lightrain.png')
                                        ],
                                    ),
                                  ),
                              ),
                              Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(getForecastWeather(0)['maxTemperature'].toString(), style: TextStyle
                                        (
                                        fontSize: 80,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()..shader= myConstants.shader
                                      ),),
                                      Text('o', style: TextStyle
                                        (
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()..shader= myConstants.shader
                                      ),),
                                    ],
                                  )),
                            ],
                          ),
                        )),
                    Positioned(
                        top: 270.0,
                        left: 0.0,
                        right: 0.0,
                        //bottom: 320.0,
                        child: SingleChildScrollView(
                            child: Container(
                              height: 265,
                              width: size.width,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return
                                      Card(
                                        elevation: 3.0,
                                        margin: const EdgeInsets.only(bottom: 20),
                                        child: Padding (
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(getForecastWeather(index)['forecastDate'], style: const TextStyle(
                                                    color: Color(0xff6696f5),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(getForecastWeather(index)['minTemperature'].toString(),
                                                            style: TextStyle(
                                                                color: myConstants.greyColor,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.w600
                                                            ),),
                                                          Text('o',
                                                            style: TextStyle(
                                                                color: myConstants.greyColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                                fontFeatures: [
                                                                  const FontFeature.enable('sups'),
                                                                ]
                                                            ),)
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(getForecastWeather(index)['maxTemperature'].toString(),
                                                            style: TextStyle(
                                                                color: myConstants.blackColor,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.w600
                                                            ),),
                                                          Text('o',
                                                            style: TextStyle(
                                                                color: myConstants.blackColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                                fontFeatures: [
                                                                  const FontFeature.enable('sups'),
                                                                ]
                                                            ),)
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset('assets/' + getForecastWeather(index)['weatherIcon'], width: 30,),
                                                      const SizedBox(width: 5,),
                                                      Text(getForecastWeather(index)['weatherName'], style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16
                                                      ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(getForecastWeather(index)['chanceOfRain'].toString() + '%', style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 18
                                                      ),),
                                                      const SizedBox(width: 5,),
                                                      Image.asset('assets/lightrain.png', width: 30,),
                                                    ],
                                                  ),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                  }

                              ),
                            )
                        ))
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
