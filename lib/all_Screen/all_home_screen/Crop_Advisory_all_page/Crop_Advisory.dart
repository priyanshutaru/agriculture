import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/crop_advisery_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/crop_by_season_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../profile_all_screen/Profile_page.dart';
import '../Home_Page.dart';
import '../Sell_Crop_all_page/sellCrop_model/Sellcrop_model.dart';
import '../Show_me_plan.dart';
import '../crop_health_page.dart';
import '../cropp_calender_page.dart';
import 'Get_Advisory_page.dart';

class Crop_Advisory extends StatefulWidget {
  const Crop_Advisory({Key? key}) : super(key: key);

  @override
  State<Crop_Advisory> createState() => _Crop_AdvisoryState();
}

class _Crop_AdvisoryState extends State<Crop_Advisory> {
  int _currentIndex = 3;
  String dropdownvalue = 'भाषा/Language';
  final List<String> itemsa = [
    // 'Kharif/खरीफ',
    // 'Rabi/रबी',
    // 'Zaid/ज़ैद',
    'Kharif',
    'Rabi',
    'Zaid',
  ];
  String? selectedValue;
  String? selectedvalue;
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  List getcrop = [];
  String? get_crop;
  Future getCrop() async {
    var uri = Uri.parse('https://doplus.creditmywallet.in.net/api/get_crop');
    final response = await http.post(uri);
    var res = jsonDecode(response.body)['status_message'];
    if (response.statusCode == 200) {
      setState(() {
        getcrop = res;
        print(response.toString() + "ccccccccccccccccccccc");
      });
    }
  }

  String? cropid, crop_name, image;

  Future<List<GetCropByResponse>> get_crop_by_season_list() async {
    Map data = {
      'season': selectedValue.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_crop_by_season");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      // print(data);
      return data.map((data) => GetCropByResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  // Future<List<CropBySeasonResponse>> getCropsbyseason() async {
  //   var url = Uri.parse(
  //       "https://doplus.creditmywallet.in.net/api/get_crop_by_season");
  //   Map data = {
  //     'season': 'Kharif',
  //   };
  //   var data1 = jsonEncode(data);
  //   var response = await http.post(
  //     url,
  //     body: data1,
  //   );
  //   print(data);
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     List<dynamic> data = map["status_message"];
  //     return data.map((data) => CropBySeasonResponse.fromJson(data)).toList();
  //   } else {
  //     throw Exception('unexpected error occurred');
  //   }
  // }

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  bool bannerloading = true;
  String? imageList;

  Future bannerTop() async {
    setState(() {
      bannerloading = true;
    });
    Map data = {
      'screen_id': '6',
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

  Future<List<CropBySeasonResponse>> getSellCrop() async {
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_crop");
    var response = await http.post(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["status_message"];
      return data.map((data) => CropBySeasonResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  int _value = 1;
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

  @override
  void initState() {
    // getCrop();
    // getCrops();
    // getCropsbyseason();
    // get_crop_by_season_list();
    getUser();
    bannerTop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                                    height: 0,
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
            Expanded(
              child: ListView(
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 5,
                  //   width: MediaQuery.of(context).size.width * 0.9,

                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //   fit: BoxFit.fill,
                        //   image: AssetImage("assets/background.jpg"),
                        // )
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            bannerloading
                                ? CircularProgressIndicator()
                                : Container(
                                    child: Image.network(imageList!),
                                  ),
                            Row(
                              children: [
                                Text(
                                  "crop_advisory".tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff085272)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Color(0xff707070)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: Text(
                                    'Choose_season'.tr,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff2F3B40),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  items: itemsa
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String;
                                      get_crop_by_season_list();
                                    });
                                  },
                                  // buttonHeight: 40,
                                  // itemHeight: 40,
                                  // iconSize: 25,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            // Container(
                            //   height: 40,
                            //   width: MediaQuery.of(context).size.width,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 0),
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //         width: 1, color: Color(0xff707070)),
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton(
                            //       hint: Text(
                            //         'Select Crop',
                            //         style: TextStyle(
                            //             fontSize: 13,
                            //             color: Color(0xff2F3B40),
                            //             fontWeight: FontWeight.w500),
                            //       ),
                            //       items: getcrop
                            //           .map((item) => DropdownMenuItem<String>(
                            //                 value: item['crop_id'],
                            //                 child: Text(
                            //                   item['crop_name'],
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                   ),
                            //                 ),
                            //               ))
                            //           .toList(),
                            //       value: get_crop,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           get_crop = value as String;
                            //         });
                            //       },
                            //       // buttonHeight: 40,
                            //       // itemHeight: 40,
                            //       // iconSize: 25,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            // Column(
                            //   children: [
                            //     Container(
                            //       height: 80,
                            //       width: 80,
                            //       decoration: BoxDecoration(
                            //           image: DecorationImage(
                            //               image:
                            //                   AssetImage("assets/sellcrop.png"))),
                            //     ),
                            //     Text(
                            //       "Crop",
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w500,
                            //         color: Color(0xff2F3B40),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            selectedValue == null
                                ? Center(
                                    child:
                                        Text('Please_select_Season_First'.tr),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<GetCropByResponse>>(
                                          future: get_crop_by_season_list(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else {
                                              List<GetCropByResponse>? data =
                                                  snapshot.data;

                                              return Container(
                                                // height: MediaQuery.of(context)
                                                //         .size
                                                //         .height *
                                                //     0.5,
                                                padding: EdgeInsets.only(bottom: 50),
                                                child: GridView.builder(
                                                    physics: ScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                    ),
                                                    itemCount: data!.length,
                                                    itemBuilder:
                                                        (BuildContext ctx,
                                                            index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(2,2,2,2),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Get_Advisory(
                                                                              cropId: data[index].cropId,
                                                                              cropImage: data[index].img,
                                                                              cropName: data[index].cropName.toString(),
                                                                              planid: data[index].planId.toString(),
                                                                              cropNameHindi: data[index].cropNameHindi.toString(),
                                                                            )));
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                                    //color: Colors.white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    height: 80,
                                                                    width: 110,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15),
                                                                        image: DecorationImage(
                                                                            fit: BoxFit
                                                                                .fill,
                                                                            image: NetworkImage(data[index]
                                                                                .img
                                                                                .toString()))),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          80,
                                                                      width:
                                                                          110,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black38,
                                                                          borderRadius:
                                                                              BorderRadius.circular(15)),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Text(
                                                                                  data[index].cropName.toString(),
                                                                                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              );
                                            }
                                          })
                                    ],
                                  ),

                            // SizedBox(
                            //   height: 25,
                            // ),
                            // Card(
                            //   elevation: 3,
                            //   shape: ContinuousRectangleBorder(
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(23))),
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     height: 45,
                            //     decoration: BoxDecoration(
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(10)),
                            //       color: Color(0xff65ac2b),
                            //     ),
                            //     child: MaterialButton(
                            //         height: 45,
                            //         minWidth: MediaQuery.of(context).size.width,
                            //         highlightColor: Colors.redAccent,
                            //         onPressed: () {
                            //           setState(() {
                            //             // LoginApi();
                            //             Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         Get_Advisory()));
                            //           });
                            //         },
                            //         child: Text(
                            //           "Get Advisory",
                            //           style: TextStyle(
                            //               fontSize: 16,
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),
                            //         )),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
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
