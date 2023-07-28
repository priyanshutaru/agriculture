import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:agriculture/main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Home_Page.dart';

class ViewNextday extends StatefulWidget {
  const ViewNextday({Key? key}) : super(key: key);
  @override
  State<ViewNextday> createState() => _ViewNextdayState();
}

class _ViewNextdayState extends State<ViewNextday> {
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  String cdate = DateFormat("dd / MMM / yyyy").format(DateTime.now());
  String locality = '';
  double lat = 0.0;
  double long = 0.0;
  String wearApikey = "-";
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong() async {
    Position position = await _getGeoLocationPosition();
    var placemarks =
        (await placemarkFromCoordinates(position.latitude, position.longitude));
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      print("latitude ,longitude" + lat.toString() + long.toString());
      Placemark place = placemarks[0];
      locality = place.locality.toString();
      loading = true;
    });
  }

  // Future<List<Weather>> getViewNextday() async {
  //   Uri url=Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$wearApikey&units=metric");
  //   var response=await http.get(url);
  //  // var results = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     List data=json.decode(response.body)["weather"];
  //     return data.map((data) => Weather.fromJson(data)).toList();
  //   }else{
  //     throw Exception('unexpected error occurred');
  //   }
  // }
  DateTime now = DateTime.now();
  String time = DateFormat("hh:mm:ss a").format(DateTime.now());
  var temp;
  var precip_mm;
  var currently;
  var humidity;
  var weather;
  var cityName;
  bool loading = false;

  Future getWeather() async {
    //Uri url=Uri.parse("http://api.weatherapi.com/v1/current.json?key=e5bd00e528e346ff8a840254213009&q=India $locality&aqi=no");
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$wearApikey&units=metric");
    var response = await http.get(url);
    var results = jsonDecode(response.body);
    setState(() {
      temp = results['main']['temp'];
      humidity = results['main']['humidity'];
      precip_mm = results['main']['pressure'];
      weather = results['weather'][0]['main'];
      cityName = results['name'];
      print("humidity====>>>>" + weather.toString());
      loading = true;
    });
  }

  String? name, number, mainimg;
  Future getUser() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_user");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    setState(() {
      name = res["name"];
      number = res['mobile'];
      mainimg = res['img'].toString();
      print(user_id.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  int _value = 1;
  @override
  void initState() {
    super.initState();
    // setState(() {
    _getGeoLocationPosition();
    GetAddressFromLatLong();
    getWeather();
    getUser();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile_page()));
                                          },
                                          child: mainimg == 'null'
                                              ? Icon(
                                                  CupertinoIcons.person_circle,
                                                  size: 37,
                                                  color: Color(0xff00aeef),
                                                )
                                              : Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: 20,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        mainimg.toString(),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "apt1".tr,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff66ad2d)),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "apt2".tr,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff00aeef)),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                13,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: DropdownButton(
                                            value: _value,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text(
                                                  "भाषा/Language",
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: TextButton(
                                                    onPressed: () {
                                                      updateLanguage(
                                                          Locale('hi', 'IN'));
                                                    },
                                                    child: Text(
                                                      "हिन्दी/Hindi",
                                                      style: TextStyle(
                                                          fontSize: 8),
                                                    )),
                                                value: 2,
                                              ),
                                              DropdownMenuItem(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        updateLanguage(
                                                            Locale('en', 'US'));
                                                      },
                                                      child: Text(
                                                        "इंग्लिश/English",
                                                        style: TextStyle(
                                                            fontSize: 8),
                                                      )),
                                                  value: 3),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _value =
                                                    int.parse(value.toString());
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                45,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 40,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white24,
                                              child: IconButton(
                                                  onPressed: () {
                                                    launch("tel:" +
                                                        Uri.encodeComponent(
                                                            '9936868049'));
                                                  },
                                                  icon: Icon(Icons.call,
                                                      color:
                                                          Color(0xff66ad2d))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "help".tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff00aeef),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            width: MediaQuery.of(context).size.width * 0.65,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/weather.png"),
                                    fit: BoxFit.fill)),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  temp != null
                                      ? double.parse(temp.toString())
                                              .toStringAsFixed(0) +
                                          "\u00B0C"
                                      : "Loading",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1d6280)),
                                ),
                                Text(
                                  weather != null
                                      ? weather.toString()
                                      : "Loading",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff50899f)),
                                ),
                                Text(
                                  time.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xff50899f),
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Today",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xff50899f),
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    // child:  Center(
                    //   child:  Text(
                    //     AppLocalizations.instance.text('page_one'),
                    //     style:  TextStyle(
                    //       fontSize: 22.00,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.47,
                      child: ListView.builder(
                          physics: ScrollPhysics(),
                          itemCount: 5,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, index) {
                            return Card(
                              elevation: 5,
                              color: Colors.white70,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.lightGreen,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${'date'.tr} - ${cdate}",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            // Text("Day - Friday",style: TextStyle(fontStyle: FontStyle.italic,fontSize:13,fontWeight: FontWeight.bold,color: Colors.white)),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(locality.toString(),
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.cloudy_snowing,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Rain",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff66ad2d))),
                                            Text("05:15 AM",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff00aeef))),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.cloudy_snowing,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Rain",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff66ad2d))),
                                            Text("10:10 AM",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff00aeef))),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.cloud_circle_sharp,
                                              color: Colors.black26,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Cloudy",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff66ad2d))),
                                            Text("12:45 PM",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff00aeef))),
                                          ],
                                        ),
                                        // Column(
                                        //   children: [
                                        //     Icon(Icons.cloud_off_outlined,color: Colors.black26,),
                                        //     SizedBox(height: 5,),
                                        //     Text("Scatterd Cloud",style: TextStyle(fontStyle: FontStyle.italic,fontSize:12,fontWeight: FontWeight.bold,color: Color(0xff66ad2d))),
                                        //     Text("05:25 PM",style: TextStyle(fontStyle: FontStyle.italic,fontSize:13,fontWeight: FontWeight.bold,color: Color(0xff00aeef))),
                                        //   ],
                                        // ),
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.cloudy_snowing,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Rain",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff66ad2d))),
                                            Text("11:25 PM",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff00aeef))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    // Expanded(
                    //     child: FutureBuilder<List<Weather>>(
                    //         future:   getViewNextday(),
                    //         builder:(context, AsyncSnapshot snapshot) {
                    //           if (!snapshot.hasData) {
                    //             return Center(child: CircularProgressIndicator());
                    //           } else {
                    //             List<Weather>? data=snapshot.data;
                    //             return data!.length!=0?  ListView.builder(
                    //                 itemCount: data.length,
                    //                 itemBuilder: (context, i){
                    //                   return Card(
                    //                     child: Container(
                    //                       child: ListTile(
                    //                         title: Text(data[i].main.toString()),
                    //                         subtitle: Text(data[i].description.toString()),
                    //                       ),
                    //                     ),
                    //                   );
                    //                 }
                    //             ):
                    //             Center(
                    //               child: Text("No Vehicle Details.."),
                    //             );
                    //           }
                    //         }
                    //     ),
                    // )
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: Color(0xff40bdec),
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.white.withOpacity(.90),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: (value) {
              // Respond to item press.
              setState(() => _currentIndex = value);
              if (_currentIndex == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home_page()));
              } else if (_currentIndex == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => crop_health()));
              } else if (_currentIndex == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Show_me_plan()));
              } else if (_currentIndex == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Crop_Advisory()));
              }
            },
            items: [
              BottomNavigationBarItem(
                label: "home".tr,
                icon: Icon(
                  CupertinoIcons.house_fill,
                  size: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: "crop_doctor".tr,
                icon: Icon(
                  Icons.local_hospital,
                  size: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: "crop_plans".tr,
                icon: Icon(
                  CupertinoIcons.crop_rotate,
                  size: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: "crop_advisory".tr,
                icon: Icon(
                  CupertinoIcons.question_diamond,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
