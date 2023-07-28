import 'dart:convert';

import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/Tubewell_All_model/customer_list_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/Tubewell_All_model/fill_tubewell_custommer_detail.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/tubwell_send_reminder.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/view_all_tubewell_customer.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../../crop_health_page.dart';

class Add_Customer_Tubewell extends StatefulWidget {
  Add_Customer_Tubewell(
      {Key? key, this.name, this.number, this.user_mobile, this.c_name})
      : super(key: key);
  String? name, number, user_mobile, c_name;
  @override
  State<Add_Customer_Tubewell> createState() => _Add_Customer_TubewellState();
}

class _Add_Customer_TubewellState extends State<Add_Customer_Tubewell> {
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  String? name, t_num;

  Future gettubewellDetail() async {
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
    var res = jsonDecode(response.body)['response'];
    setState(() {
      name = res['onwer_name'];
      t_num = res['onwer_tractno'];
      print(res.toString() + "@@@@@@");
    });
  }

  bool loading = false;
  String? username;
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
      username = res["name"];
      loading = false;
    });
    print(username);
  }

  var total_due, advance;
  Future total_ownwe_money() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tubewell_owner_total_money");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        total_due = res['total_due'];
        advance = res['total_advance'];
        print(res.toString() + "@@@@@@");
      });
    }
  }

  Future<List<CustomerResponse>> get_tubewell_customer_list() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    print(user_id);
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tubewell_customer_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      print(data.toString());
      return data.map((data) => CustomerResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  String? customer_mobile, customer_name, date;
  List customer = [];
  String? c_name, mobile, customer_id;
  Future search_customer(String editText) async {
    Map data = {
      'user_name': editText,
    };
    String? msg;
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/search_user_by_mobile");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    msg = jsonDecode(response.body)['status_message'];
    if (response.statusCode == 200) {
      setState(() {
        customer = res;
        c_name = res['name'];
        mobile = res['mobile'];
        customer_id = res['user_id'];
        print(res.toString() + "@@@@@@");
        print(msg.toString() + "MMMM");
      });
    }
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
      mainimg = res['img'];
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
    total_ownwe_money();
    // search_customer();
    gettubewellDetail();
    // get_customer_list();
    getProfilegetProfile();
  }

  TextEditingController search = TextEditingController();
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    loading
                        ? CircularProgressIndicator()
                        : Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                username == 'null'
                                    ? Text(
                                        'Hello___',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff50899f)),
                                      )
                                    : Text(
                                        'Hello___ ${username!}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff50899f)),
                                      )
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width*0.9,
                      // height: 100,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\u{20B9}" + advance.toString(),
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.green),
                                  ),
                                  Text(
                                    "total_advance".tr,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 1,
                              color: Colors.black,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\u{20B9}" + total_due.toString(),
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.red),
                                  ),
                                  Text(
                                    "${"total_due".tr}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 1,
                              color: Colors.black,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            View_All_Tubewell_Customer(
                                              number: t_num.toString(),
                                            )));
                              },
                              child: Center(child: Text("view_all".tr)),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1)),
                      child: TextFormField(
                        onSaved: (searchBoxEditor) {
                          search_customer(searchBoxEditor!);
                        },
                        // onChanged: search_customer(),
                        controller: search,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "serch_customer".tr,
                            contentPadding: EdgeInsets.all(8),
                            hintStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Tubewell_Customer_Details()));
                                },
                                child: Text("add_customer".tr)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FutureBuilder<List<CustomerResponse>>(
                          future: get_tubewell_customer_list(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            // if (!snapshot.data == null) {
                            //   return Center(child: Text('No Data'),);
                            // }
                            else {
                              List<CustomerResponse>? data = snapshot.data;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  child: ListView.builder(
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: data!.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        String? postion = data[index]
                                            .tw_cstmr_name
                                            .toString();
                                        if (search.text.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 0, 4, 4),
                                            child: GestureDetector(
                                              onTap: () {
                                                print(data[index]
                                                    .tw_cstmr_id
                                                    .toString());
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Tubewell_Send_Reminder(
                                                              farmerName: data[
                                                                      index]
                                                                  .tw_cstmr_name
                                                                  .toString(),
                                                              farmnerNumber: data[
                                                                      index]
                                                                  .tw_cstmr_number
                                                                  .toString(),
                                                              totalAmount:
                                                                  total_due
                                                                      .toString(),
                                                              totalAdvance:
                                                                  advance
                                                                      .toString(),
                                                              owner_customer_id:
                                                                  data[index]
                                                                      .tw_cstmr_userID
                                                                      .toString(),
                                                            )));
                                              },
                                              child: Container(
                                                height: 70,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 60,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: Icon(
                                                                  Icons.face)),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              data[index]
                                                                  .tw_cstmr_name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xff50899f)),
                                                            ),
                                                            Text(
                                                              data[index]
                                                                  .tw_cstmr_number
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xff50899f)),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (postion
                                            .toLowerCase()
                                            .contains(
                                                search.text.toLowerCase())) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Tubewell_Send_Reminder(
                                                            owner_customer_id:
                                                                data[index]
                                                                    .tw_cstmr_id,
                                                          )));
                                            },
                                            child: Container(
                                              height: 70,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(width: 1)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: Icon(
                                                                Icons.face)),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            data[index]
                                                                .tw_cstmr_name
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff50899f)),
                                                          ),
                                                          Text(
                                                            data[index]
                                                                .tw_cstmr_number
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff50899f)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),
                              );
                            }
                          }),
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
