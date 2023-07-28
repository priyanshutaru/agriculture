// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/owner_home_page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/check_tractor.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/pay_by_customer.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/tractor_owner.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/Tubewell_All_model/add_customer_tubewell.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/pay_amount.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/tubewell_owner.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/view_all_tubewell_customer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Crop_Advisory_all_page/Crop_Advisory.dart';
import 'Sell_Crop_all_page/Sell_crop1_page.dart';
import 'Tractor_booking_all_page/Tractor_booking_page.dart';
import 'Tubewell_booking_all_page/check_tubewell.dart';
import 'Tubewell_booking_all_page/tubewell_page.dart';
import 'ViewNextday_page.dart';
import 'crop_calendar.dart';
import 'crop_health_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  int _currentIndex = 0;
  String locality = '';
  double lat = 0.0;
  double long = 0.0;
  String googleApikey = "0f8c88146a435b8db9d6af1cacbbc02a";
  String wearApikey = "b30de56fcbd933743d24fc9004670526";
  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  bool loading = false;

  List getCropPlans = [];

  // Future getUserCropPlans() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   Map data = {
  //     'user_id': user_id.toString(),
  //   };
  //   var data1 = jsonEncode(data);
  //   var url = Uri.parse(
  //       "https://doplus.creditmywallet.in.net/api/get_user_crop_plan_list");
  //   final response = await http.post(url,
  //       headers: {"Content-Type": "Application/json"}, body: data1);
  //   var res = jsonDecode(response.body)['response'];
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       getCropPlans = res;
  //       print("QQQQQQQQ>>>>>" + getCropPlans.toString());
  //       loading = false;
  //     });
  //   }
  // }

  int _value = 1;

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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      print("latitude ,longitude" + lat.toString() + long.toString());
      Placemark place = placemarks[0];
      locality = place.locality.toString();
    });
  }

  var temp;
  var precip_mm;
  var currently;
  var humidity;
  var weather;
  var cityName;

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
    });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var percentage;
  Future getpercentage() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_profile_percentage");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      percentage = res['response'];
      // percentage = 89;
      loading = false;

      print(percentage.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  void _setName(name) async {
    final pref = await SharedPreferences.getInstance();
    final set1 = pref.setString('name', name);
    print("user_id  %%==>>>=++++" + set1.toString());
  }

  void _setnumber(number) async {
    final pref = await SharedPreferences.getInstance();
    final set1 = pref.setString('mobile', number);
    print("user_id  %%==>>>=++++" + set1.toString());
  }

  String? name, number, img;
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
      img = res['img'].toString();
      _setName(name);
      _setnumber(number);
      print(img.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  initiateTransaction() async {
    String upi_url =
        'upi://pay?pa=aneesshameed@oksbi&pn=AneesHameed&am=1.27&cu=INR';
    await launch(upi_url).then((value) {
      print(value);
    }).catchError((err) => print(err));
  }

  String? status;
  Future checkOwner() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/check_have_tractor");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    if (res == '0') {
      if (filled_status == 'Yes') {
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Add_Customer()));
        });
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Tractor_owner_detail()));
      }
    } else if (res == '1') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Request_Screen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckTractor()));
    }
  }

  String? have_crop_plan;

  Future checkcroplist() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/check_user_task_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['have_crop_plan'];
    setState(() {
      have_crop_plan = res.toString();
      print(have_crop_plan);
    });
  }

  Future checkTubewellOwner() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/check_have_tubewell");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    if (res == '0') {
      if (tubewellfilled_status == 'Yes') {
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Add_Customer_Tubewell()));
        });
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Tubewell_owner_detail()));
      }
    } else if (res == '1') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Pay_Amount()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CheckTubewell()));
    }
  }

  String? filled_status;
  String? tubewellfilled_status;

  Future gettractorDetal() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tractor_details");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['tractor_ditails_filled'];
    setState(() {
      filled_status = res;
    });
    // if(res=='Yes'){
    //   setState(() {
    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Customer()));
    //   });
    // }else{
    //   setState(() {
    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Request_Screen()));
    //   });
    // }
  }

  Future getubewellDetal() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tubewell_details");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['tractor_ditails_filled'];
    setState(() {
      tubewellfilled_status = res;
    });
    // if(res=='Yes'){
    //   setState(() {
    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Customer()));
    //   });
    // }else{
    //   setState(() {
    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Request_Screen()));
    //   });
    // }
  }

  Future getProfilegetProfile() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
      //'user_id':"USR681808989",
    };
    Uri url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_user");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    var res = await json.decode(response.body);
    print('ankit$res');
    setState(() {
      name = res["name"];
      loading = false;
    });
    print(name);
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, elevation: 0),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, elevation: 0),
                //return true when click on "Yes"
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    GetAddressFromLatLong();
    _getGeoLocationPosition();
    getWeather();
    getUser();
    _setName(name);
    _setnumber(number);
    getpercentage();
    gettractorDetal();
    getubewellDetal();
    checkcroplist();
    // getUserCropPlans();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: Text("Shasy Mitro",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: Colors.green),textAlign: TextAlign.center,),
        leadingWidth: 150,
        centerTitle: true,
        actions: [
          DropdownButton(
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
            iconEnabledColor: Colors.blue,
            iconSize: 25,
            elevation: 00,
            underline: SizedBox(),
            value: dropdownvalue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
              });
            },
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              Container(
                height: 35,
                width: 40,
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage("assets/support.png")
                  )
                ),
              ),
              Text("Support",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(width: 10,),
        ],
      ),*/
      body: WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              // _currentIndex--;
              _currentIndex = 0;

              Fluttertoast.showToast(msg: 'Tap back again to leave');
            });
            return false;
          } else if (_currentIndex == 0) {
            setState(() {
              _currentIndex = 0;
              showExitPopup();
              // Fluttertoast.showToast(msg: 'Tap back again to leave');
              // if (Platform.isAndroid) {
              //   SystemNavigator.pop();
              // } else if (Platform.isIOS) {
              //   exit(0);
              // }
            });
            return false;
          }

          return true;
        }, //call function on back button press
        child: SafeArea(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        child: img == 'null'
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
                                                      img.toString(),
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
                                      width: MediaQuery.of(context).size.width /
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
                                                style: TextStyle(fontSize: 12),
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
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                                          fontSize: 12),
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
                                    // DropdownButton(
                                    //   style: TextStyle(
                                    //       fontSize: 11,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Color(0xff00aeef)),
                                    //   iconEnabledColor: Colors.black87,
                                    //   iconSize: 25,
                                    //   elevation: 00,
                                    //   underline: SizedBox(),
                                    //   value: dropdownvalue,
                                    //   icon: const Icon(
                                    //     Icons.arrow_drop_down,
                                    //   ),
                                    //   items: items.map((String items) {
                                    //     return DropdownMenuItem(
                                    //       value: items,
                                    //       child: Column(
                                    //         children: [
                                    //           Text('भाषा/Language'),
                                    //           ElevatedButton(
                                    //             onPressed: () {
                                    //               updateLanguage(
                                    //                   Locale('hi', 'IN'));
                                    //               // var locale = Locale('hi', 'IN');
                                    //               // Get.updateLocale(locale);
                                    //             },
                                    //             child: Text('हिन्दी/Hindi'),
                                    //           ),
                                    //           ElevatedButton(
                                    //             onPressed: () {
                                    //               updateLanguage(
                                    //                   Locale('en', 'US'));

                                    //               // var locale = Locale('en', 'US');
                                    //               // Get.updateLocale(locale);
                                    //             },
                                    //             child: Text('इंग्लिश/English'),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     );
                                    //   }).toList(),
                                    //   onChanged: (String? newValue) {
                                    //     setState(() {
                                    //       dropdownvalue = newValue!;
                                    //     });
                                    //   },
                                    // ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
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
                                                    color: Color(0xff66ad2d))),
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
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  percentage != 100
                                      ? Card(
                                          elevation: 5,
                                          color: Color(0xff82cb40),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // height: MediaQuery.of(context).size.height/7.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "complete_your_profile"
                                                                  .tr,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "profile_complete"
                                                                  .tr,
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            percentage != 100
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => Profile_page()));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              30,
                                                                          vertical:
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(20)),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "complete_now"
                                                                            .tr,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black54),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Text('')
                                                          ],
                                                        ),
                                                        Container(
                                                          child:
                                                              CircularPercentIndicator(
                                                            radius: 45.0,
                                                            lineWidth: 8.0,
                                                            animation: true,
                                                            percent: percentage /
                                                                        100 ==
                                                                    null
                                                                ? "10"
                                                                : percentage /
                                                                    100,
                                                            center: Text(
                                                              percentage == null
                                                                  ? "10%"
                                                                  : percentage
                                                                          .toString() +
                                                                      "%",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            circularStrokeCap:
                                                                CircularStrokeCap
                                                                    .round,
                                                            progressColor:
                                                                Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(""),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Card(
                                    elevation: 2,
                                    color: Color(0xffc7e5f0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    temp != null
                                                        ? double.parse(temp
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    0) +
                                                            "\u00B0C"
                                                        : "Loading",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1d6280)),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ViewNextday()));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "nxt5days".tr,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff1d6280)),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 17,
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                              Text(
                                                weather != null
                                                    ? weather.toString()
                                                    : "Loading",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff50899f)),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${"humidity".tr}: ',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1d6280)),
                                                  ),
                                                  Text(
                                                    humidity != null
                                                        ? humidity.toString() +
                                                            " %"
                                                        : "00 %",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${"rainfall".tr}: ',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1d6280)),
                                                  ),
                                                  Text(
                                                    precip_mm != null
                                                        ? precip_mm.toString() +
                                                            " mm"
                                                        : "00 mm",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${"loacation".tr}: ',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1d6280)),
                                                  ),
                                                  Text(
                                                    locality.toString(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "explore_services".tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff50899f)),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                 percentage >= 80
                                      ? Card(
                                          color: Colors.white,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: MaterialButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/tracktor.jpeg"),
                                                      height: 35,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 50.0),
                                                      child: Text(
                                                        "tracktor_book".tr,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff50899f)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              // gettractorDetal();
                                              checkOwner();
                                              getUser();
                                              // setState(() {
                                              //   name:this.name.toString();
                                              //   number:this.number.toString();
                                              // });
                                            },
                                          ),
                                        )
                                      : Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: MaterialButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/tracktor.jpeg"),
                                                      height: 35,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 50.0),
                                                      child: Text(
                                                        "tracktor_book".tr,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff50899f)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                msg: "completeprofilealert".tr,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.black,
                                              );
                                            },
                                          ),
                                        ),
                                 percentage >= 80
                                      ? Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: MaterialButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/tubewell.png"),
                                                      height: 35,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 65.0),
                                                      child: Text(
                                                        "tubebell_book".tr,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff50899f)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              checkTubewellOwner();
                                              getUser();
                                            },
                                          ),
                                        )
                                      : Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: MaterialButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/tubewell.png"),
                                                      height: 35,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 65.0),
                                                      child: Text(
                                                        "tubebell_book".tr,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff50899f)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                msg: "completeprofilealert".tr,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.black,
                                              );
                                            },
                                          ),
                                        ),
                                 percentage >= 80
                                      ? Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: MaterialButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/sellcrop.png"),
                                                      height: 35,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 65.0),
                                                      child: Text(
                                                        "Sell_crop".tr,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff50899f)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Sell_crop1_page()));
                                            },
                                          ),
                                        )
                                      : Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: MaterialButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/sellcrop.png"),
                                                      height: 35,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 65.0),
                                                      child: Text(
                                                        "Sell_crop".tr,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff50899f)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              Fluttertoast.showToast(
                                                msg: "completeprofilealert".tr,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.black,
                                              );
                                            },
                                          ),
                                        )
                                  // Card(
                                  //   elevation: 5,
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(25)),
                                  //   child: MaterialButton(
                                  //     height:
                                  //         MediaQuery.of(context).size.height / 15,
                                  //     minWidth: MediaQuery.of(context).size.width,
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(25)),
                                  //     child: Column(
                                  //       children: [
                                  //         Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           children: [
                                  //             SizedBox(
                                  //               width: 15,
                                  //             ),
                                  //             Image(
                                  //               image: AssetImage(
                                  //                   "assets/crop health.png"),
                                  //               height: 35,
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 65.0),
                                  //               child: Text(
                                  //                 "crop_doctor".tr,
                                  //                 style: TextStyle(
                                  //                     fontSize: 13,
                                  //                     fontWeight: FontWeight.bold,
                                  //                     color: Color(0xff50899f)),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   crop_health()));
                                  //     },
                                  //   ),
                                  // ),
                                  // Card(
                                  //   elevation: 5,
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(25)),
                                  //   child: MaterialButton(
                                  //     height:
                                  //         MediaQuery.of(context).size.height / 15,
                                  //     minWidth: MediaQuery.of(context).size.width,
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(25)),
                                  //     child: Column(
                                  //       children: [
                                  //         Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           children: [
                                  //             SizedBox(
                                  //               width: 15,
                                  //             ),
                                  //             Image(
                                  //               image: AssetImage(
                                  //                   "assets/calendar3.png"),
                                  //               height: 35,
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 65.0),
                                  //               child: Text(
                                  //                 "crop_calender".tr,
                                  //                 style: TextStyle(
                                  //                     fontSize: 13,
                                  //                     fontWeight: FontWeight.bold,
                                  //                     color: Color(0xff50899f)),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   Crop_calendar()));
                                  //     },
                                  //   ),
                                  // ),
                                  // Card(
                                  //   elevation: 5,
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(25)),
                                  //   child: MaterialButton(
                                  //     height:
                                  //         MediaQuery.of(context).size.height / 15,
                                  //     minWidth: MediaQuery.of(context).size.width,
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(25)),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       children: [
                                  //         SizedBox(
                                  //           width: 15,
                                  //         ),
                                  //         Image(
                                  //           image: AssetImage(
                                  //               "assets/crop health.png"),
                                  //           height: 35,
                                  //         ),
                                  //         Padding(
                                  //           padding:
                                  //               const EdgeInsets.only(left: 65.0),
                                  //           child: Text(
                                  //             "crop_advisory".tr,
                                  //             style: TextStyle(
                                  //                 fontSize: 13,
                                  //                 fontWeight: FontWeight.bold,
                                  //                 color: Color(0xff50899f)),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   Crop_Advisory()));
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
      ),
      // bottomSheet:
      bottomNavigationBar: percentage >= 80
          ? Container(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => crop_health()));
                    } else if (_currentIndex == 2) {
                      have_crop_plan == 'no'
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Crop_calendar()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Show_me_plan()));
                    } else if (_currentIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Crop_Advisory()));
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
            )
          : Container(
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Home_page()));
                    } else if (_currentIndex == 1) {
                      Fluttertoast.showToast(
                        msg: "completeprofilealert".tr,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => crop_health()));
                    } else if (_currentIndex == 2) {
                      Fluttertoast.showToast(
                        msg: "completeprofilealert".tr,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Show_me_plan()));
                    } else if (_currentIndex == 3) {
                      Fluttertoast.showToast(
                        msg: "completeprofilealert".tr,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Crop_Advisory()));
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
