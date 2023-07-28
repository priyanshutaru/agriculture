import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_calendar.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Home_Page.dart';
import 'Show_me_plan.dart';

class Crop_calender extends StatefulWidget {
  Crop_calender(
      {Key? key,
      this.cropImage,
      this.cropName,
      this.cropId,
      this.user_id,
      this.planid})
      : super(key: key);
  String? cropName;
  String? cropImage;
  String? cropId;
  String? user_id;
  String? planid;
  @override
  State<Crop_calender> createState() => _Crop_calenderState();
}

class _Crop_calenderState extends State<Crop_calender> {
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  final List<String> itemsa = [
    '1',
    '2',
    '3',
    '4',
  ];
  static DateTime date = DateTime.now();
  static var DropDate = "Date of Sowing";
  String? selectedValue;
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  bool loading = false;
  // Future getUserPlans() async{
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString("user_id");
  //   Map data ={
  //     'user_id':user_id.toString(),
  //     'user_cropID': {widget.user_id.toString()},
  //     'user_planID': {widget.planid.toString()},
  //     'user_date_of_showing':date.toString(),
  //   };
  //   var url = Uri.parse("https://doplus.creditmywallet.in.net/api/user_crop_plan");
  //   var data1 =await jsonEncode(data);
  //   final response = await http.post(url, body: data1);
  //   var res =await jsonDecode(response.body);
  //   setState(() {
  //     print(response.toString()+"@@@@@@@@@@");
  //     print(res.toString()+"@@@@@@@@@@>>>>>>>>>>>>");
  //   });
  // }

  // Future getUserPlans() async {
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   var dio = Dio();
  //   Map data = {
  //     'user_id': user_id.toString(),
  //     'user_cropID': widget.cropId.toString(),
  //     'user_planID': widget.planid.toString(),
  //     'user_date_of_showing': date.toString(),
  //   };

  //   var response = await dio.post(
  //       'https://doplus.creditmywallet.in.net/api/user_crop_plan',
  //       data: data);
  //   print(data.toString() + "all formData>>>>>>>@@@@@@@@@");
  //   print("response ====>>>" + response.toString());
  //   var res = jsonDecode(response.data)['response'];
  //   int msg = res['status_code'];
  //   print("bjhgbvfjhdfgbfu====>..." + msg.toString());
  //   if (msg == 200) {
  //     Fluttertoast.showToast(msg: msg.toString());
  //     setState(() {
  //       Fluttertoast.showToast(
  //           msg: "Crop Plans Created Successfully",
  //           backgroundColor: Colors.green,
  //           gravity: ToastGravity.BOTTOM);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Show_me_plan(
  //                     cropName: "${widget.cropName}",
  //                     cropImage: "${widget.cropImage}",
  //                     cropId: "${widget.cropId}",
  //                     planid: "${widget.planid}",
  //                   )));
  //     });
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: 'Server Error..',
  //         backgroundColor: Colors.red,
  //         gravity: ToastGravity.CENTER);
  //   }
  // }
  Future getUserPlans() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
      'user_cropID': widget.cropId.toString(),
      'user_planID': widget.planid.toString(),
      'user_date_of_showing': date.toString(),
    };
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/user_crop_plan");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    // var res = jsonDecode(response.body)['response'];
    if (response.statusCode == 200) {
      setState(() {
        Fluttertoast.showToast(msg: response.statusCode.toString());
        setState(() {
          Fluttertoast.showToast(
              msg: "${response.statusCode}",
              backgroundColor: Colors.green,
              gravity: ToastGravity.BOTTOM);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Show_me_plan(
                cropName: "${widget.cropName}",
                cropImage: "${widget.cropImage}",
                cropId: "${widget.cropId}",
                planid: "${widget.planid}",
              ),
            ),
          );
        });
        loading = false;
      });
    }
  }

  String? imageList;
  List<String> img = [
    "assets/slid1.jpg",
    "assets/slid2.jpg",
    "assets/slid3.jpg",
    "assets/slid4.jpg",
    "assets/slid5.jpg"
  ];
  bool isloading = true;
  bool bannerloading = true;
  Future bannerTop() async {
    setState(() {
      bannerloading = true;
    });
    Map data = {
      'screen_id': '4',
    };
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_ads_banner");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    // if (response.statusCode == 200) {
    setState(() {
      bannerloading = false;
      imageList = res['image'];
    });
  }

  String? have_crop_plan;

  Future checkcroplist() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/check_user_task_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['have_crop_plan'];
    setState(() {
      have_crop_plan = res.toString();
      print(have_crop_plan);
    });
  }

  String? name, number, mainimg;
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
      name = res["name"];
      number = res['mobile'];
      mainimg = res['img'].toString();
      print(user_id.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  List unitItemlist = [];
  List varirtylist = [];
  String? selectedvalue;
  TextEditingController quantity = TextEditingController();

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
    // setState(() {
    bannerTop();
    getAllUnit();
    getUser();
    checkcroplist();
    // getUserPlans();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              loading
                  ? CircularProgressIndicator()
                  : Column(
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
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bannerloading
                                ? Center(child: CircularProgressIndicator())
                                : Container(
                                    child: Image.network(imageList!),
                                  ),
                            // Center(
                            //   child: CarouselSlider(
                            //       options: CarouselOptions(
                            //           aspectRatio: 2.0,
                            //           enlargeCenterPage: true,
                            //           scrollDirection: Axis.horizontal,
                            //           autoPlay: true,
                            //           viewportFraction: 1),
                            //       items: [
                            //         for (var i = 0; i < img.length; i++)
                            //           bannerloading
                            //               ? Card(
                            //                   elevation: 5,
                            //                   child: Container(
                            //                     width: MediaQuery.of(context)
                            //                         .size
                            //                         .width,
                            //                     decoration: BoxDecoration(
                            //                       borderRadius:
                            //                           BorderRadius.circular(10),
                            //                     ),
                            //                     child: ClipRRect(
                            //                       borderRadius:
                            //                           BorderRadius.circular(10),
                            //                       child: Image.asset(
                            //                           // imageList[i]['banner_img'].toString(),
                            //                           img[i].toString(),
                            //                           fit: BoxFit.fill),
                            //                     ),
                            //                   ),
                            //                 )
                            //               : Container(
                            //                   child: Center(
                            //                     child:
                            //                         CupertinoActivityIndicator(
                            //                             color: Colors.green,
                            //                             radius: 30),
                            //                   ),
                            //                 )
                            //       ]),
                            // ),

                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "crop_calender".tr,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff447c94)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                Text("your_selected_crop".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff759eb0),
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    "${widget.cropImage.toString()}"))),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "${widget.cropName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff447c95),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                // Container(
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(
                                //       width: 0.7, color: Color(0xffD1D1D1),),
                                //     borderRadius: BorderRadius.circular(5),
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Container(
                                //         height: 38,
                                //         width: 95,
                                //         decoration: BoxDecoration(
                                //             color: Color(0xfff0f0f0),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                   color: Color(0xffD1D1D1),
                                //                   spreadRadius: 1),
                                //             ],
                                //             borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(5),
                                //                 bottomLeft: Radius.circular(5))
                                //         ),
                                //         padding: EdgeInsets.only(left: 10),
                                //         child: Center(
                                //           child: DropdownButtonHideUnderline(
                                //             child: DropdownButton(
                                //               hint: Text(
                                //                 'Unit',
                                //                 style: TextStyle(
                                //                     fontSize: 14,
                                //                     color: Color(0xff508399),
                                //                     fontWeight: FontWeight.w600
                                //                 ),
                                //               ),
                                //               items: unitItemlist.map((item) =>
                                //                   DropdownMenuItem<String>(
                                //                     value: item['unit_id']
                                //                         .toString(),
                                //                     child: Text(
                                //                       item['unit_name']
                                //                           .toString(),
                                //                       style: TextStyle(
                                //                         fontSize: 14,),
                                //                     ),
                                //                   ))
                                //                   .toList(),
                                //               value: selectedvalue,
                                //               onChanged: (value) {
                                //                 setState(() {
                                //                   selectedvalue =
                                //                   value as String;
                                //                   print("Unit id==>>" +
                                //                       selectedvalue.toString());
                                //                 });
                                //               },
                                //               iconSize: 25,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         child: TextFormField(
                                //           controller: quantity,
                                //           keyboardType: TextInputType.number,
                                //           inputFormatters: [
                                //             LengthLimitingTextInputFormatter(5)
                                //           ],
                                //           decoration: InputDecoration(
                                //             contentPadding: EdgeInsets.only(
                                //                 left: 20, bottom: 7),
                                //             fillColor: Color(0xfff5fcff),
                                //             filled: true,
                                //             hintText: "Enter Land Size",
                                //             hintStyle: TextStyle(fontSize: 13,
                                //               color: Color(0xff447c95),),
                                //             border: OutlineInputBorder(
                                //               borderSide: BorderSide.none,
                                //               borderRadius: BorderRadius.only(
                                //                   topRight: Radius.circular(5),
                                //                   bottomRight: Radius.circular(
                                //                       5)
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    decoration: BoxDecoration(),
                                    child: InkWell(
                                      onTap: () async {
                                        await showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(2030),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Color(
                                                      0xff00aeef), // header background color
                                                  onPrimary: Colors
                                                      .white, // header text color
                                                  onSurface: Color(
                                                      0xff00aeef), // body text color
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        ).then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              date = selectedDate;
                                              DropDate =
                                                  DateFormat('d MMM, yyyy')
                                                      .format(date);
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Color(0xfff5fcff),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.black12)),
                                          child: Row(
                                            children: [
                                              Container(
                                                  width: 90,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xfff0f0f0),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        bottomLeft:
                                                            Radius.circular(5),
                                                      )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                            "assets/calendar3.png",
                                                          ),
                                                          height: 40,
                                                        ),
                                                        Spacer(),
                                                        Icon(Icons
                                                            .arrow_drop_down_sharp)
                                                      ],
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 18,
                                              ),
                                              Text(DropDate,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xff447c95),
                                                  )),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: 25,),
                                // Container(
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(width: 0.7,color:  Color(0xffD1D1D1),),
                                //     borderRadius: BorderRadius.circular(5),
                                //   ),
                                //   child:  Row(
                                //     children: [
                                //       Container(
                                //         height: 38,
                                //         width: 98,
                                //         decoration: BoxDecoration(
                                //             color: Color(0xfff0f0f0),
                                //             boxShadow: [
                                //               BoxShadow(color: Color(0xffC4C4C4), spreadRadius: 1),
                                //             ],
                                //             borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5))
                                //         ),
                                //         padding: EdgeInsets.only(left: 10),
                                //         child: Row(
                                //           children: [
                                //             Image(image: AssetImage("assets/calendar3.png"),height: 35,),
                                //             SizedBox(width: 20,),
                                //             Icon(Icons.arrow_drop_down,size: 25,)
                                //           ],
                                //         )
                                //       ),
                                //       Expanded(
                                //         child: Container(
                                //           height: 38,
                                //           padding: EdgeInsets.only(left: 20,top: 10),
                                //           decoration: BoxDecoration(
                                //             color: Color(0xfff5fcff),
                                //             borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5), )
                                //           ),
                                //           child: Text("Date of Sowing",style:  TextStyle(fontSize: 13,color: Color(0xff447c95),)),
                                //         )
                                //       )
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 50,
                                ),
                                Card(
                                  elevation: 3,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(23))),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color(0xff65ac2b),
                                    ),
                                    child: MaterialButton(
                                        height: 45,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        highlightColor: Colors.redAccent,
                                        onPressed: () {
                                          if (date != null) {
                                            getUserPlans();
                                          }
                                        },
                                        child: Text(
                                          "Show me Plan",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
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
                have_crop_plan == 'yes'
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Show_me_plan()))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Crop_calendar()));
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
