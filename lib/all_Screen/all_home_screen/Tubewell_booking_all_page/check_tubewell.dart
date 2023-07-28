import 'dart:convert';

import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/pay_by_customer.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/tractor_owner.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/pay_amount.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/tubewell_owner.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../crop_health_page.dart';

class CheckTubewell extends StatefulWidget {
  CheckTubewell({Key? key, this.name, this.number}) : super(key: key);
  String? name, number;
  @override
  State<CheckTubewell> createState() => _CheckTubewellState();
}

class _CheckTubewellState extends State<CheckTubewell> {
  Future updateTubewellYes() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {'owner_id': user_id.toString(), 'tubewell_status': '0'};
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/update_tubewell_status");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (res == '0') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Pay_Amount()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Tubewell_owner_detail()));
      }
    }
    print(res.toString() + "hgdggdgdfgsdfgsdfshg");
  }

  Future updateTubewellNo() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {'owner_id': user_id.toString(), 'tubewell_status': '1'};
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/update_tubewell_status");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (res == '0') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Tubewell_owner_detail()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Pay_Amount()));
      }
      print(res.toString() + "hgdggdgdfgsdfgsdfshg");
    }
  }

  Future getValue() async {
    final pref = await SharedPreferences.getInstance();
    var num = pref.getString('mobile');
    print(num.toString() + ">>>>>hjsdjfhsafdsghdfsagdfsadgsadfsfd");
  }

  int _currentIndex = 0;
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

  String? number, mainimg;
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
      number = res['mobile'];
      mainimg = res['img'].toString();
      print(user_id.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  int _value = 1;
  @override
  void initState() {
    super.initState();
    getValue();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1.5)),
                    child: Center(
                        child: Text(
                      "Do you have a Tubewell ?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff50899f)),
                    )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          updateTubewellYes();
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1.5)),
                          child: Center(
                              child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff50899f)),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          updateTubewellNo();
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1.5)),
                          child: Center(
                              child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff50899f)),
                          )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ),
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
