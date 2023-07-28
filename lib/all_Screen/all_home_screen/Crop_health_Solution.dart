import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Home_Page.dart';

class crop_health_Solution extends StatefulWidget {
  const crop_health_Solution({Key? key}) : super(key: key);

  @override
  State<crop_health_Solution> createState() => _crop_health_SolutionState();
}

class _crop_health_SolutionState extends State<crop_health_Solution> {
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
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

  List getdetails = [];
  String? get_details;
  String? title;
  Future getDetails() async {
    Map data = {
      'discease_id': 'DISES600CRP9683389',
    };
    var data1 = jsonEncode(data);
    var uri = Uri.parse('https://doplus.creditmywallet.in.net/api/get_disease');
    final response = await http
        .post(uri, body: data1, headers: {"Content-Type": "Application/json"});
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        getdetails = res;
        print(getdetails.toString() + "dddddd");
      });
    }
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
    getDetails();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
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
                                            backgroundColor: Colors.transparent,
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
                                width: MediaQuery.of(context).size.width / 13,
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
                                              style: TextStyle(fontSize: 8),
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
                                                style: TextStyle(fontSize: 8),
                                              )),
                                          value: 3),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _value = int.parse(value.toString());
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 45,
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
                      )),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Crop Health",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff085272)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                //height: MediaQuery.of(context).size.height/5,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Crop Name :",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1d6280)),
                                                  ),
                                                  Text(
                                                    " 0 mm",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Crop Disease :",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff1d6280)),
                                                  ),
                                                  Text(
                                                    " 0 mm",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image:
                                                  AssetImage("assets/bulb.png"),
                                            )),
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 1.9,
                                child: Column(
                                    //crossAxisAlignment:CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(title.toString()),
                                      Text("Crop Cure or Solution",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff709bad),
                                          )),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomSheet:
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
