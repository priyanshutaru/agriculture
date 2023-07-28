import 'dart:convert';

import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/tubewell_page.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../profile_all_screen/Profile_page.dart';
import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../Home_Page.dart';
import '../Show_me_plan.dart';
import '../crop_health_page.dart';

class Add_bill_page extends StatefulWidget {
  const Add_bill_page({Key? key}) : super(key: key);

  @override
  State<Add_bill_page> createState() => _Add_bill_pageState();
}

class _Add_bill_pageState extends State<Add_bill_page> {
  static DateTime date = DateTime.now();
  static var DropDate = "Start Date";
  static var startdate;
  static var EndDate = "End Date";
  static var enddate;
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  // var unitItemlist=[
  //   '1',
  //   '2'
  // ];
  List unitItemlist = [];
  String? unit;
  Future getAllUnit() async {
    var baseUrl = "https://doplus.creditmywallet.in.net/api/get_unit";
    http.Response response = await http.post(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)["status_message"];
      setState(() {
        unitItemlist = jsonData;
        print("@@@@@@@@@@@@@@@@===>>>>>>" + unitItemlist.toString());
      });
    }
  }

  String? unit_value;
  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _unit = TextEditingController();
  TextEditingController _totalHours = TextEditingController();
  TextEditingController _amountDue = TextEditingController();
  Future AddBill() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': user_id.toString(),
      'name': _name.text.toString(),
      'mobile': _number.text.toString(),
      'start_date': startdate.toString(),
      'end_date': enddate.toString(),
      'unit': unit.toString(),
      'total': _unit.text.toString(),
      'hours': _totalHours.text.toString(),
      'total_due': _amountDue.text.toString()
    });
    var response = await dio.post(
        'https://doplus.creditmywallet.in.net/api/add_tubewell_bill',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    int msg = res['status_code'];
    print("bjhgbvfjhdfgbfu====>..." + msg.toString());
    if (msg == 200) {
      Fluttertoast.showToast(
          msg: 'Bills Added Successfully',
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
      setState(() {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Tubewell_page()));
        _name.clear();
        _number.clear();
        _unit.clear();
        _totalHours.clear();
        _amountDue.clear();
      });
      //Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: 'Server Error..',
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER);
    }
  }

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    g.Get.back();
    g.Get.updateLocale(locale);
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
    getAllUnit();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Column(
                    children: [
                      Text(
                        "Tubewell Bills and Management",
                        style: TextStyle(
                            color: Color(0xff085272),
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height/1.4,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 45, left: 5, right: 5),
                            child: Column(
                              children: [
                                Card(
                                  elevation: 8,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.library_books,
                                                        color:
                                                            Color(0xff40BDEB),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Add Bill",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff085272)),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(13),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name of Person",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff085272),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller: _name,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0,
                                                          horizontal: 15),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "Full Name",
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "10 Digit Mobile Number",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff085272),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller: _number,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      10)
                                                ],
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0,
                                                          horizontal: 15),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText:
                                                      "Valid Mobile Number",
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "start_date".tr,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff085272),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: date,
                                                    firstDate: DateTime(2001),
                                                    lastDate: DateTime(2030),
                                                    builder: (context, child) {
                                                      return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary: Colors
                                                                .green, // header background color
                                                            onPrimary: Colors
                                                                .black, // header text color
                                                            onSurface: Colors
                                                                .green, // body text color
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  ).then((selectedDate) {
                                                    if (selectedDate != null) {
                                                      setState(() {
                                                        date = selectedDate;
                                                        DropDate = DateFormat(
                                                                'd MMM yyyy')
                                                            .format(
                                                                selectedDate);
                                                        startdate = DateFormat(
                                                                'yyyy-MM-d')
                                                            .format(
                                                                selectedDate);
                                                        print(
                                                            "start date>>>>>>" +
                                                                startdate
                                                                    .toString());
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black45)),
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Row(
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              "assets/calendar3.png"),
                                                          height: 35,
                                                        ),
                                                        SizedBox(
                                                          width: 18,
                                                        ),
                                                        Text(
                                                          DropDate,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "End Date",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff085272),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: date,
                                                    firstDate: DateTime(2001),
                                                    lastDate: DateTime(2030),
                                                    builder: (context, child) {
                                                      return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary: Colors
                                                                .green, // header background color
                                                            onPrimary: Colors
                                                                .black, // header text color
                                                            onSurface: Colors
                                                                .green, // body text color
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  ).then((selectedDate) {
                                                    if (selectedDate != null) {
                                                      setState(() {
                                                        date = selectedDate;
                                                        EndDate = DateFormat(
                                                                'd MMM yyyy')
                                                            .format(
                                                                selectedDate);
                                                        enddate = DateFormat(
                                                                'yyyy-MM-d')
                                                            .format(
                                                                selectedDate);
                                                        print(
                                                            "enddate date>>>>>>" +
                                                                enddate
                                                                    .toString());
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black45)),
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Row(
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              "assets/calendar3.png"),
                                                          height: 35,
                                                        ),
                                                        SizedBox(
                                                          width: 18,
                                                        ),
                                                        Text(
                                                          EndDate,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black45),
                                                    color: Colors.white),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 45,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          5),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          5))),
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Center(
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            hint: Text(
                                                              'unit'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff508399),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            items: unitItemlist
                                                                .map((item) =>
                                                                    DropdownMenuItem<
                                                                        String>(
                                                                      value: item[
                                                                              'unit_id']
                                                                          .toString(),
                                                                      child:
                                                                          Text(
                                                                        item['unit_name']
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                            value: unit,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                unit = value
                                                                    as String;
                                                                print("Unit id==>>" +
                                                                    unit.toString());
                                                              });
                                                            },
                                                            iconSize: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: TextFormField(
                                                      controller: _unit,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        1),
                                                        hintText:    "enter_unit"
                                                                      .tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Total Hour",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff085272),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller: _totalHours,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0,
                                                          horizontal: 15),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "Enter Hours",
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Amount Due",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff085272),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller: _amountDue,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0,
                                                          horizontal: 15),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "Enter Amount Due",
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Card(
                                                elevation: 3,
                                                shape:
                                                    ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: Color(0xff65AC2B),
                                                  ),
                                                  child: MaterialButton(
                                                      height: 45,
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      highlightColor:
                                                          Colors.redAccent,
                                                      onPressed: () async {
                                                        if (_name
                                                            .text.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Name is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (_number
                                                            .text.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Mobile Number is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (startdate ==
                                                            null) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Start Date is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (enddate ==
                                                            null) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'End Date is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (unit ==
                                                            null) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Unit is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (_unit
                                                            .text.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Usage Unit is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (_totalHours
                                                            .text.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Total Hours is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else if (_amountDue
                                                            .text.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Amount Due is Empty',
                                                              backgroundColor:
                                                                  Colors.green,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER);
                                                        } else {
                                                          AddBill();
                                                        }
                                                      },
                                                      child: Text(
                                                        "Add Bill",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: -20,
                            right: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                height: 45,
                                                width: 45,
                                                margin: EdgeInsets.all(10),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/tubewell.png"),
                                                  height: 35,
                                                )),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.88,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Welcome !! Pradeep Jha",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff085272)),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "You can manage, check, edit, pay and collect your Tubewell Bills",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff085272)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.calendar_month,
                                              size: 28,
                                              color: Colors.red,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
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
}
