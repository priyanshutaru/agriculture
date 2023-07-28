import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/Tractor_booking_page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/add_customer_bill.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/add_new_customer.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/owner_payment_list_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/send_reminder.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tractor_booking_all_page/view_all_customer.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import 'add_customer_list.dart';

class Add_Customer extends StatefulWidget {
  Add_Customer(
      {Key? key, this.name, this.number, this.user_mobile, this.c_name})
      : super(key: key);
  String? name, number, user_mobile, c_name;
  @override
  State<Add_Customer> createState() => _Add_CustomerState();
}

class _Add_CustomerState extends State<Add_Customer> {
  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  bool Car = false;
  bool isChecked = false;
  var payment_type = 0;
  String? name, t_num;
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
      name = res['onwer_name'];
      t_num = res['onwer_tractno'];
      print(res.toString() + "@@@@@@");
    });
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

  Future<List<Response>> get_customer_list() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_tractor_customers_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      return data.map((data) => Response.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

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

  String? customer_mobile, customer_name, date;
  List customer = [];
  String? c_name, mobile, customer_id;
  Future search_customer(String editText) async {
    Map data = {
      'user_mobile': editText,
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

  TextEditingController search = TextEditingController();
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];
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

  updateLanguage(Locale locale) {
    g.Get.back();
    g.Get.updateLocale(locale);
  }

  int _value = 1;
  @override
  void initState() {
    super.initState();
    setState(() {
      getUser();
      getProfilegetProfile();
      total_ownwe_money();
      // search_customer();
      gettractorDetail();
      // get_customer_list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
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
                                                    style:
                                                        TextStyle(fontSize: 8),
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
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
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
                                            "${"hello".tr}___",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff50899f)),
                                          )
                                        : Text(
                                            '${"hello".tr} $username!',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff50899f)),
                                          ),
                                  ],
                                ),
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
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 60),
                                    child: Image(
                                      image: AssetImage("assets/tracktor.jpeg"),
                                      height: 32,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text("Tractor Number--",
                                      //   style: TextStyle(
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: Color(0xff50899f)
                                      //   ),
                                      // ),
                                      Text(
                                        t_num.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  height: 70,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "\u{20B9}" + total_due.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontStyle: FontStyle.italic),
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
                                            builder: (context) => Tractor_page(
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
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: Colors.black45)),
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
                                height: 40,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Fill_Customer_Details()));
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
                          child: FutureBuilder<List<Response>>(
                              future: get_customer_list(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  List<Response>? data = snapshot.data;
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: data!.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          // return InkWell(
                                          //   onTap: (){
                                          //     setState(() {
                                          //       customer_name = data[index].utcrUserName.toString();
                                          //       customer_mobile = data[index].utcrUserMobile.toString();
                                          //       customer_id = data[index].utcrUserId.toString();
                                          //       date = data[index].createdAt.toString();
                                          //     });
                                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Send_Reminder(
                                          //         name: customer_name.toString(),
                                          //         user_mobile:customer_mobile.toString(),
                                          //         date1:date.toString(),
                                          //         c_id: customer_id.toString())));
                                          //   },
                                          //   child: Card(
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.all(20.0),
                                          //       child: Container(
                                          //         child: Row(
                                          //           children: [
                                          //             Container(
                                          //               width: MediaQuery.of(context).size.width*0.2,
                                          //             ),
                                          //             Column(
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Text(data[index].utcrUserName.toString()),
                                          //                 SizedBox(height: 10,),
                                          //                 Text(data[index].utcrUserMobile.toString()),
                                          //               ],
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // );
                                          String? postion = data[index]
                                              .utcrUserName
                                              .toString();
                                          if (search.text.isEmpty) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  customer_name = data[index]
                                                      .utcrUserName
                                                      .toString();
                                                  customer_mobile = data[index]
                                                      .utcrUserMobile
                                                      .toString();
                                                  customer_id = data[index]
                                                      .utcrUserId
                                                      .toString();
                                                  date = data[index]
                                                      .createdAt
                                                      .toString();
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Send_Reminder(
                                                            name: data[index]
                                                                .utcrUserName,
                                                            user_mobile: data[
                                                                    index]
                                                                .utcrUserMobile,
                                                            date1:
                                                                date.toString(),
                                                            c_id: customer_id
                                                                .toString())));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/bulb.png"))),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data[index]
                                                                  .utcrUserName
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xff447c95),
                                                                  fontSize: 15),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              data[index]
                                                                  .utcrUserMobile
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xff447c95)),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (postion
                                              .toLowerCase()
                                              .contains(
                                                  search.text.toLowerCase())) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  customer_name = data[index]
                                                      .utcrUserName
                                                      .toString();
                                                  customer_mobile = data[index]
                                                      .utcrUserMobile
                                                      .toString();
                                                  customer_id = data[index]
                                                      .utcrUserId
                                                      .toString();
                                                  date = data[index]
                                                      .createdAt
                                                      .toString();
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Send_Reminder(
                                                            name: customer_name
                                                                .toString(),
                                                            user_mobile:
                                                                customer_mobile
                                                                    .toString(),
                                                            date1:
                                                                date.toString(),
                                                            c_id: customer_id
                                                                .toString())));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data[index]
                                                              .utcrUserName
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff447c95)),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          data[index]
                                                              .utcrUserMobile
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff447c95)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
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
