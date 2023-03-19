import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:real_time_weather/components/weather_item.dart';
import 'package:real_time_weather/constants.dart';
import 'package:real_time_weather/ui/detailed_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController cityController = TextEditingController();
  Constants myConstants = Constants();

  static String API_KEY = '37591acf4d9a486f8b5120452230102';

  String location = 'London';
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=" +
      API_KEY +
      "&days=7&q=";

//call Api
  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        //weather update
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //daily and hourly forecast
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              height: size.height,
              width: size.width,
              color: myConstants.primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        height: size.height * .7,
                        decoration: BoxDecoration(
                          gradient: myConstants.linearGradientBlue,
                          boxShadow: [
                            BoxShadow(
                              color: myConstants.primaryColor.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage('assets/menu.png'),
                                  height: 40,
                                  width: 40,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/pin.png',
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      location,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cityController.clear();
                                        showModalBottomSheet(
                                            context: context,
                                            builder:
                                                (context) =>
                                                    SingleChildScrollView(
                                                      controller:
                                                          ModalScrollController
                                                              .of(context),
                                                      child: Container(
                                                        height:
                                                            size.height * .2,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width: 70,
                                                              child: Divider(
                                                                thickness: 3.5,
                                                                color: myConstants
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextField(
                                                              onChanged:
                                                                  (searchText) {
                                                                fetchWeatherData(
                                                                    searchText);
                                                              },
                                                              controller:
                                                                  cityController,
                                                              autofocus: true,
                                                              decoration:
                                                                  InputDecoration(
                                                                      prefixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .search,
                                                                        color: myConstants
                                                                            .primaryColor,
                                                                      ),
                                                                      suffixIcon:
                                                                          GestureDetector(
                                                                        onTap: () =>
                                                                            cityController.clear(),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              myConstants.primaryColor,
                                                                        ),
                                                                      ),
                                                                      hintText:
                                                                          'Search city e.g. London',
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: myConstants.primaryColor),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      )),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/profile.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              child: Image.asset('assets/' + weatherIcon),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    temperature.toString(),
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = myConstants.shader,
                                    ),
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = myConstants.shader,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              currentWeatherStatus,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20),
                            ),
                            Text(
                              currentDate,
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                color: Colors.white70,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    WeatherItem(
                                      value: windSpeed.toInt(),
                                      unit: 'km/h',
                                      imageUrl: 'assets/windspeed.png',
                                    ),
                                    WeatherItem(
                                      value: humidity.toInt(),
                                      unit: '%',
                                      imageUrl: 'assets/humidity.png',
                                    ),
                                    WeatherItem(
                                      value: cloud.toInt(),
                                      unit: '%',
                                      imageUrl: 'assets/cloud.png',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      height: size.height * .2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder:
                                (context) => DetailedScreen(dailyForecastWeather: dailyWeatherForecast) )),
                                child: Text(
                                  'Forecasts',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: myConstants.primaryColor),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: hourlyWeatherForecast.length,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String currentTime = DateFormat('HH:mm:ss')
                                      .format(DateTime.now());
                                  String currentHour =
                                      currentTime.substring(0, 2);
                                  String forecastTime =
                                      hourlyWeatherForecast[index]['time']
                                          .substring(11, 16);
                                  String forecastHour =
                                      hourlyWeatherForecast[index]['time']
                                          .substring(11, 13);
                                  String forecastWeatherName =
                                      hourlyWeatherForecast[index]['condition']
                                          ['text'];
                                  String forecastWeatherIcon =
                                      forecastWeatherName
                                              .replaceAll(' ', '')
                                              .toLowerCase() +
                                          '.png';
                                  String forecastTemperature =
                                      hourlyWeatherForecast[index]['temp_c']
                                          .round()
                                          .toString();
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    margin: EdgeInsets.only(right: 20),
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: currentHour == forecastHour
                                            ? Colors.white
                                            : myConstants.primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 5,
                                              color: myConstants.primaryColor
                                                  .withOpacity(.2))
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          forecastTime,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: myConstants.greyColor),
                                        ),
                                        Image(
                                          width: 20,
                                          image: AssetImage(
                                              'assets/' + forecastWeatherIcon),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              forecastTemperature,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: myConstants.greyColor),
                                            ),
                                            Text(
                                              'o',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: myConstants.greyColor,
                                                fontSize: 17,
                                                fontFeatures: const [
                                                  FontFeature.enable('sups'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }
                                ),
                          )
                        ],
                      ),
                    )
                  ])),
        ));
  }
}
