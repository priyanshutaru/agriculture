import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import '../all_Screen/all_home_screen/Home_Page.dart';
import '../all_Screen/all_home_screen/Show_me_plan.dart';
import '../all_Screen/all_home_screen/crop_health_page.dart';
import 'Profile_page.dart';

class Add_farm_land extends StatefulWidget {
  Add_farm_land(
      {required this.mobile, required this.image, required this.name});
  String mobile, image, name;

  @override
  State<Add_farm_land> createState() => _Add_farm_landState();
}

class _Add_farm_landState extends State<Add_farm_land>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 3;
  TextEditingController _title = TextEditingController();
  TextEditingController _gramSabha = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _accountNo = TextEditingController();
  TextEditingController _landNo = TextEditingController();
  TextEditingController _landSize = TextEditingController();
  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  var name, image, mobile;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    setState(() {
      // AddLand();
      getpercentage();
      get_State();
      getUser();
      name = "${widget.name.toString()}";
      image = "${widget.image.toString()}";
      mobile = "${widget.mobile.toString()}";
    });
  }

  var percentage;
  Future getpercentage() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_profile_percentage");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      percentage = res['response'];
      print(percentage.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  String? location;
  List get_city_list = [];
  Future get_State() async {
    Map data = {'country_id': '91'};
    var data1 = jsonEncode(data);
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_state");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['data'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_city_list = res;
      print(get_city_list.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  List get_district_list = [];
  String? districtid;
  Future get_District() async {
    Map data = {'state_id': location.toString()};
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_district");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['data'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_district_list = res;
      print(get_district_list.toString() + "%%%%%%%%%%%%%%%%");
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

  List get_tehsile_list = [];
  String? tehsile;
  Future get_Tehsile() async {
    Map data = {'district_id': districtid.toString()};
    var data1 = jsonEncode(data);
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_tehsil");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['data'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_tehsile_list = res;
      print(get_tehsile_list.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  bool isloading = false;

  Future AddLand() async {
    setState(() {
      isloading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    var url =
        Uri.parse('https://doplus.creditmywallet.in.net/api/add_form_land');
    Map data = {
      'user_id': user_id,
      'title': _title.text.toString(),
      'state_id': location.toString(),
      'district_id': districtid.toString(),
      'tehsil_id': tehsile.toString(),
      'gram': _gramSabha.text.toString(),
      'pincode': _pincode.text.toString(),
      'ac_name': _accountNo.text.toString(),
      'land_no': _landNo.text.toString(),
      'land_size': _landSize.text.toString(),
    };
    var data1 = jsonEncode(data);
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    print(res.toString() + "@@@@@@@@@@@@@");
    try {
      if (response.statusCode == 200) {
        if (_formKey.currentState != null) {
          setState(() {
            isloading = false;
            Fluttertoast.showToast(
              msg: "Your Form Land Created Successfully",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Color(0xff66ad2d),
            );
            Navigator.pop(context);
          });
        }
        print(response.toString() + "response");
      } else {
        Fluttertoast.showToast(
          msg: "Some Thing Went wrong",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xff00aeef),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xff00aeef),
      );
      print(e);
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
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  var _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
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
                                        // SizedBox(
                                        //   height: 30,
                                        // ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Expanded(
                      child: Column(
                        children: [
                          // Card(
                          //   elevation: 5,
                          //   color: Color(0xff65AC2B),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(15)),
                          //   child: Container(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Container(
                          //         padding: const EdgeInsets.all(5.0),
                          //         width: MediaQuery.of(context).size.width,
                          //         // height: MediaQuery.of(context).size.height/7.5,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       children: [
                          //                         image == null
                          //                             ? CircleAvatar(
                          //                                 backgroundColor:
                          //                                     Colors.white,
                          //                                 maxRadius: 40,
                          //                                 child: Image(
                          //                                   image: NetworkImage(
                          //                                       'https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png'),
                          //                                 ))
                          //                             : ClipRRect(
                          //                                 borderRadius:
                          //                                     BorderRadius.circular(
                          //                                         40.0),
                          //                                 child: Container(
                          //                                   height: 80,
                          //                                   width:
                          //                                       MediaQuery.of(context)
                          //                                               .size
                          //                                               .width /
                          //                                           4.7,
                          //                                   decoration: BoxDecoration(
                          //                                       image:
                          //                                           DecorationImage(
                          //                                     fit: BoxFit.cover,
                          //                                     image: NetworkImage(
                          //                                         image.toString()),
                          //                                   )),
                          //                                 ),
                          //                               ),
                          //                         Padding(
                          //                           padding: const EdgeInsets.only(
                          //                               left: 15),
                          //                           child: Column(
                          //                             crossAxisAlignment:
                          //                                 CrossAxisAlignment.start,
                          //                             children: [
                          //                               Text(
                          //                                 "Hey !!",
                          //                                 style: TextStyle(
                          //                                     fontSize: 14,
                          //                                     fontWeight:
                          //                                         FontWeight.w400,
                          //                                     color: Colors.white),
                          //                               ),
                          //                               SizedBox(
                          //                                 height: 5,
                          //                               ),
                          //                               Text(
                          //                                 name.toString(),
                          //                                 style: TextStyle(
                          //                                     fontSize: 13,
                          //                                     fontWeight:
                          //                                         FontWeight.bold,
                          //                                     color: Colors.white),
                          //                               ),
                          //                               SizedBox(
                          //                                 height: 5,
                          //                               ),
                          //                               Row(
                          //                                 children: [
                          //                                   Text(
                          //                                     mobile.toString(),
                          //                                     style: TextStyle(
                          //                                         fontSize: 12,
                          //                                         fontWeight:
                          //                                             FontWeight.bold,
                          //                                         color:
                          //                                             Colors.white),
                          //                                   ),
                          //                                   Icon(
                          //                                     Icons.edit,
                          //                                     size: 18,
                          //                                     color: Colors.white,
                          //                                   )
                          //                                 ],
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         )
                          //                       ],
                          //                     ),
                          //                     SizedBox(
                          //                       height: 7,
                          //                     ),
                          //                     Text(
                          //                       "Get full access complete 100% profile",
                          //                       style: TextStyle(
                          //                           fontSize: 11,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: Colors.white),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 Container(
                          //                   child: CircularPercentIndicator(
                          //                     radius: 45.0,
                          //                     lineWidth: 8.0,
                          //                     animation: true,
                          //                     percent: percentage / 100 == null
                          //                         ? "10"
                          //                         : percentage / 100,
                          //                     center: Text(
                          //                       percentage == null
                          //                           ? "10%"
                          //                           : percentage.toString() + "%",
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 16.0,
                          //                           color: Colors.white),
                          //                     ),
                          //                     circularStrokeCap:
                          //                         CircularStrokeCap.round,
                          //                     progressColor: Colors.white,
                          //                   ),
                          //                 )
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // tab bar view here
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Card(
                                        child: Container(
                                          //height:MediaQuery.of(context).size.height/2.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              //color: Color(0xff00aeef),
                                              //borderRadius: BorderRadius.circular(25)
                                              ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "add_farm_land".tr,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff81d3f2),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    width: 80,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff40bdeb),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: MaterialButton(
                                                        highlightColor:
                                                            Colors.green,
                                                        onPressed: () {
                                                          setState(() {
                                                            AddLand();
                                                          });
                                                        },
                                                        child: Text(
                                                          "save".tr,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: _title,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        15),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText:
                                                            "Title_Address".tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 3, bottom: 3),
                                                      child: Container(
                                                        height: 50,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .9,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Colors.white),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButtonFormField(
                                                            value: location,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            hint: Text(
                                                              "      ${'state'.tr}",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            icon: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child: Icon(Icons
                                                                  .arrow_drop_down),
                                                            ),
                                                            items: get_city_list
                                                                .map((item) {
                                                              return DropdownMenuItem(
                                                                value: item[
                                                                        'state_id']
                                                                    .toString(),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 15),
                                                                  child: Text(
                                                                    item['state_title']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                setState(() {
                                                                  location =
                                                                      newValue!
                                                                          as String?;
                                                                  get_District();
                                                                });
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 3, bottom: 3),
                                                      child: Container(
                                                        height: 50,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .9,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Colors.white),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButtonFormField(
                                                            value: districtid,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            hint: Text(
                                                              "      ${'district'.tr}",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            icon: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child: Icon(Icons
                                                                  .arrow_drop_down),
                                                            ),
                                                            items:
                                                                get_district_list
                                                                    .map(
                                                                        (item) {
                                                              return DropdownMenuItem(
                                                                value: item[
                                                                        'id']
                                                                    .toString(),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 15),
                                                                  child: Text(
                                                                    item['name']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                setState(() {
                                                                  districtid =
                                                                      newValue!
                                                                          as String?;
                                                                  get_Tehsile();
                                                                });
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // SizedBox(height: 10,),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 3, bottom: 3),
                                                      child: Container(
                                                        height: 50,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .9,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Colors.white),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButtonFormField(
                                                            value: tehsile,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            hint: Text(
                                                              "      ${'tehsile'.tr}",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            icon: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child: Icon(Icons
                                                                  .arrow_drop_down),
                                                            ),
                                                            items:
                                                                get_tehsile_list
                                                                    .map(
                                                                        (item) {
                                                              return DropdownMenuItem(
                                                                value: item[
                                                                        'tehsil_name']
                                                                    .toString(),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 15),
                                                                  child: Text(
                                                                    item['tehsil_name']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                tehsile = newValue!
                                                                    as String?;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: _gramSabha,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        15),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText:
                                                            "gramsabha".tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: _pincode,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        15),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText: "pincode".tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: _accountNo,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        15),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText:
                                                            "account_holder_name"
                                                                .tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: _landNo,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        15),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText: "land_number".tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller: _landSize,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        15),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText:
                                                            "land_size".tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
}
