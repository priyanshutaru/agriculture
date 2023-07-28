import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/add_customer_bill.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart' as g;

import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../crop_health_page.dart';
import 'customer_payment_list_model.dart';

class Send_Reminder extends StatefulWidget {
  Send_Reminder({Key? key, this.user_mobile, this.name, this.c_id, this.date1})
      : super(key: key);
  String? user_mobile;
  String? name;
  String? c_id, date1;

  @override
  State<Send_Reminder> createState() => _Send_ReminderState();
}

class _Send_ReminderState extends State<Send_Reminder> {
  bool isChecked = true;
  int? Car;
  TextEditingController payment = TextEditingController();
  String? payment_type;

  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  Future<List<Data>> customer_paymet_list() async {
    setState(() {
      loading = true;
    });
    Map data = {
      'user_id': widget.c_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_customer_payment_request_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      setState(() {});
      return data.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  String? total_due, advance;
  Future total_money() async {
    setState(() {
      loading = true;
    });
    // final pref = await SharedPreferences.getInstance();
    // var user_id = pref.getString('user_id');
    Map data = {'user_id': widget.c_id.toString()};
    String? msg;
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_customer_tractor_total_money");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    msg = jsonDecode(response.body)['status_message'];
    if (response.statusCode == 200) {
      setState(() {
        total_due = res['total_due'].toString();
        advance = res['advance'].toString();
        loading = false;
        print(customer_id.toString() + "@@@@@@");
        print(msg.toString() + "MMMM");
      });
    }
  }

  bool loading = false;

  String? name, mobile, customer_id;
  Future search_customer() async {
    Map data = {
      'user_mobile': widget.user_mobile,
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
        name = res['name'];
        mobile = res['mobile'];
        customer_id = res['user_id'];
        // _setCustomerId(customer_id);
        print(res.toString() + "@@@@@@");
        print(msg.toString() + "MMMM");
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Send_Reminder()));
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
      mainimg = res['img'].toString();
      print(user_id.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    g.Get.back();
    g.Get.updateLocale(locale);
  }

  int _value = 1;
  @override
  void initState() {
    super.initState();
    // setState(() {
    total_money();
    getUser();
    // });
    // search_customer();
    // customer_paymet_list();
    // _setCustomerId(customer_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
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
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "farmer_Name".tr,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff50899f)),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        ": ${widget.name.toString()}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "farmer_no".tr,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff50899f)),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        ": ${widget.user_mobile.toString()}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            // height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\u{20B9}" + advance.toString(),
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 20,
                                              color: Colors.green),
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
                                    width: 1,
                                    height: 50,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          "\u{20B9}" + total_due.toString(),
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 20,
                                              color: Colors.red),
                                        ),
                                        Text(
                                          "total_due".tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Add_Customer_bill(
                                            user_mobile:
                                                widget.user_mobile.toString(),
                                            name: widget.name.toString(),
                                            c_id: widget.c_id.toString(),
                                            date2: widget.date1.toString(),
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40,
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(width: 1)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          "+ ${'add_new_entry'.tr}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff50899f)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: FutureBuilder<List<Data>>(
                                future: customer_paymet_list(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: Text("No_Data_Found".tr));
                                  } else {
                                    List<Data>? data = snapshot.data;
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: ListView.builder(
                                          physics: ScrollPhysics(),

                                          // scrollDirection: Axis.horizontal,
                                          itemCount: data!.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child:
                                                    data[index].tCurrentDue != 0
                                                        ? Card(
                                                            shadowColor: data[
                                                                            index]
                                                                        .tPaidStatus
                                                                        .toString() ==
                                                                    "1"
                                                                ? Colors.red
                                                                : Colors.green,
                                                            elevation: 8,
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                // border: Border.all(
                                                                //   width: 0,
                                                                // )
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10,
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.25,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              // Text(
                                                                              //   "Unit",
                                                                              //   style: TextStyle(
                                                                              //       fontSize:
                                                                              //           13,
                                                                              //       color: Colors
                                                                              //           .black,
                                                                              //       fontWeight:
                                                                              //           FontWeight.w700),
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   height:
                                                                              //       10,
                                                                              // ),
                                                                              // Text(
                                                                              //   data[index]
                                                                              //       .createdDate
                                                                              //       .toString(),
                                                                              //   style: TextStyle(
                                                                              //       fontSize:
                                                                              //           11,
                                                                              //       color: Colors
                                                                              //           .black,
                                                                              //       fontWeight:
                                                                              //           FontWeight.w500),
                                                                              // )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.3,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              // Text(
                                                                              //   "Balance",
                                                                              //   style: TextStyle(
                                                                              //       fontSize:
                                                                              //           13,
                                                                              //       color: Colors
                                                                              //           .black,
                                                                              //       fontWeight:
                                                                              //           FontWeight.w700),
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   height:
                                                                              //       10,
                                                                              // ),
                                                                              // Text(
                                                                              //   "\u{20B9}" +
                                                                              //       data[index]
                                                                              //           .tCurrentDue
                                                                              //           .toString(),
                                                                              //   style: TextStyle(
                                                                              //       fontStyle: FontStyle
                                                                              //           .italic,
                                                                              //       fontSize:
                                                                              //           11,
                                                                              //       color:
                                                                              //           Colors.red),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              setState(() {
                                                                                Share.share('check tubewel bill\n https://agriculture.page.link/bill_share', subject: 'Look what I made!');
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: Color(0xff66ad2d), borderRadius: BorderRadius.circular(10)),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  "Share".tr,
                                                                                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    // SizedBox(height: 10,),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "#" +
                                                                                data[index].tractorBillId.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          Text(
                                                                              "Created_On".tr + data[index].createdDate.toString(),
                                                                              style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w500)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    // SizedBox(
                                                                    //   height: 10,
                                                                    // ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Type".tr,
                                                                                style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w700),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Text(
                                                                                ": ${'Tractor'.tr}",
                                                                                style: TextStyle(fontSize: 11, color: Color(0xff085272)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Spacer(),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Machine".tr,
                                                                                style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w700),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Text(
                                                                                ': ' + data[index].tMachineryUsed.toString(),
                                                                                style: TextStyle(fontSize: 11, color: Color(0xff085272)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Divider(),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        // Container(
                                                                        //   width: MediaQuery.of(
                                                                        //               context)
                                                                        //           .size
                                                                        //           .width /
                                                                        //       6,
                                                                        //   child: Text(
                                                                        //     "Name",
                                                                        //     style: TextStyle(
                                                                        //         fontSize:
                                                                        //             11,
                                                                        //         color: Color(
                                                                        //             0xff085272),
                                                                        //         fontWeight:
                                                                        //             FontWeight
                                                                        //                 .w700),
                                                                        //   ),
                                                                        // ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 5.4,
                                                                          child:
                                                                              Text(
                                                                            "Start_date".tr,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 7,
                                                                          child:
                                                                              Text(
                                                                            "Area_Size".tr,
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 8,
                                                                          child:
                                                                              Text(
                                                                            "rate".tr,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 6,
                                                                          child:
                                                                              Text(
                                                                            "Area Type",
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Divider(),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.85,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 5.4,
                                                                            child:
                                                                                Text(
                                                                              data[index].tStartDate.toString(),
                                                                              style: TextStyle(fontSize: 10, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                          // Container(
                                                                          //   width: MediaQuery.of(context).size.width/5.4,
                                                                          //   child: Text(data[index].tEndDate.toString(),
                                                                          //     style: TextStyle(fontSize:10,
                                                                          //         color: Color(0xff085272),
                                                                          //         fontWeight: FontWeight.w500),),
                                                                          // ),
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 6,
                                                                            child:
                                                                                Text(
                                                                              data[index].tUsage.toString(),
                                                                              //     +
                                                                              // "-"
                                                                              // +
                                                                              // data[index]
                                                                              //     .tUnit
                                                                              //     .toString(),
                                                                              style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 10,
                                                                            child:
                                                                                Text(
                                                                              '\u{20B9} ' + data[index].tHours.toString(),
                                                                              style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 6,
                                                                            child:
                                                                                Text(
                                                                              data[index].unit_name.toString(),
                                                                              style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "Total  Amount: Rs. " + data[index].tTotal.toString(),
                                                                              style: TextStyle(fontSize: 12, color: Color(0xff3DBA3D), fontWeight: FontWeight.w500),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            data[index].tPaidStatus.toString() == "1"
                                                                                ? Text(
                                                                                    "Curent Due: Rs. " + data[index].tCurrentDue.toString(),
                                                                                    style: TextStyle(fontSize: 10, color: Color(0xff43567B)),
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                        data[index].tPaidStatus.toString() ==
                                                                                "1"
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return StatefulBuilder(builder: (context, setState) {
                                                                                        return AlertDialog(
                                                                                          contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                                                          insetPadding: EdgeInsets.symmetric(horizontal: 15),
                                                                                          //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                          title: Row(
                                                                                            children: [
                                                                                              Icon(
                                                                                                Icons.library_books,
                                                                                                color: Color(0xff40BDEB),
                                                                                              ),
                                                                                              Text(
                                                                                                "Update Payment Status",
                                                                                                style: TextStyle(fontSize: 15, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                          content: SingleChildScrollView(
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        "${'Name'.tr} :",
                                                                                                        // "Name : ",
                                                                                                        style: TextStyle(fontSize: 14, color: Color(0xff085272)),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 8,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        data[index].tName.toString(),
                                                                                                        style: TextStyle(fontSize: 14, color: Color(0xff085272)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      height: 32,
                                                                                                      width: 32,
                                                                                                      child: Radio(
                                                                                                        value: 1,
                                                                                                        activeColor: Color(0xff48719A),
                                                                                                        groupValue: Car,
                                                                                                        onChanged: (value) {
                                                                                                          setState(() {
                                                                                                            Car = value! as int?;
                                                                                                            isChecked = true;
                                                                                                            if (Car == 1) {
                                                                                                              setState(() {
                                                                                                                payment_type = "0";
                                                                                                              });
                                                                                                            }
                                                                                                          });
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    //SizedBox( width: 3,),
                                                                                                    Text('Partial_Payment_Collected.'.tr, style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500)),
                                                                                                    // SizedBox(width: 3,),
                                                                                                    SizedBox(
                                                                                                      height: 30,
                                                                                                      width: 30,
                                                                                                      child: Radio(
                                                                                                        value: 2,
                                                                                                        activeColor: Color(0xff48719A),
                                                                                                        groupValue: Car,
                                                                                                        onChanged: (value) {
                                                                                                          setState(() {
                                                                                                            Car = value! as int?;
                                                                                                            isChecked = false;
                                                                                                            payment.text = data[index].tCurrentDue.toString();
                                                                                                            if (Car == 2) {
                                                                                                              setState(() {
                                                                                                                payment_type = "1";
                                                                                                              });
                                                                                                            }
                                                                                                          });
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    // SizedBox(width: 5,),
                                                                                                    Text('Full_Payment_Collected'.tr, style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500)),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                Visibility(
                                                                                                  visible: isChecked,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Container(
                                                                                                        width: MediaQuery.of(context).size.width / 2.4,
                                                                                                        child: TextFormField(
                                                                                                          controller: payment,
                                                                                                          keyboardType: TextInputType.number,
                                                                                                          decoration: InputDecoration(
                                                                                                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                                                                                            fillColor: Colors.white,
                                                                                                            filled: false,
                                                                                                            hintText: "Payment_Collected".tr,
                                                                                                            hintStyle: TextStyle(
                                                                                                              fontSize: 11,
                                                                                                            ),
                                                                                                            enabledBorder: OutlineInputBorder(
                                                                                                              borderSide: BorderSide(width: 1, color: Colors.black45),
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                            focusedBorder: OutlineInputBorder(
                                                                                                              borderSide: BorderSide(width: 1, color: Colors.black45),
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                            border: InputBorder.none,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Container(
                                                                                                        width: MediaQuery.of(context).size.width / 2.4,
                                                                                                        alignment: Alignment.center,
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(color: Colors.black45),
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                        ),
                                                                                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                                                        child: Text(
                                                                                                          "${'Payment_Due'.tr}:" + data[index].tCurrentDue.toString(),
                                                                                                          style: TextStyle(fontSize: 11),
                                                                                                        )),
                                                                                                  ]),
                                                                                                ),
                                                                                                Visibility(
                                                                                                  visible: isChecked == false,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Card(
                                                                                                      elevation: 3,
                                                                                                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                                      child: Container(
                                                                                                        alignment: Alignment.center,
                                                                                                        height: 45,
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                                          color: Color(0xff65AC2B),
                                                                                                        ),
                                                                                                        child: MaterialButton(
                                                                                                            height: 45,
                                                                                                            minWidth: MediaQuery.of(context).size.width,
                                                                                                            highlightColor: Colors.redAccent,
                                                                                                            onPressed: () async {
                                                                                                              if (payment.text.isNotEmpty) {
                                                                                                                var dio = Dio();
                                                                                                                var formData = FormData.fromMap({
                                                                                                                  'bill_id': data[index].tractorBillId.toString(),
                                                                                                                  'due_amount': payment.text.toString(),
                                                                                                                  'payment_type': payment_type.toString(),
                                                                                                                });
                                                                                                                var response = await dio.post('https://doplus.creditmywallet.in.net/api/add_tractor_bill_collection', data: formData);
                                                                                                                print(formData.fields.toString() + "^^^^^^^^^^^^^^^^^^^");
                                                                                                                print("response ====>>>" + response.toString());
                                                                                                                var res = response.data;
                                                                                                                String msg = res['status_message'];

                                                                                                                print("bjhgbvfjhdfgbfu====>..." + msg.toString());
                                                                                                                if (msg == "Bill Updated Successfully") {
                                                                                                                  Fluttertoast.showToast(msg: 'Bill Updated Successfully', backgroundColor: Colors.green, gravity: ToastGravity.CENTER);
                                                                                                                  Navigator.pop(context);
                                                                                                                } else {
                                                                                                                  Fluttertoast.showToast(msg: msg.toString(), backgroundColor: Colors.red, gravity: ToastGravity.CENTER, textColor: Colors.white);
                                                                                                                  Navigator.pop(context);
                                                                                                                }
                                                                                                              }
                                                                                                              // else {
                                                                                                              //   Fluttertoast.showToast(msg: 'Something Went Wrong', backgroundColor: Colors.red, gravity: ToastGravity.CENTER);
                                                                                                              // }
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              "Make_Full_Payment".tr,
                                                                                                              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                            )),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 15,
                                                                                                ),
                                                                                                Visibility(
                                                                                                  visible: isChecked,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Card(
                                                                                                      elevation: 3,
                                                                                                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                                      child: Container(
                                                                                                        alignment: Alignment.center,
                                                                                                        height: 45,
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                                          color: Color(0xff65AC2B),
                                                                                                        ),
                                                                                                        child: MaterialButton(
                                                                                                            height: 45,
                                                                                                            minWidth: MediaQuery.of(context).size.width,
                                                                                                            highlightColor: Colors.redAccent,
                                                                                                            onPressed: () async {
                                                                                                              if (payment.text.isNotEmpty) {
                                                                                                                var dio = Dio();
                                                                                                                var formData = FormData.fromMap({
                                                                                                                  'bill_id': data[index].tractorBillId.toString(),
                                                                                                                  'due_amount': payment.text.toString(),
                                                                                                                  'payment_type': payment_type.toString(),
                                                                                                                });
                                                                                                                var response = await dio.post('https://doplus.creditmywallet.in.net/api/add_tractor_bill_collection', data: formData);
                                                                                                                print(formData.fields.toString() + "^^^^^^^^^^^^^^^^^^^");
                                                                                                                print("response ====>>>" + response.toString());
                                                                                                                var res = response.data;
                                                                                                                String msg = res['status_message'];
                                                                                                                print("bjhgbvfjhdfgbfu====>..." + msg.toString());
                                                                                                                if (msg == "Bill Updated Successfully") {
                                                                                                                  Fluttertoast.showToast(msg: 'Bill Updated Successfully', backgroundColor: Colors.green, gravity: ToastGravity.CENTER);
                                                                                                                } else {
                                                                                                                  Fluttertoast.showToast(msg: msg.toString(), backgroundColor: Colors.red, gravity: ToastGravity.CENTER, textColor: Colors.white);
                                                                                                                }
                                                                                                                Navigator.pop(context);
                                                                                                              } else {
                                                                                                                Fluttertoast.showToast(msg: 'Payment_is_Empty'.tr, backgroundColor: Colors.red, gravity: ToastGravity.CENTER);
                                                                                                              }
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              "Update",
                                                                                                              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                            )),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 15,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      });
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  width: MediaQuery.of(context).size.width / 3.3,
                                                                                  padding: EdgeInsets.all(8),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    color: Color(0xff40BDEB),
                                                                                  ),
                                                                                  child: Text(
                                                                                    "Update_Payment".tr,
                                                                                    style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                "Paid",
                                                                                style: TextStyle(fontSize: 12, color: Color(0xff3DBA3D), fontWeight: FontWeight.w500),
                                                                              ),
                                                                        // data[index]
                                                                        //             .tPaidStatus
                                                                        //             .toString() !=
                                                                        //         "1"
                                                                        //     ? Text("")
                                                                        //     : IconButton(
                                                                        //         onPressed:
                                                                        //             () async {
                                                                        //           setState(
                                                                        //               () {
                                                                        //             Share.share(
                                                                        //                 'check tubewel bill\n https://agriculture.page.link/bill_share',
                                                                        //                 subject: 'Look what I made!');
                                                                        //           });
                                                                        //         },
                                                                        //         icon: Icon(
                                                                        //             Icons
                                                                        //                 .share)),
                                                                        // SizedBox(
                                                                        //   width: 5,
                                                                        // )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Text(''));
                                          }),
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
