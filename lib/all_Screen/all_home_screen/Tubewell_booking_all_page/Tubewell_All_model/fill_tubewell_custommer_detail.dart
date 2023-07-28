import 'dart:convert';

import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/Tubewell_All_model/add_customer_tubewell.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/tubwell_send_reminder.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../../Tractor_booking_all_page/search_model.dart';
import '../../crop_health_page.dart';

class Tubewell_Customer_Details extends StatefulWidget {
  const Tubewell_Customer_Details({Key? key}) : super(key: key);
  @override
  State<Tubewell_Customer_Details> createState() =>
      _Tubewell_Customer_DetailsState();
}

class _Tubewell_Customer_DetailsState extends State<Tubewell_Customer_Details> {
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];

  TextEditingController _c_name = TextEditingController();
  TextEditingController _c_number = TextEditingController();
  TextEditingController pnumber = TextEditingController();

  String? name;
  bool startsearch = false;
  Future Add_New_Customer() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'owner_id': user_id.toString(),
      'customer_name': _c_name.text.toString(),
      'customer_number': pnumber.text.toString(),
    };
    String? msg;
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/add_tubewell_customer");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    msg = jsonDecode(response.body)['status_message'];
    if (response.statusCode == 200) {
      setState(() {
        Fluttertoast.showToast(msg: msg.toString());
        print(res.toString() + "@@@@@@");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Add_Customer_Tubewell(
                      user_mobile: pnumber.text.toString(),
                      c_name: _c_name.text.toString(),
                    )));
      });
    }
  }

  TextEditingController search = TextEditingController();

  bool value = false;

  String? id;
  void _setCustomerId(id) async {
    final pref = await SharedPreferences.getInstance();
    final set1 = pref.setString('user_id', id);
    print("set1  %%==>>>=++++" + set1.toString());
  }

  // bool isloading = false;
  Future<List<SearchResponse>> get_search_list(String editText) async {
    // setState(() {
    //   isloading = true;
    // });
    Map data = {
      'user_mobile': editText.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/search_user_by_mobile");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      // print(data);
      return data.map((data) => SearchResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  // Future search_customer(String editText) async {
  //   setState(() {
  //     isloading = true;
  //   });
  //   Map data = {
  //     'user_mobile': editText.toString(),
  //   };
  //   String? msg;
  //   var data1 = jsonEncode(data);
  //   var url = Uri.parse(
  //       "https://doplus.creditmywallet.in.net/api/search_user_by_mobile");
  //   final response = await http.post(url,
  //       headers: {"Content-Type": "Application/json"}, body: data1);
  //   var res = jsonDecode(response.body);
  //   print(res);
  //   msg = jsonDecode(response.body)['status_message'];
  //   // if (response.statusCode == 200) {
  //   setState(() {
  //     isloading = false;
  //     // id = res['mobile'];
  //     name = res['name'].toString();
  //     // _setCustomerId(id);
  //     // print(res.toString() + "@@@@@@");
  //     // print(id.toString() + "MMMM");
  //     // Navigator.push(
  //     //     context, MaterialPageRoute(builder: (context) => Send_Reminder()));
  //   });
  //   // }
  // }
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
    Get.back();
    Get.updateLocale(locale);
  }

  int _value = 1;

  @override
  void initState() {
    super.initState();
    getUser();
    _setCustomerId(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child:
                // isloading
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     :
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
            // SizedBox(height: MediaQuery.of(context).size.height*0.15,),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)),
              child: Center(
                  child: Text(
                "fill_customer_detail".tr,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff50899f)),
              )),
            ),

            SizedBox(
              height: 50,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black45)),
              child: TextFormField(
                // onSaved: (searchBoxEditor) {
                //   setState(() {
                //     search_customer(searchBoxEditor!);
                //   });
                // },
                // onChanged: search_customer(),
                controller: _c_number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "add_cus_num_srch".tr,
                    contentPadding: EdgeInsets.all(8),
                    hintStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    suffixIcon: startsearch == true
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                startsearch = false;
                                _c_number.clear();
                                _c_name.clear();
                                pnumber.clear();
                              });
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ))
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                startsearch = true;
                                get_search_list(_c_number.text);
                              });
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.blue,
                            )),
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),

            // Container(
            //   height: 45,
            //   width: MediaQuery.of(context).size.width*0.9,
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(15),
            //       border: Border.all(width: 1)
            //   ),
            //   child: TextFormField(
            //       inputFormatters: [
            //         LengthLimitingTextInputFormatter(10),
            //       ],
            //       keyboardType: TextInputType.number,
            //       controller: _c_number,
            //       decoration:InputDecoration(
            //           hintText:  "farmer_no".tr,
            //           hintStyle: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold,
            //               color: Color(0xff50899f)
            //           ),
            //           contentPadding: EdgeInsets.all(10),
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide.none,
            //           )
            //       )
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 45,
            //   width: MediaQuery.of(context).size.width * 0.9,
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(15),
            //       border: Border.all(width: 1)),
            //   child: TextFormField(
            //       controller: _c_name,
            //       decoration: InputDecoration(
            //           hintText: "farmer_Name".tr,
            //           hintStyle: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold,
            //               color: Color(0xff50899f)),
            //           contentPadding: EdgeInsets.all(8),
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide.none,
            //           ))),
            // ),
            startsearch == false
                ? Text('Please_Search_or_Add_Customer'.tr)
                : FutureBuilder<List<SearchResponse>>(
                    future: get_search_list(_c_number.text),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Center(child: CircularProgressIndicator()));
                      }
                      // if (!snapshot.data == null) {
                      //   return Center(child: Text('No Data'),);
                      // }
                      else {
                        List<SearchResponse>? data = snapshot.data;
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                              child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: data!.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return data[index].mobile!.toString() ==
                                            null
                                        ? Center(
                                            child: Column(children: [
                                              Text('No Result Found'),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ]),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    'Name - ${data[index].name!}'),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    'Number - ${data[index].mobile!}'),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value: this.value,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          this.value = value!;
                                                          pnumber.text =
                                                              data[index]
                                                                  .mobile
                                                                  .toString();
                                                          _c_name.text =
                                                              data[index]
                                                                  .name
                                                                  .toString();
                                                        });
                                                      },
                                                    ),
                                                    Text('Confirm'),
                                                  ],
                                                ),

                                                // ElevatedButton(
                                                //     onPressed: () {
                                                //       setState(() {
                                                //         // startsearch = false;
                                                //         pnumber.text = data[index]
                                                //             .mobile
                                                //             .toString();
                                                //         _c_name.text = data[index]
                                                //             .name
                                                //             .toString();
                                                //       });
                                                //     },
                                                //     child: Text('Confirm')),
                                              ],
                                            ),
                                          );

                                    // Center(
                                    //   child: Text(
                                    //     data[index].name.toString(),
                                    //     style: TextStyle(fontSize: 16),
                                    //   ),
                                    // );
                                  })),
                        );
                      }
                    },
                  ),

            SizedBox(
              height: 20,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)),
              child: TextFormField(
                  controller: pnumber,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      counterText: '',
                      hintText: "farmer_no".tr,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff50899f)),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ))),
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
                  controller: _c_name,
                  decoration: InputDecoration(
                      hintText: "farmer_Name".tr,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff50899f)),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ))),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Add_New_Customer();
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>Send_Reminder()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 1)),
                    child: Center(
                      child: Text(
                        "continue".tr,
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

  var _currentIndex = 0;
}
