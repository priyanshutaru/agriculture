import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/owner_home_page.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../crop_health_page.dart';

class Tractor_owner_detail extends StatefulWidget {
  const Tractor_owner_detail({Key? key}) : super(key: key);
  @override
  State<Tractor_owner_detail> createState() => _Tractor_owner_detailState();
}

class _Tractor_owner_detailState extends State<Tractor_owner_detail> {
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  TextEditingController _upi = TextEditingController();
  TextEditingController _t_number = TextEditingController();
  // TextEditingController _name = TextEditingController();
  // TextEditingController _number = TextEditingController();

  String? name, number;
  // Future getUser() async {
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   Map data = {
  //     'user_id': user_id.toString(),
  //   };
  //   var data1 = jsonEncode(data);
  //   var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_user");
  //   final response = await http.post(url,
  //       headers: {"Content-Type": "Application/json"}, body: data1);
  //   var res = jsonDecode(response.body);
  //   setState(() {
  //     name = res["name"];
  //     number = res['mobile'];
  //     print(name.toString() + "%%%%%%%%%%%%%%%%");
  //   });
  // }

  String? u_name, t_num;
  Future gettractorDetail() async {
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
    var res = jsonDecode(response.body)['response'];
    setState(() {
      u_name = res['user/onwer_name'];
      t_num = res['user/onwer_tractno'];
      print(res.toString() + "@@@@@@");
    });
  }

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
    if (res == 'Yes') {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Add_Customer()));
      });
    }
  }

  String? tractor;
  Future Add_Tractor() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
      'owner_name': name.toString(),
      'owner_number': number.toString(),
      'tractor_number': _t_number.text.toString(),
      'upi_id': _upi.text.toString(),
    };
    var msg;
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/add_tractor_details");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    msg = jsonDecode(response.body)['status_message'];
    if (response.statusCode == 200) {
      if (msg == 'Success') {
        // setState(() {
        print("%%%%%%%%%%%%" + res.toString());
        // tractor=res['response']['user/onwer_tractno'];
        print(tractor.toString() + "%%%%%%%tractor%%%%%%%%%");
        print(response.toString() + "%%%%%%%%%%%%%%%%");
        // if(res==)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Add_Customer(
                      name: name.toString(),
                    )));
        // });
      }
    }
    // showDialog(context: context, builder: (BuildContext){
    //   return AlertDialog(
    //     content: Container(
    //       height: 100,
    //       child: Column(
    //         children: [
    //           CircleAvatar(
    //             radius: 10,
    //             backgroundColor: Colors.red,
    //             child: Icon(Icons.pending,color: Colors.white,),
    //           ),
    //           SizedBox(height: 10,),
    //           Text("Pending......",style: TextStyle(fontSize: 12,color: Colors.red),),
    //           SizedBox(height: 10,),
    //           Text(msg.toString(),style: TextStyle(fontSize: 12,color: Colors.red),),
    //         ],
    //       ),
    //     ),
    //   );
    // });
  }

  String? mainimg;
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
    getUser();
    // gettractorDetail();
    gettractorDetal();
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
                        "Fill Your Details",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff50899f)),
                      )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1.5)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Container(
                                  child: Row(
                                children: [
                                  Container(
                                      child: Text(
                                    "Name :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff50899f)),
                                  )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      // border: Border.all(width: 1)
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      // controller: _name,
                                      decoration: InputDecoration(
                                          hintText: name.toString(),
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Container(
                                  child: Row(
                                children: [
                                  Container(
                                      child: Text(
                                    "Number :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff50899f)),
                                  )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      // border: Border.all(width: 1)
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      // controller: _number,
                                      decoration: InputDecoration(
                                          hintText: number.toString(),
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Container(
                                  child: Row(
                                children: [
                                  Container(
                                      child: Text(
                                    "UPI Id :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff50899f)),
                                  )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      // border: Border.all(width: 1)
                                    ),
                                    child: TextFormField(
                                      controller: _upi,
                                      decoration: InputDecoration(
                                          hintText: "Enter Your UPI id ",
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Container(
                                  child: Row(
                                children: [
                                  Container(
                                      // width: 100,
                                      child: Text(
                                    "Tractor No. :",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff50899f)),
                                  )),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        // border: Border.all(width: 1)
                                      ),
                                      child: TextFormField(
                                        controller: _t_number,
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: InputDecoration(
                                            hintText: "Enter Your Tractor No.",
                                            hintStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                            contentPadding: EdgeInsets.all(10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            // Container(
                            //   height:40,
                            //   width: MediaQuery.of(context).size.width*0.8,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(8),
                            //     // border: Border.all(width: 1)
                            //   ),
                            //   child: TextFormField(
                            //     decoration: InputDecoration(
                            //       hintText: "Enter Your UPI id ",
                            //         hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff50899f)),
                            //       contentPadding: EdgeInsets.all(10),
                            //       border: OutlineInputBorder(
                            //         borderSide: BorderSide.none,
                            //       )
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 10,),
                            // Container(
                            //   height:40,
                            //   width: MediaQuery.of(context).size.width*0.8,
                            //   decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(8),
                            //       border: Border.all(width: 1)
                            //   ),
                            //   child: TextFormField(
                            //     decoration: InputDecoration(
                            //         hintText: "Enter Tractor Number",
                            //         hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff50899f)),
                            //         contentPadding: EdgeInsets.all(10),
                            //         border: OutlineInputBorder(
                            //           borderSide: BorderSide.none,
                            //         )
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        Add_Tractor();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Customer(
                        //   name: name.toString(),
                        //   number: number.toString(),
                        // )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(width: 1.5)),
                              child: Center(
                                child: Text(
                                  "save".tr,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff50899f)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  var _currentIndex = 0;
}
