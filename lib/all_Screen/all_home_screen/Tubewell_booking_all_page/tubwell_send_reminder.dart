import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/add_tubwell_bill.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'Tubewell_All_model/Tubewel_bill_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../profile_all_screen/Profile_page.dart';
import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../crop_health_page.dart';
import 'Tubewell_All_model/get_customer_tubewell_payment_request_list_model.dart';

class Tubewell_Send_Reminder extends StatefulWidget {
  Tubewell_Send_Reminder({
    Key? key,
    this.owner_customer_id,
    this.farmerName,
    this.farmnerNumber,
    this.totalAdvance,
    this.totalAmount,
  }) : super(key: key);
  String? owner_customer_id;
  String? farmerName;
  String? farmnerNumber;
  String? totalAdvance;
  String? totalAmount;

  @override
  State<Tubewell_Send_Reminder> createState() => _Tubewell_Send_ReminderState();
}

class _Tubewell_Send_ReminderState extends State<Tubewell_Send_Reminder> {
  TextEditingController payment = TextEditingController();
  bool isChecked = true;
  int? Car;

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
    g.Get.back();
    g.Get.updateLocale(locale);
  }

  String? total_advance, total_due, payment_type;
  bool loading = false;

  Future total_customer_money() async {
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
        "https://doplus.creditmywallet.in.net/api/get_customer_tubewell_total_money");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    print(res);
    if (response.statusCode == 200) {
      setState(() {
        // total_due = res['total_due'];
        total_advance = res['advance'].toString();
        total_due = res['total_due'].toString();

        loading = false;

        // print(res.toString() + "@@@@@@");
      });
    }
  }

  Future<List<CustomerTubewellPaymentResponse>>
      get_customer_tubewell_payment_request_list() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');

    Map data = {
      'user_id': widget.owner_customer_id.toString(),
    };
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_customer_tubewell_payment_request_list");
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      setState(() {
        loading = false;
      });
      List<dynamic> data = map["response"];
      return data
          .map((data) => CustomerTubewellPaymentResponse.fromJson(data))
          .toList();
    } else {
      throw Exception('unexpected error occurred');
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

  @override
  void initState() {
    total_customer_money();
    getUser();
    // TODO: implement initState
    super.initState();
  }

  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: loading
              ? Center(child: CircularProgressIndicator())
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
                                        color: Colors.white,
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
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${"farmer_Name".tr}  ${widget.farmerName!}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff50899f)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${"farmer_no".tr}  ${widget.farmnerNumber!}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff50899f)),
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
                                  border: Border.all(width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\u{20B9}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                "  ${total_advance!}",
                                                // "total_advance".tr + widget.totalAdvance!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${"total_advance".tr}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 50,
                                      color: Colors.black,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\u{20B9}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                "  ${total_due!}",
                                                // "total_advance".tr + widget.totalAdvance!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${"total_due".tr}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Add_Tubewell_bill(
                                      farmerName: widget.farmerName.toString(),
                                      farmnerNumber:
                                          widget.farmnerNumber.toString(),
                                      totalAmount:
                                          widget.totalAmount.toString(),
                                      totalAdvance:
                                          widget.totalAdvance.toString(),
                                      owner_customer_id:
                                          widget.owner_customer_id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(width: 1)),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
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
                              height: 20,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(15),
                              //     border: Border.all(width: 1)),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FutureBuilder<
                                      List<CustomerTubewellPaymentResponse>>(
                                  future:
                                      get_customer_tubewell_payment_request_list(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      List<CustomerTubewellPaymentResponse>?
                                          data = snapshot.data;
                                      return Container(
                                        // height: MediaQuery.of(context).size.height*0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                              physics: ScrollPhysics(),
                                              itemCount: data!.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: data[index]
                                                                .currentDue !=
                                                            0
                                                        ? Card(
                                                            shadowColor: data[
                                                                            index]
                                                                        .status
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
                                                                                Share.share('Hi! Download the SHASY MITRA app & pay your bills\n https://shorturl.at/dgiH7', subject: 'SHASY MITRA');
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
                                                                                data[index].billId.toString(),
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
                                                                                "Type",
                                                                                style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w700),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Text(
                                                                                ": Tubewell",
                                                                                style: TextStyle(fontSize: 11, color: Color(0xff085272)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              '${'date'.tr} - ${data[index].date.toString()}',
                                                                              style: TextStyle(fontSize: 11, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                                            ),
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
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "Name".tr,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "Start-Time",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "End-Time",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "rate".tr,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "Hrs",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Divider(),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            data[index].name.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            data[index].startTime.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            data[index].endTime.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            data[index].rate.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            data[index].hours.toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Color(0xff085272),
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      ],
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
                                                                              "Total  Amount: Rs. " + data[index].total.toString(),
                                                                              style: TextStyle(fontSize: 12, color: Color(0xff3DBA3D), fontWeight: FontWeight.w500),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            data[index].status.toString() == "1"
                                                                                ? Text(
                                                                                    "Curent Due: Rs. " + data[index].currentDue.toString(),
                                                                                    style: TextStyle(fontSize: 10, color: Color(0xff43567B)),
                                                                                  )
                                                                                : Container(),
                                                                          ],
                                                                        ),
                                                                        data[index].status.toString() ==
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
                                                                                                        data[index].onwerName.toString(),
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
                                                                                                    Text('Partial_Payment_Collected'.tr, style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500)),
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
                                                                                                            payment.text = data[index].currentDue.toString();
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
                                                                                                          "Payment Due:" + data[index].toString(),
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
                                                                                                                  'bill_id': data[index].billId.toString(),
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
                                                                                                                  Fluttertoast.showToast(msg: 'Bill_Updated_Successfully'.tr, backgroundColor: Colors.green, gravity: ToastGravity.CENTER);
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
                                                                                                              'Make_Full_Payment'.tr,
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
                                                                                                                  'bill_id': data[index].billId.toString(),
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
                                                                                                                  Fluttertoast.showToast(msg: 'Bill_Updated_Successfully'.tr, backgroundColor: Colors.green, gravity: ToastGravity.CENTER);
                                                                                                                } else {
                                                                                                                  Fluttertoast.showToast(msg: msg.toString(), backgroundColor: Colors.red, gravity: ToastGravity.CENTER, textColor: Colors.white);
                                                                                                                }
                                                                                                                Navigator.pop(context);
                                                                                                              } else {
                                                                                                                Fluttertoast.showToast(msg: 'Payment_is_Empty'.tr, backgroundColor: Colors.red, gravity: ToastGravity.CENTER);
                                                                                                              }
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              "Update".tr,
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
                                                                                "Paid".tr,
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
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
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
