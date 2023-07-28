import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'Tubewell_All_model/Tubewel_bill_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../crop_health_page.dart';
import 'package:get/get.dart' as g;

class View_All_Tubewell_Customer extends StatefulWidget {
  View_All_Tubewell_Customer({Key? key, this.number}) : super(key: key);
  String? number;

  @override
  State<View_All_Tubewell_Customer> createState() =>
      _View_All_Tubewell_CustomerState();
}

class _View_All_Tubewell_CustomerState
    extends State<View_All_Tubewell_Customer> {
  bool isChecked = true;
  int? Car;
  String? payment_type;
  var bill_id;
  TextEditingController payment = TextEditingController();
  TextEditingController current_payment = TextEditingController();
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  Future<List<Data>> getTubewellBill() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_bills");
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["data"];
      return data.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  bool loading = false;
  String? name;
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

  // bool isChecked = true;
  // int? Car = 0;
  // String? payment_type;

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  String? total_advance;
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
        // total_due = res['total_due'];
        total_advance = res['total_advance'].toString();
        // print(res.toString() + "@@@@@@");
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

  int _value = 1;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    total_ownwe_money();
    getProfilegetProfile();
    super.initState();
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1)),
                        child: Center(
                            child: Text(
                          "Hello $name!",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff50899f)),
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
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
                              total_advance != null
                                  ? Text(
                                      "\u{20B9}" + total_advance.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff66ad2d)),
                                    )
                                  : Text('\u{20B9}0',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff66ad2d))),
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
                        child: Expanded(
                          child: FutureBuilder<List<Data>>(
                              future: getTubewellBill(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  List<Data>? data = snapshot.data;
                                  return Container(
                                    // height: MediaQuery.of(context).size.height*0.2,
                                    child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        itemCount: data!.length,
                                        itemBuilder: (context, index) {
                                          return data[index]
                                                      .paidStatus
                                                      .toString() ==
                                                  "0"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Card(
                                                    shadowColor: data[index]
                                                                .paidStatus
                                                                .toString() ==
                                                            "1"
                                                        ? Colors.red
                                                        : Colors.green,
                                                    elevation: 10,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
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
                                                                        .billId
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Color(
                                                                        0xff085272),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Text(
                                                                  "Created_On".tr +
                                                                      data[index]
                                                                          .createdDate
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
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
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Type : Tubewell",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color(
                                                                        0xff085272),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  '${'date'.tr} - ${data[index].date.toString()}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "${'Name'.tr} :",
                                                                  // "Name",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "Start-Time",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "End-Time",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "rate".tr,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "Hrs",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
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
                                                                child: Text(
                                                                  data[index]
                                                                      .name
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  data[index]
                                                                      .startTime
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  data[index]
                                                                      .endTime
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  data[index]
                                                                      .rate
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  data[index]
                                                                      .hours
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Color(
                                                                          0xff085272),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ],
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
                                                                            .total
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xff3DBA3D),
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  data[index]
                                                                              .paidStatus
                                                                              .toString() ==
                                                                          "1"
                                                                      ? Text(
                                                                          "Curent Due: Rs. " +
                                                                              data[index].currentDue.toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Color(0xff43567B)),
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              data[index]
                                                                          .paidStatus
                                                                          .toString() ==
                                                                      "1"
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
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
                                                                                                style: TextStyle(fontSize: 14, color: Color(0xff085272)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 8,
                                                                                              ),
                                                                                              Text(
                                                                                                data[index].name.toString(),
                                                                                                style: TextStyle(fontSize: 14, color: Color(0xff085272)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Container(
                                                                                          width: MediaQuery.of(context).size.width * 0.95,
                                                                                          child: Row(
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
                                                                                              // SizedBox(width: 3,),
                                                                                              Text('Partial_Payment_Collected'.tr, style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500)),
                                                                                              //  SizedBox(width:3,),
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
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Visibility(
                                                                                          visible: isChecked,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Container(
                                                                                                  width: MediaQuery.of(context).size.width / 2.4,
                                                                                                  child: TextFormField(
                                                                                                    controller: payment,
                                                                                                    keyboardType: TextInputType.number,
                                                                                                    decoration: InputDecoration(
                                                                                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                                                                                      fillColor: Colors.white,
                                                                                                      filled: true,
                                                                                                      hintText: "Payment Collected",
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
                                                                                                Container(
                                                                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                                                                    alignment: Alignment.center,
                                                                                                    decoration: BoxDecoration(
                                                                                                      border: Border.all(color: Colors.black45),
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                    ),
                                                                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                                                    child: Text(
                                                                                                      "${'Payment_Due'.tr}:" + data[index].currentDue.toString(),
                                                                                                      style: TextStyle(fontSize: 11),
                                                                                                    )),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 15,
                                                                                        ),
                                                                                        Padding(
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
                                                                                                    // if (payment.text.isNotEmpty) {
                                                                                                    //   var dio = d.Dio();
                                                                                                    //   var formData = FormData.fromMap({
                                                                                                    //     'bill_id': data[index].billId.toString(),
                                                                                                    //     'due_amount': payment.text.toString(),
                                                                                                    //     'payment_type': payment_type,
                                                                                                    //   });
                                                                                                    //   var response = await dio.post('https://doplus.creditmywallet.in.net/api/add_tubewell_bill_collection', data: formData);
                                                                                                    //   var res = response.data;
                                                                                                    //   setState(() {
                                                                                                    //     print(res.toString() + "uhkjkbhjgvghghhg");
                                                                                                    //   });
                                                                                                    //   String msg = res['status_message'];
                                                                                                    //   if (msg == "Bill Updated Successfully") {
                                                                                                    //     Fluttertoast.showToast(msg: 'Bill Updated Successfully', backgroundColor: Colors.green, gravity: ToastGravity.CENTER);
                                                                                                    //     setState(() {
                                                                                                    //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>Tubewell_page()));
                                                                                                    //       payment.clear();
                                                                                                    //     });
                                                                                                    //     //Navigator.pop(context);
                                                                                                    //   } else {
                                                                                                    //     Fluttertoast.showToast(msg: msg.toString(), backgroundColor: Colors.red, gravity: ToastGravity.CENTER, textColor: Colors.white);
                                                                                                    //   }
                                                                                                    //   Navigator.pop(context);
                                                                                                    // } else {
                                                                                                    //   Fluttertoast.showToast(msg: 'Payment is Empty.', backgroundColor: Colors.red, gravity: ToastGravity.CENTER);
                                                                                                    // }
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    "Update",
                                                                                                    style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                  )),
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
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        width: MediaQuery.of(context).size.width /
                                                                            3.3,
                                                                        padding:
                                                                            EdgeInsets.all(8),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color:
                                                                              Color(0xff40BDEB),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Update_Payment"
                                                                              .tr,
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      "Paid".tr,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                              0xff3DBA3D),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                              data[index]
                                                                          .paidStatus
                                                                          .toString() !=
                                                                      "1"
                                                                  ? Text('')
                                                                  : IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          String
                                                                              name =
                                                                              data[index].name.toString();
                                                                          String
                                                                              due =
                                                                              data[index].currentDue.toString();
                                                                          String
                                                                              user =
                                                                              "user@hdfgbank&pn";
                                                                          Share.share(
                                                                              'check tubewel bill\n upi://pay?pa=$user=&am=$due&cu=INR\n$name=TestingGpay\namount : $due',
                                                                              subject: 'Look what I made!');
                                                                        });
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .share)),
                                                              SizedBox(
                                                                width: 5,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox();
                                        }),
                                  );
                                }
                              }),
                        ),
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
