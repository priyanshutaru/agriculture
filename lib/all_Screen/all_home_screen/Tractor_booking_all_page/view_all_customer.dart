import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/owner_payment_list_model.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class View_All_Customer extends StatefulWidget {
  View_All_Customer({Key? key, this.number}) : super(key: key);
  String? number;
  @override
  State<View_All_Customer> createState() => _View_All_CustomerState();
}

class _View_All_CustomerState extends State<View_All_Customer> {
  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  Future<List<Res>> owner_paymet_list() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tractor_owner_payment_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      setState(() {});
      return data.map((data) => Res.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  List customer_list = [];
  Future owner_paymet() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tractor_owner_payment_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    if (response.statusCode == 200) {
      customer_list = res;
    }
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
        "https://doplus.creditmywallet.in.net/api/get_tractor_owner_tractor_total_money");
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
    // setState(() {
    owner_paymet_list();
    getUser();
    total_ownwe_money();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
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
                                    width:
                                        MediaQuery.of(context).size.width / 13,
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
                                                    style:
                                                        TextStyle(fontSize: 8),
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
                                        MediaQuery.of(context).size.width / 45,
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1)),
                        child: Center(
                            child: Text(
                          "Hello________ !",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff50899f)),
                        )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Image(
                                    image: AssetImage("assets/tracktor.png"),
                                    height: 32,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 50.0, top: 5),
                                  child: Text(
                                    '${widget.number}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff50899f)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                "${'net_balance'.tr} :",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff50899f)),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "\u{20B9}" + advance.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff66ad2d)),
                              )
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 20,),
                      // Container(
                      //   width: MediaQuery.of(context).size.width*0.9,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       FutureBuilder<List<Res>>(
                      //           future: owner_paymet_list(),
                      //           builder:(context, AsyncSnapshot snapshot) {
                      //             List<Res>?data=snapshot.data;
                      //             if (!snapshot.hasData) {
                      //               return Center(child:CircularProgressIndicator());
                      //             } else {
                      //               return Padding(
                      //                 padding: const EdgeInsets.only(bottom: 10),
                      //                 child: Container(
                      //                   height: MediaQuery.of(context).size.height*0.62,
                      //                   child: ListView.builder(
                      //                       scrollDirection: Axis.vertical,
                      //                       shrinkWrap: true,
                      //                       itemCount:data!.length,
                      //                       itemBuilder: (BuildContext ctx, index) {
                      //                        return Padding(
                      //                          padding: const EdgeInsets.only(bottom: 10),
                      //                          child: Container(
                      //                            // height: MediaQuery.of(context).size.height,
                      //                            decoration: BoxDecoration(
                      //                              border: Border.all(width: 0.5),
                      //                              borderRadius: BorderRadius.circular(10)
                      //                            ),
                      //                            child: Card(
                      //                              child: Padding(
                      //                                padding: const EdgeInsets.all(10.0),
                      //                                child: Column(
                      //                                  crossAxisAlignment: CrossAxisAlignment.start,
                      //                                  children: [
                      //                                    Row(
                      //                                      children: [
                      //                                        Text("Transection ID:",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                        Spacer(),
                      //                                        Text(data[index].tractorBillId.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                      ],
                      //                                    ),
                      //                                    Divider(endIndent: 10,indent: 10,),
                      //                                    Row(
                      //                                      crossAxisAlignment: CrossAxisAlignment.start,
                      //                                      children: [
                      //                                        Text("Machinery :",style: TextStyle(fontSize: 14,color: Colors.black),),
                      //                                        Spacer(),
                      //                                        Text(data[index].tMachineryUsed.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                      ],
                      //                                    ),
                      //                                    Divider(endIndent: 10,indent: 10,),
                      //                                    Row(
                      //                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                      children: [
                      //                                        Container(
                      //                                          width: MediaQuery.of(context).size.width*0.25,
                      //                                          child: Column(
                      //                                            crossAxisAlignment: CrossAxisAlignment.start,
                      //                                            children: [
                      //                                              Text("Name",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                              Text(data[index].tName.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                            ],
                      //                                          ),
                      //                                        ),
                      //                                        Container(
                      //                                          width: MediaQuery.of(context).size.width*0.25,
                      //                                          child: Column(
                      //                                            crossAxisAlignment: CrossAxisAlignment.start,
                      //                                            children: [
                      //                                              Text("Phone :",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                              Text(data[index].tMobile.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                            ],
                      //                                          ),
                      //                                        ),
                      //                                        Container(
                      //                                          width: MediaQuery.of(context).size.width*0.25,
                      //                                          child: Column(
                      //                                            crossAxisAlignment: CrossAxisAlignment.start,
                      //                                            children: [
                      //                                              Text("Date :",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                              Text(data[index].createdDate.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                            ],
                      //                                          ),
                      //                                        ),
                      //                                      ],
                      //                                    ),
                      //                                    Divider(endIndent: 10,indent: 10,),
                      //                                    Row(
                      //                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                      children: [
                      //                                        Container(
                      //                                          width: MediaQuery.of(context).size.width*0.25,
                      //                                          child: Column(
                      //                                            crossAxisAlignment: CrossAxisAlignment.start,
                      //                                            children: [
                      //                                              Text("Total Amount",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                              Text("\u{20B9}"+data[index].tTotal.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                            ],
                      //                                          ),
                      //                                        ),
                      //                                        Container(
                      //                                          width: MediaQuery.of(context).size.width*0.25,
                      //                                          child: Column(
                      //                                            crossAxisAlignment: CrossAxisAlignment.start,
                      //                                            children: [
                      //                                              Text("Paid",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                              Text("\u{20B9}"+data[index].tPaidAmt.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                            ],
                      //                                          ),
                      //                                        ),
                      //                                        Container(
                      //                                          width: MediaQuery.of(context).size.width*0.25,
                      //                                          child: Column(
                      //                                            crossAxisAlignment: CrossAxisAlignment.start,
                      //                                            children: [
                      //                                              Text("Current Due",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                      //                                              Text("\u{20B9}"+data[index].tCurrentDue.toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff66ad2d)),),
                      //                                            ],
                      //                                          ),
                      //                                        ),
                      //                                      ],
                      //                                    ),
                      //                                  ],
                      //                                ),
                      //                              ),
                      //                            ),
                      //                          ),
                      //                        );
                      //                       }),
                      //                 ),
                      //               );
                      //             }
                      //           }
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 400,
                        child: FutureBuilder<List<Res>>(
                            future: owner_paymet_list(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<Res>? data = snapshot.data;
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: ListView.builder(
                                      physics: ScrollPhysics(),
                                      itemCount: data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, left: 0, right: 0),
                                          child: Card(
                                            shadowColor: data[index]
                                                        .tPaidStatus
                                                        .toString() ==
                                                    "1"
                                                ? Colors.red
                                                : Colors.green,
                                            elevation: 10,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "#" +
                                                            data[index]
                                                                .tractorBillId
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xff085272),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Text(
                                                          "Created_On".tr +
                                                              data[index]
                                                                  .createdDate
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xff085272),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Type",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            ": Tubewell",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272)),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Machine",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            ': ' +
                                                                data[index]
                                                                    .tMachineryUsed
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            6,
                                                        child: Text(
                                                          "Name".tr,
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xff085272),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5.4,
                                                        child: Text(
                                                          "Start-date",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff085272),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5.3,
                                                        child: Text(
                                                          "End-date",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xff085272),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            7,
                                                        child: Text(
                                                          "unit".tr,
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xff085272),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            8,
                                                        child: Text(
                                                          "Rate",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff085272),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.85,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              6,
                                                          child: Text(
                                                            data[index]
                                                                .tName
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              5.4,
                                                          child: Text(
                                                            data[index]
                                                                .tStartDate
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              5.4,
                                                          child: Text(
                                                            data[index]
                                                                .tEndDate
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              6,
                                                          child: Text(
                                                            data[index]
                                                                    .tUsage
                                                                    .toString() +
                                                                "-" +
                                                                data[index]
                                                                    .tUnit
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              10,
                                                          child: Text(
                                                            '\u{20B9} ' +
                                                                data[index]
                                                                    .tHours
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                    0xff085272),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "${"total_due".tr}: Rs. " +
                                                                data[index]
                                                                    .tTotal
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xff3DBA3D),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          data[index]
                                                                      .tPaidStatus
                                                                      .toString() ==
                                                                  "1"
                                                              ? Text(
                                                                  "Curent Due: Rs. " +
                                                                      data[index]
                                                                          .tCurrentDue
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color(
                                                                          0xff43567B)),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      data[index]
                                                                  .tPaidStatus
                                                                  .toString() ==
                                                              "1"
                                                          ? InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return StatefulBuilder(builder:
                                                                        (context,
                                                                            setState) {
                                                                      return AlertDialog(
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                2,
                                                                            vertical:
                                                                                2),
                                                                        insetPadding:
                                                                            EdgeInsets.symmetric(horizontal: 15),
                                                                        //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                        title:
                                                                            Row(
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
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10))),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Name : ",
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
                                                                              // Row(
                                                                              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              //   children: [
                                                                              //     SizedBox(
                                                                              //       height:32,
                                                                              //       width: 32,
                                                                              //       child: Radio(
                                                                              //         value: 1,
                                                                              //         activeColor: Color(0xff48719A),
                                                                              //         groupValue: Car,
                                                                              //         onChanged: (value) {
                                                                              //           setState(() {
                                                                              //             Car = value!;
                                                                              //             isChecked=true;
                                                                              //             if (Car == 1) {
                                                                              //               setState(() {
                                                                              //                 payment_type="0";
                                                                              //               });
                                                                              //             }
                                                                              //           });
                                                                              //         },
                                                                              //       ),
                                                                              //     ),
                                                                              //     //SizedBox( width: 3,),
                                                                              //     Text('Partial Payment Collected.',
                                                                              //         style: TextStyle(
                                                                              //             fontSize: 11,
                                                                              //             color: Colors .black,
                                                                              //             fontWeight: FontWeight.w500
                                                                              //         )),
                                                                              //     // SizedBox(width: 3,),
                                                                              //     SizedBox(
                                                                              //       height: 30,
                                                                              //       width: 30,
                                                                              //       child: Radio(
                                                                              //         value: 2,
                                                                              //         activeColor: Color(
                                                                              //             0xff48719A),
                                                                              //         groupValue: Car,
                                                                              //         onChanged: (value) {
                                                                              //           setState(() {
                                                                              //             Car =value!;
                                                                              //             isChecked=false;
                                                                              //             if (Car ==2) {
                                                                              //               setState(() {
                                                                              //                 payment_type ="1";
                                                                              //               });
                                                                              //             }
                                                                              //           });
                                                                              //         },
                                                                              //       ),
                                                                              //     ),
                                                                              //     // SizedBox(width: 5,),
                                                                              //     Text('Full Payment Collected.',
                                                                              //         style: TextStyle(
                                                                              //             fontSize: 11,
                                                                              //             color: Colors .black,
                                                                              //             fontWeight: FontWeight.w500
                                                                              //         )),
                                                                              //   ],
                                                                              // ),
                                                                              // SizedBox(height: 10,),
                                                                              // Visibility(
                                                                              //   visible: isChecked,
                                                                              //   child: Row(
                                                                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              //       children: [
                                                                              //         Padding(
                                                                              //           padding: const EdgeInsets.all(8.0),
                                                                              //           child: Container(
                                                                              //             width: MediaQuery.of(context).size.width /2.4,
                                                                              //             child: TextFormField(
                                                                              //               controller: payment,
                                                                              //               keyboardType: TextInputType.number,
                                                                              //               decoration: InputDecoration(
                                                                              //                 contentPadding: EdgeInsets.symmetric( vertical: 0,horizontal: 15),
                                                                              //                 fillColor: Colors.white,
                                                                              //                 filled: false,
                                                                              //                 hintText: "Payment Collected",
                                                                              //                 hintStyle: TextStyle(
                                                                              //                   fontSize: 11,),
                                                                              //                 enabledBorder: OutlineInputBorder(
                                                                              //                   borderSide: BorderSide(
                                                                              //                       width: 1,
                                                                              //                       color: Colors
                                                                              //                           .black45),
                                                                              //                   borderRadius: BorderRadius
                                                                              //                       .circular(
                                                                              //                       10),
                                                                              //                 ),
                                                                              //                 focusedBorder: OutlineInputBorder(
                                                                              //                   borderSide: BorderSide(
                                                                              //                       width: 1,
                                                                              //                       color: Colors
                                                                              //                           .black45),
                                                                              //                   borderRadius: BorderRadius
                                                                              //                       .circular(
                                                                              //                       10),
                                                                              //                 ),
                                                                              //                 border: InputBorder
                                                                              //                     .none,
                                                                              //               ),
                                                                              //             ),
                                                                              //           ),
                                                                              //         ),
                                                                              //         Container(
                                                                              //             width: MediaQuery .of(context).size .width / 2.4,
                                                                              //             alignment: Alignment.center,
                                                                              //             decoration: BoxDecoration(
                                                                              //               border: Border.all( color: Colors.black45),
                                                                              //               borderRadius: BorderRadius.circular(10),
                                                                              //             ),
                                                                              //             padding: EdgeInsets
                                                                              //                 .symmetric(
                                                                              //                 horizontal: 10,
                                                                              //                 vertical: 15),
                                                                              //             child: Text(
                                                                              //               "Payment Due:" +data[index].tCurrentDue.toString(),
                                                                              //               style: TextStyle(fontSize: 11),)
                                                                              //         ),
                                                                              //       ]
                                                                              //   ),
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   height: 15,),
                                                                              // Padding(
                                                                              //   padding: const EdgeInsets.all(8.0),
                                                                              //   child: Card(
                                                                              //     elevation: 3,
                                                                              //     shape: ContinuousRectangleBorder(
                                                                              //         borderRadius: BorderRadius.all(Radius.circular(20))
                                                                              //     ),
                                                                              //     child: Container(alignment: Alignment .center, height: 45,
                                                                              //       decoration: BoxDecoration(
                                                                              //         borderRadius: BorderRadius .all( Radius.circular(5)),
                                                                              //         color: Color( 0xff65AC2B),
                                                                              //       ),
                                                                              //       child: MaterialButton(
                                                                              //           height: 45,
                                                                              //           minWidth: MediaQuery .of( context) .size.width,
                                                                              //           highlightColor: Colors.redAccent,
                                                                              //           onPressed: () async {
                                                                              //             if(payment.text.isNotEmpty) {
                                                                              //               var dio = Dio();
                                                                              //               var formData = FormData
                                                                              //                   .fromMap(
                                                                              //                   {
                                                                              //                     'bill_id': data[index].tractorBillId.toString(),
                                                                              //                     'due_amount': payment.text.toString(),
                                                                              //                     'payment_type': payment_type.toString(),
                                                                              //                   });
                                                                              //               var response = await dio.post('https://doplus.creditmywallet.in.net/api/add_tractor_bill_collection', data: formData);
                                                                              //               print(formData.fields.toString() + "^^^^^^^^^^^^^^^^^^^");
                                                                              //               print("response ====>>>" + response.toString());
                                                                              //               var res = response.data;
                                                                              //               String msg = res['status_message'];
                                                                              //               print("bjhgbvfjhdfgbfu====>..." + msg.toString());
                                                                              //               if (msg == "Bill Updated Successfully") {
                                                                              //                 Fluttertoast
                                                                              //                     .showToast(
                                                                              //                     msg: 'Bill Updated Successfully',
                                                                              //                     backgroundColor: Colors.green, gravity: ToastGravity.CENTER);}
                                                                              //               else {
                                                                              //                 Fluttertoast
                                                                              //                     .showToast(
                                                                              //                     msg: msg
                                                                              //                         .toString(),
                                                                              //                     backgroundColor: Colors
                                                                              //                         .red,
                                                                              //                     gravity: ToastGravity
                                                                              //                         .CENTER,
                                                                              //                     textColor: Colors
                                                                              //                         .white);
                                                                              //               }
                                                                              //               Navigator
                                                                              //                   .pop(
                                                                              //                   context);
                                                                              //             }else{
                                                                              //               Fluttertoast
                                                                              //                   .showToast(
                                                                              //                   msg: 'Payment is Empty.',
                                                                              //                   backgroundColor: Colors
                                                                              //                       .red,
                                                                              //                   gravity: ToastGravity
                                                                              //                       .CENTER);
                                                                              //             }
                                                                              //           },
                                                                              //           child: Text( "Update",
                                                                              //             style: TextStyle(
                                                                              //                 fontSize: 17,
                                                                              //                 color: Colors.white,
                                                                              //                 fontWeight: FontWeight.bold),
                                                                              //           )),
                                                                              //
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   height: 15,),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    3.3,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Color(
                                                                      0xff40BDEB),
                                                                ),
                                                                child: Text(
                                                                  "Update_Payment"
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            )
                                                          : Text(
                                                              "Paid",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xff3DBA3D),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                      data[index]
                                                                  .tPaidStatus
                                                                  .toString() !=
                                                              "1"
                                                          ? Text("")
                                                          : IconButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  Share.share(
                                                                      'Hi! Download the SHASY MITRA app & pay your bills\n https://shorturl.at/dgiH7',
                                                                      subject:
                                                                          'SHASY MITRA');
                                                                });
                                                              },
                                                              icon: Icon(
                                                                  Icons.share)),
                                                      SizedBox(
                                                        width: 5,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>Contact()));
              } else if (_currentIndex == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Show_me_plan()));
              } else if (_currentIndex == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile_page()));
              }
            },
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  CupertinoIcons.house_fill,
                  size: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Contact',
                icon: Icon(
                  Icons.library_books_outlined,
                  size: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Crop Plans',
                icon: Icon(
                  CupertinoIcons.crop_rotate,
                  size: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(
                  CupertinoIcons.person_circle,
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



// import 'package:agriculture/All_Model/tracktors_get_bill_model.dart';
// import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/owner_payment_list_model.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../profile_all_screen/Profile_page.dart';
// import '../Home_Page.dart';
// import 'Tractor_add_bill_page.dart';
// import 'package:http/http.dart' as http;
// class Tractor_page extends StatefulWidget {
//    Tractor_page({Key? key,this.number}) : super(key: key);
//   String?number;
//   @override
//   State<Tractor_page> createState() => _Tractor_pageState();
// }
// class _Tractor_pageState extends State<Tractor_page> {
//
//
//   int _currentIndex = 0;
//   bool isChecked=true;
//   int? Car;
//   String? payment_type;
//   var bill_id;
//   TextEditingController payment=TextEditingController();
//   TextEditingController current_payment=TextEditingController();
//   String dropdownvalue = 'भाषा/Language';
//   var items = [
//     'भाषा/Language',
//     'हिन्दी/Hindi',
//     'इंग्लिश/English',
//   ];
//
//   var total_due,advance;
//   Future  total_ownwe_money() async{
//     final pref = await SharedPreferences.getInstance();
//     var user_id = pref.getString('user_id');
//     Map data={
//       'owner_id': user_id.toString(),
//     };
//     var data1 = jsonEncode(data);
//     var url= Uri.parse("https://doplus.creditmywallet.in.net/api/get_tractor_owner_tractor_total_money");
//     final response = await http.post(url,headers: {"Content-Type":"Application/json"},body: data1);
//     var res = jsonDecode(response.body);
//     if(response.statusCode==200){
//       setState(() {
//         total_due = res['total_due'];
//         advance = res['total_advance'];
//         print(res.toString()+"@@@@@@");
//       });
//     }
//   }
//
//   Future<List<Res>>  owner_paymet_list() async {
//     final pref = await SharedPreferences.getInstance();
//     var user_id = pref.getString('user_id');
//     Map data={
//       'owner_id': user_id.toString(),
//     };
//     var data1 = jsonEncode(data);
//     var url=Uri.parse("https://doplus.creditmywallet.in.net/api/get_tractor_owner_payment_list");
//     final response = await http.post(url,headers: {"Content-Type":"Application/json"},body: data1);
//     if (response.statusCode == 200) {
//       Map<String,dynamic> map=json.decode(response.body);
//       List<dynamic> data=map["response"];
//       setState(() {
//       });
//       return data.map((data) => Res.fromJson(data)).toList();
//     }else{
//       throw Exception('unexpected error occurred');
//     }
//   }
//   // var mobileNo,image,address,district,state,pincode,ggf,machine;
//   // var payment_details,payment_name,payment_upi_id;
//   // String? name;
//   // Future getProfile() async{
//   //   final pref = await SharedPreferences.getInstance();
//   //   var user_id = pref.getString('user_id');
//   //   Map data={
//   //     'user_id': user_id.toString(),
//   //     //'user_id':"USR681808989",
//   //   };
//   //   Uri url=Uri.parse("https://doplus.creditmywallet.in.net/api/get_user");
//   //   var body1= jsonEncode(data);
//   //   var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: body1);
//   //   var res = await json.decode(response.body);
//   //   setState(() {
//   //     name=res["name"];
//   //     mobileNo=res["mobile"];
//   //     image=res["img"];
//   //     machine = res['tractor_id'];
//   //     address=res["address"];
//   //     district=res["district"];
//   //     state=res["state"];
//   //     pincode=res["pin"];
//   //     payment_details=res["payment_details"];
//   //     payment_name=res["payment_name"];
//   //     payment_upi_id=res["payment_upi_id"];
//   //     print('Name =========>>>>>>>>'+district.toString());
//   //   });
//   // }
//   // Future<List<Data>>  tracktors_get_bill() async {
//   //   final pref = await SharedPreferences.getInstance();
//   //   var user_id = pref.getString('user_id');
//   //   Map data={
//   //     'user_id':user_id.toString(),
//   //   };
//   //   var url=Uri.parse("https://doplus.creditmywallet.in.net/api/get_tractor_bills");
//   //   var response=await http.post(url,body:data);
//   //   if (response.statusCode == 200) {
//   //     Map<String,dynamic> map=json.decode(response.body);
//   //     List<dynamic> data=map["data"];
//   //
//   //     return data.map((data) => Data.fromJson(data)).toList();
//   //   }else{
//   //     throw Exception('unexpected error occurred');
//   //   }
//   // }
//   @override
//   void initState() {
//     super.initState();
//     total_ownwe_money();
//     owner_paymet_list();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children:<Widget> [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               InkWell(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile_page()));
//                                   },
//                                   child: Icon(CupertinoIcons.person_circle,size: 37,color:Color(0xff00aeef) ,)),
//                               SizedBox(width:3,),
//                               Text("Shasy",style: TextStyle(fontStyle: FontStyle.italic,fontSize:21,fontWeight: FontWeight.bold,color: Color(0xff66ad2d)),textAlign: TextAlign.center,),
//                               SizedBox(width:3,),
//                               Text("Mitra",style: TextStyle(fontStyle: FontStyle.italic,fontSize:21,fontWeight: FontWeight.bold,color: Color(0xff00aeef)),textAlign: TextAlign.center,),
//                               SizedBox(
//                                 width:MediaQuery.of(context).size.width/13,
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               DropdownButton(
//                                 style: TextStyle(fontSize:11,fontWeight: FontWeight.bold,color: Color(0xff00aeef)),
//                                 iconEnabledColor: Colors.black87,
//                                 iconSize: 25,
//                                 elevation: 00,
//                                 underline: SizedBox(),
//                                 value: dropdownvalue,
//                                 icon: const Icon(Icons.arrow_drop_down,),
//                                 items: items.map((String items) {
//                                   return DropdownMenuItem(
//                                     value: items,
//                                     child: Text(items),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     dropdownvalue = newValue!;
//                                   });
//                                 },
//                               ),
//                               SizedBox(
//                                 width:MediaQuery.of(context).size.width/45,
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     height: 25,
//                                     width: 40,
//                                     child: CircleAvatar(
//                                       backgroundColor: Colors.white24,
//                                       child: IconButton(
//                                        onPressed: (){},
//                                        icon: Icon(Icons.call,color:Color(0xff66ad2d))),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8,),
//                                   Text("Help",style: TextStyle(fontSize: 12,color: Color(0xff00aeef),fontWeight: FontWeight.w700),),
//                                   SizedBox(height: 20,),
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 // SizedBox(height: 10,),
//                 // Padding(
//                 //   padding: EdgeInsets.only(bottom: 15),
//                 //   child: Column(
//                 //     children: [
//                 //       Text("Tractor Bills and Management",
//                 //         style: TextStyle(
//                 //             color: Color(0xff085272),
//                 //             fontSize: 14,
//                 //             fontWeight: FontWeight.w700),)
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   Container(
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: Padding(
//                             padding: const EdgeInsets.only(top:45,left: 5,right: 5),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: MediaQuery.of(context).size.height/1.55,
//                                   width: MediaQuery.of(context).size.width,
//                                   padding: EdgeInsets.all(13),
//                                   child: Column(
//                                     children: [
//                                       // Padding(
//                                       //   padding: const EdgeInsets.only(top: 55.0),
//                                       //   child: Row(
//                                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       //     children: [
//                                       //       Column(
//                                       //         children: [
//                                       //           Row(
//                                       //             children: [
//                                       //               Icon(Icons.library_books,color: Color(0xff40BDEB),),
//                                       //               SizedBox(width: 10,),
//                                       //               Text("Collections",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff085272)),)
//                                       //             ],
//                                       //           ),
//                                       //         ],
//                                       //       ),
//                                       //       IconButton(
//                                       //           onPressed: (){
//                                       //             Navigator.push(context, MaterialPageRoute(
//                                       //                 builder: (context)=>Tractor_bill_page()));
//                                       //           },
//                                       //           icon: Icon(Icons.add_circle,size: 45,color: Colors.green,)
//                                       //       ),
//                                       //     ],
//                                       //   ),
//                                       // ),
//                                       SizedBox(height: 10,),
//                                       Expanded(
//                                         child: FutureBuilder<List<Res>>(
//                                             future:  owner_paymet_list(),
//                                             builder:(context, AsyncSnapshot snapshot) {
//                                               if (!snapshot.hasData) {
//                                                 return Center(child: CircularProgressIndicator());
//                                               } else {
//                                                 List<Res>? data=snapshot.data;
//                                                 return Container(
//                                                   // height: MediaQuery.of(context).size.height*0.4,
//                                                   child: ListView.builder(
//                                                       itemCount: data!.length,
//                                                       itemBuilder: (context,index) {
//                                                         return Padding(
//                                                           padding: const EdgeInsets.only(bottom: 10),
//                                                           child: Card(
//                                                             shadowColor:data[index].tPaidStatus.toString()=="1"?Colors.red:Colors.green,
//                                                             elevation: 10,
//                                                             child: Container(
//                                                               padding: EdgeInsets.all(8),
//                                                               width: MediaQuery.of(context).size.width,
//                                                               child: Column(
//                                                                 children: [
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                     children: [
//                                                                       Text("#"+data[index].tractorBillId.toString(),
//                                                                         style: TextStyle(
//                                                                             fontSize: 11,
//                                                                             color: Color(0xff085272),
//                                                                             fontWeight: FontWeight.w700
//                                                                         ),),
//                                                                       Text("Created-On:"+data[index].createdDate.toString(),
//                                                                           style: TextStyle(
//                                                                               fontSize: 11,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w500
//                                                                           )
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   SizedBox(height: 10,),
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                                     children: [
//                                                                       Row(
//                                                                         children: [
//                                                                           Text("Type",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w700
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(width: 8,),
//                                                                           Text(": Tractor",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272)
//                                                                             )
//                                                                             ,),
//                                                                         ],
//                                                                       ),
//                                                                       Spacer(),
//                                                                       Row(
//                                                                         children: [
//                                                                           Text("Machine",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w700
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(width: 8,),
//                                                                           Text(': '+data[index].tMachineryUsed.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272)
//                                                                             )
//                                                                             ,),
//                                                                         ],
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   SizedBox(height: 10,),
//                                                                   Divider(),
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                                     children: [
//                                                                       Container(
//                                                                         width: MediaQuery.of(context).size.width/6,
//                                                                         child: Text("Name",style:
//                                                                         TextStyle(
//                                                                             fontSize:11,
//                                                                             color: Color(0xff085272),
//                                                                             fontWeight: FontWeight.w700),
//                                                                         ),
//                                                                       ),
//                                                                       Container(
//                                                                         width: MediaQuery.of(context).size.width/5.4,
//                                                                         child: Text("Start-date",
//                                                                           style: TextStyle(fontSize:12,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w700
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       Container(
//                                                                         width: MediaQuery.of(context).size.width/5.3,
//                                                                         child: Text("End-date",
//                                                                           style: TextStyle(fontSize:11,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w700),),
//                                                                       ),
//                                                                       Container(
//                                                                         width: MediaQuery.of(context).size.width/7,
//                                                                         child: Text("Unit",
//                                                                           style: TextStyle(
//                                                                               fontSize: 11,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w700
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       Container(
//                                                                         width: MediaQuery.of(context).size.width/8,
//                                                                         child: Text("Rate",
//                                                                           style: TextStyle(
//                                                                               fontSize: 12,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w700
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   SizedBox(height: 3,),
//                                                                   Divider(),
//                                                                   Container(
//                                                                     width: MediaQuery.of(context).size.width*0.85,
//                                                                     child: Row(
//                                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                                       children: [
//                                                                         Container(
//                                                                           width: MediaQuery.of(context).size.width/6,
//                                                                           child: Text(data[index].tName.toString(),style:
//                                                                           TextStyle(
//                                                                               fontSize:11,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width: MediaQuery.of(context).size.width/5.4,
//                                                                           child: Text(data[index].tStartDate.toString(),
//                                                                             style: TextStyle(fontSize:10,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width: MediaQuery.of(context).size.width/5.4,
//                                                                           child: Text(data[index].tEndDate.toString(),
//                                                                             style: TextStyle(fontSize:10,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),),
//                                                                         ),
//                                                                         Container(
//                                                                           width: MediaQuery.of(context).size.width/6,
//                                                                           child: Text(data[index].tUsage.toString()+"-"+data[index].tUnit.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width: MediaQuery.of(context).size.width/10,
//                                                                           child: Text('\u{20B9} '+data[index].tHours.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(height: 15,),
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                     children: [
//                                                                       Column(
//                                                                         children: [
//                                                                           Text("Total Due: Rs. "+data[index].tTotal.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: Color(0xff3DBA3D),
//                                                                                 fontWeight: FontWeight.w500),),
//                                                                           SizedBox(height:5,),
//                                                                           data[index].tPaidStatus.toString()=="1"?
//                                                                           Text("Curent Due: Rs. "+data[index].tCurrentDue.toString(),
//                                                                             style: TextStyle(fontSize: 10,
//                                                                                 color: Color(0xff43567B)),):
//                                                                           Container(),
//                                                                         ],
//                                                                       ),
//                                                                       data[index].tPaidStatus.toString()=="1"?
//                                                                       InkWell(
//                                                                         onTap: (){
//                                                                           showDialog(
//                                                                             context: context,
//                                                                             builder: (context) {
//                                                                               return   StatefulBuilder(builder: (context, setState) {
//                                                                                 return  AlertDialog(
//                                                                                   contentPadding: EdgeInsets
//                                                                                       .symmetric(
//                                                                                       horizontal: 2,
//                                                                                       vertical: 2),
//                                                                                   insetPadding: EdgeInsets
//                                                                                       .symmetric(
//                                                                                       horizontal: 15),
//                                                                                   //clipBehavior: Clip.antiAliasWithSaveLayer,
//                                                                                   title: Row(
//                                                                                     children: [
//                                                                                       Icon(
//                                                                                         Icons
//                                                                                             .library_books,
//                                                                                         color: Color(
//                                                                                             0xff40BDEB),),
//                                                                                       Text(
//                                                                                         "Update Payment Status",
//                                                                                         style: TextStyle(
//                                                                                             fontSize: 15,
//                                                                                             color: Color(
//                                                                                                 0xff085272),
//                                                                                             fontWeight: FontWeight
//                                                                                                 .w500),
//                                                                                       ),
//                                                                                     ],
//                                                                                   ),
//                                                                                   shape: RoundedRectangleBorder(
//                                                                                       borderRadius: BorderRadius
//                                                                                           .all(
//                                                                                           Radius
//                                                                                               .circular(
//                                                                                               10))
//                                                                                   ),
//                                                                                   content: SingleChildScrollView(
//                                                                                     child: Column(
//                                                                                       children: [
//                                                                                         Padding(
//                                                                                           padding: const EdgeInsets.all(8.0),
//                                                                                           child: Row(
//                                                                                             mainAxisAlignment: MainAxisAlignment
//                                                                                                 .start,
//                                                                                             children: [
//                                                                                               Text(
//                                                                                                 "Name : ",
//                                                                                                 style: TextStyle(
//                                                                                                     fontSize: 14,
//                                                                                                     color: Color(
//                                                                                                         0xff085272)
//                                                                                                 ),
//                                                                                               ),
//                                                                                               SizedBox(
//                                                                                                 width: 8,),
//                                                                                               Text(
//                                                                                                 data[index].tName.toString(),
//                                                                                                 style: TextStyle(
//                                                                                                     fontSize: 14,
//                                                                                                     color: Color(0xff085272)
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ],
//                                                                                           ),
//                                                                                         ),
//                                                                                         SizedBox(
//                                                                                           height: 10,),
//                                                                                         Row(
//                                                                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                                                           children: [
//                                                                                             SizedBox(
//                                                                                               height:32,
//                                                                                               width: 32,
//                                                                                               child: Radio(
//                                                                                                 value: 1,
//                                                                                                 activeColor: Color(0xff48719A),
//                                                                                                 groupValue: Car,
//                                                                                                 onChanged: (value) {
//                                                                                                   setState(() {
//                                                                                                     Car = value!;
//                                                                                                     isChecked=true;
//                                                                                                     if (Car == 1) {
//                                                                                                       setState(() {
//                                                                                                         payment_type="0";
//                                                                                                       });
//                                                                                                     }
//                                                                                                   });
//                                                                                                 },
//                                                                                               ),
//                                                                                             ),
//                                                                                             //SizedBox( width: 3,),
//                                                                                             Text('Partial Payment Collected.',
//                                                                                                 style: TextStyle(
//                                                                                                     fontSize: 11,
//                                                                                                     color: Colors .black,
//                                                                                                     fontWeight: FontWeight.w500
//                                                                                                 )),
//                                                                                            // SizedBox(width: 3,),
//                                                                                             SizedBox(
//                                                                                               height: 30,
//                                                                                               width: 30,
//                                                                                               child: Radio(
//                                                                                                 value: 2,
//                                                                                                 activeColor: Color(
//                                                                                                     0xff48719A),
//                                                                                                 groupValue: Car,
//                                                                                                 onChanged: (value) {
//                                                                                                   setState(() {
//                                                                                                     Car =value!;
//                                                                                                     isChecked=false;
//                                                                                                     if (Car ==2) {
//                                                                                                       setState(() {
//                                                                                                         payment_type ="1";
//                                                                                                       });
//                                                                                                     }
//                                                                                                   });
//                                                                                                 },
//                                                                                               ),
//                                                                                             ),
//                                                                                            // SizedBox(width: 5,),
//                                                                                             Text('Full Payment Collected.',
//                                                                                                 style: TextStyle(
//                                                                                                     fontSize: 11,
//                                                                                                     color: Colors .black,
//                                                                                                     fontWeight: FontWeight.w500
//                                                                                                 )),
//                                                                                           ],
//                                                                                         ),
//                                                                                         SizedBox(height: 10,),
//                                                                                         Visibility(
//                                                                                           visible: isChecked,
//                                                                                           child: Row(
//                                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                             children: [
//                                                                                               Padding(
//                                                                                                 padding: const EdgeInsets.all(8.0),
//                                                                                                 child: Container(
//                                                                                                   width: MediaQuery.of(context).size.width /2.4,
//                                                                                                   child: TextFormField(
//                                                                                                     controller: payment,
//                                                                                                     keyboardType: TextInputType.number,
//                                                                                                     decoration: InputDecoration(
//                                                                                                       contentPadding: EdgeInsets.symmetric( vertical: 0,horizontal: 15),
//                                                                                                       fillColor: Colors.white,
//                                                                                                       filled: false,
//                                                                                                       hintText: "Payment Collected",
//                                                                                                       hintStyle: TextStyle(
//                                                                                                         fontSize: 11,),
//                                                                                                       enabledBorder: OutlineInputBorder(
//                                                                                                         borderSide: BorderSide(
//                                                                                                             width: 1,
//                                                                                                             color: Colors
//                                                                                                                 .black45),
//                                                                                                         borderRadius: BorderRadius
//                                                                                                             .circular(
//                                                                                                             10),
//                                                                                                       ),
//                                                                                                       focusedBorder: OutlineInputBorder(
//                                                                                                         borderSide: BorderSide(
//                                                                                                             width: 1,
//                                                                                                             color: Colors
//                                                                                                                 .black45),
//                                                                                                         borderRadius: BorderRadius
//                                                                                                             .circular(
//                                                                                                             10),
//                                                                                                       ),
//                                                                                                       border: InputBorder
//                                                                                                           .none,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ),
//                                                                                                Container(
//                                                                                                     width: MediaQuery .of(context).size .width / 2.4,
//                                                                                                     alignment: Alignment.center,
//                                                                                                     decoration: BoxDecoration(
//                                                                                                       border: Border.all( color: Colors.black45),
//                                                                                                       borderRadius: BorderRadius.circular(10),
//                                                                                                     ),
//                                                                                                     padding: EdgeInsets
//                                                                                                         .symmetric(
//                                                                                                         horizontal: 10,
//                                                                                                         vertical: 15),
//                                                                                                     child: Text(
//                                                                                                       "Payment Due:" +data[index].tCurrentDue.toString(),
//                                                                                                       style: TextStyle(fontSize: 11),)
//                                                                                                 ),
//                                                                                                ]
//                                                                                               ),
//                                                                                         ),
//                                                                                         SizedBox(
//                                                                                           height: 15,),
//                                                                                         Padding(
//                                                                                           padding: const EdgeInsets.all(8.0),
//                                                                                           child: Card(
//                                                                                             elevation: 3,
//                                                                                             shape: ContinuousRectangleBorder(
//                                                                                                 borderRadius: BorderRadius.all(Radius.circular(20))
//                                                                                             ),
//                                                                                             child: Container(alignment: Alignment .center, height: 45,
//                                                                                               decoration: BoxDecoration(
//                                                                                                 borderRadius: BorderRadius .all( Radius.circular(5)),
//                                                                                                 color: Color( 0xff65AC2B),
//                                                                                               ),
//                                                                                               child: MaterialButton(
//                                                                                                   height: 45,
//                                                                                                   minWidth: MediaQuery .of( context) .size.width,
//                                                                                                   highlightColor: Colors.redAccent,
//                                                                                                   onPressed: () async {
//                                                                                                     if(payment.text.isNotEmpty) {
//                                                                                                       var dio = Dio();
//                                                                                                       var formData = FormData
//                                                                                                           .fromMap(
//                                                                                                           {
//                                                                                                             'bill_id': data[index].tractorBillId.toString(),
//                                                                                                             'due_amount': payment.text.toString(),
//                                                                                                             'payment_type': payment_type.toString(),
//                                                                                                           });
//                                                                                                           var response = await dio.post('https://doplus.creditmywallet.in.net/api/add_tractor_bill_collection', data: formData);
//                                                                                                       print(formData.fields.toString() + "^^^^^^^^^^^^^^^^^^^");
//                                                                                                       print("response ====>>>" + response.toString());
//                                                                                                       var res = response.data;
//                                                                                                       String msg = res['status_message'];
//                                                                                                       print("bjhgbvfjhdfgbfu====>..." + msg.toString());
//                                                                                                       if (msg == "Bill Updated Successfully") {
//                                                                                                         Fluttertoast
//                                                                                                             .showToast(
//                                                                                                             msg: 'Bill Updated Successfully',
//                                                                                                             backgroundColor: Colors.green, gravity: ToastGravity.CENTER);}
//                                                                                                       else {
//                                                                                                         Fluttertoast
//                                                                                                             .showToast(
//                                                                                                             msg: msg
//                                                                                                                 .toString(),
//                                                                                                             backgroundColor: Colors
//                                                                                                                 .red,
//                                                                                                             gravity: ToastGravity
//                                                                                                                 .CENTER,
//                                                                                                             textColor: Colors
//                                                                                                                 .white);
//                                                                                                       }
//                                                                                                       Navigator
//                                                                                                           .pop(
//                                                                                                           context);
//                                                                                                     }else{
//                                                                                                       Fluttertoast
//                                                                                                           .showToast(
//                                                                                                           msg: 'Payment is Empty.',
//                                                                                                           backgroundColor: Colors
//                                                                                                               .red,
//                                                                                                           gravity: ToastGravity
//                                                                                                               .CENTER);
//                                                                                                     }
//                                                                                                   },
//                                                                                                   child: Text( "Update",
//                                                                                                     style: TextStyle(
//                                                                                                         fontSize: 17,
//                                                                                                         color: Colors.white,
//                                                                                                         fontWeight: FontWeight.bold),
//                                                                                                   )),
//
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                         SizedBox(
//                                                                                           height: 15,),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                 );
//                                                                               });
//                                                                             },
//                                                                           );
//                                                                         },
//                                                                         child: Container(
//                                                                           alignment: Alignment.center,
//                                                                           width: MediaQuery.of(context).size.width/3.3,
//                                                                           padding: EdgeInsets.all(8),
//                                                                           decoration: BoxDecoration(
//                                                                             borderRadius: BorderRadius.circular(10),
//                                                                             color: Color(0xff40BDEB),
//                                                                           ),
//                                                                           child: Text("Update Payment",
//                                                                             style: TextStyle(fontSize: 11,
//                                                                                 color: Colors.white,
//                                                                                 fontWeight: FontWeight.w500),),
//                                                                         ),
//                                                                       ):
//                                                                       Text("Paid",style: TextStyle(
//                                                                           fontSize: 12
//                                                                           ,color: Color(0xff3DBA3D),
//                                                                           fontWeight: FontWeight.w500),),
//                                                                       data[index].tPaidStatus.toString()!="1"?Text("") :IconButton(
//                                                                           onPressed: () async{
//                                                                             setState(() {
//                                                                               Share.share('check tubewel bill\n https://agriculture.page.link/bill_share', subject: 'Look what I made!');
//                                                                             });
//                                                                           },
//                                                                           icon: Icon(Icons.share)),
//                                                                       SizedBox(width: 5,)
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//
//                                                             ),
//                                                           ),
//                                                         );
//
//                                                       }
//                                                   ),
//                                                 );
//                                               }
//                                             }
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                             top: -20,
//                             right: 0,
//                             left: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     // Padding(
//                                     //   padding: const EdgeInsets.all(10.0),
//                                     //   child: Row(
//                                     //     children: [
//                                     //       Container(
//                                     //           height: 45,
//                                     //           width: 45,
//                                     //           margin: EdgeInsets.all(10),
//                                     //           child: Image(image: AssetImage("assets/tracktor.png"),height: 35,)
//                                     //       ),
//                                     //       Container(
//                                     //         width: MediaQuery.of(context).size.width/1.88,
//                                     //         child: Column(
//                                     //           crossAxisAlignment: CrossAxisAlignment.start,
//                                     //           children: [
//                                     //             Text("Welcome !! Pradeep Jha",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xff085272)),),
//                                     //             SizedBox(height: 10,),
//                                     //             Text("You can manage, check, edit, pay and collect your Tubewell Bills",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w700,color: Color(0xff085272)),)
//                                     //           ],
//                                     //         ),
//                                     //       ),
//                                     //       Spacer(),
//                                     //       Icon(Icons.calendar_month,size: 30,color: Colors.red,)
//                                     //     ],
//                                     //   ),
//                                     // )
//                                 Column(
//                                   children: [
//                                     Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           height:40,
//                                           width: MediaQuery.of(context).size.width*0.9,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.circular(8),
//                                               border: Border.all(width: 1)
//                                           ),
//                                           child: Center(child: Text("Hello________ !" ,style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff50899f)
//                                           ),)),
//                                         ),
//                                         SizedBox(height: 10,),
//                                         Container(
//                                           height:50,
//                                           width: MediaQuery.of(context).size.width*0.9,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.circular(8),
//                                               border: Border.all(width: 1)
//                                           ),
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(width: 10,),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 10),
//                                                     child: Image(image: AssetImage("assets/tracktor.png"),height: 32,),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(left: 50.0,top: 5),
//                                                     child: Text('${widget.number}',
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight: FontWeight.bold,
//                                                           color: Color(0xff50899f)
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(height: 10,),
//                                         Container(
//                                           height:40,
//                                           width: MediaQuery.of(context).size.width*0.9,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.circular(8),
//                                               border: Border.all(width: 1)
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(left: 20),
//                                             child: Row(
//                                               children: [
//                                                 Text("Net Balance :" ,style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Color(0xff50899f)
//                                                 ),),
//                                                 SizedBox(width: 20,),
//                                                advance!=null ?Text("\u{20B9}"+advance.toString(),style: TextStyle(fontSize: 15,color: Color(0xff66ad2d)),):Text('\u{20B9}0',style: TextStyle(fontSize: 15,color: Color(0xff66ad2d))),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     ),
//                                   ],
//                                 ),
//                               ]
//                               ),
//                             )
//                          ),),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       bottomNavigationBar:Container(
//         height: 70,
//         margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.green,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             currentIndex: _currentIndex,
//             backgroundColor: Color(0xff40bdec),
//             selectedItemColor: Colors.white,
//             unselectedItemColor: Colors.black87.withOpacity(.60),
//             selectedFontSize: 14,
//             unselectedFontSize: 14,
//             onTap: (value) {
//               // Respond to item press.
//               setState(() => _currentIndex = value);
//               if(_currentIndex==0){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Home_page()));
//               }else if(_currentIndex==1){
//                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Contact()));
//               }
//               else if(_currentIndex==2){
//                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Track()));
//               }else if(_currentIndex==3){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile_page()));
//               }
//             },
//             items: [
//               BottomNavigationBarItem(
//                 label: 'Home',
//                 icon: Icon(CupertinoIcons.house_fill,size: 25,),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Contact',
//                 icon: Icon(Icons.library_books_outlined,size: 25,),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Booking',
//                 icon: Icon(CupertinoIcons.arrow_down_doc_fill,size: 25,),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Profile',
//                 icon: Icon(CupertinoIcons.person_circle,size: 25,),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Dish{
//   late int unit;
//   late double _unit;
//   double totalPrice(){
//     return unit * _unit;
//   }
// }