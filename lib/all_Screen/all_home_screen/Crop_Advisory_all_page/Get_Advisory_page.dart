import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/crop_desease_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/package_practice_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../All_Model/show_me_plan_model.dart';
import '../../../profile_all_screen/Profile_page.dart';
import '../Home_Page.dart';
import '../Show_me_plan.dart';
import '../crop_health_page.dart';
import 'Advisory_package.dart';

class Get_Advisory extends StatefulWidget {
  Get_Advisory(
      {Key? key,
      this.cropImage,
      this.cropName,
      this.cropId,
      this.planid,
      this.cropNameHindi})
      : super(key: key);
  String? cropName;
  String? cropImage;
  String? cropId;
  String? planid;
  String? cropNameHindi;

  @override
  State<Get_Advisory> createState() => _Get_AdvisoryState();
}

class _Get_AdvisoryState extends State<Get_Advisory>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];

  bool _switchValue = false;

  var advisery;
  Future getAdvesiry() async {
    final pref = await SharedPreferences.getInstance();
    var crop_id = pref.getString("crop_id");
    Map data = {'user_crop_id': crop_id.toString()};
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_advisary_data");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      advisery = res['response'];
      print(advisery.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  void _Setcrop_id(value) async {
    final pref = await SharedPreferences.getInstance();
    var cropId = pref.setString("crop_id", value);
  }

  Future<List<Response>> getCrops() async {
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_advisary_data");
    var response = await http.post(
      url,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["status_message"];
      return data.map((data) => Response.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<AllPracticesResponse>> get_all_practices() async {
    Map data = {
      'user_crop_id': widget.cropId,
    };
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_advisary_data");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      // print(data);
      return data.map((data) => AllPracticesResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<CropDesaesesResponse>> get_all_crop_disease() async {
    Map data = {
      'crop_id': widget.cropId,
    };
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_disease_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response"];
      // print(data);
      return data.map((data) => CropDesaesesResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  String language = 'hin';

  TabController? _tabController;
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    g.Get.back();
    g.Get.updateLocale(locale);
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

  int _value = 1;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
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
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: AssetImage("assets/background.jpg"),
                    // )
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "crop_calender".tr,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff447c94)),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white, // background
                                      onPrimary: Colors.red, // foreground
                                    ),
                                    child: Text(
                                      'English',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        language = 'eng';
                                        get_all_practices();
                                        get_all_crop_disease();
                                        Fluttertoast.showToast(
                                            msg: 'English',
                                            backgroundColor: Colors.green,
                                            gravity: ToastGravity.BOTTOM);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white, // background
                                      onPrimary: Colors.purple, // foreground
                                    ),
                                    child: Text(
                                      'हिन्दी',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        language = 'hin';
                                        get_all_practices();
                                        get_all_crop_disease();
                                        Fluttertoast.showToast(
                                            msg: 'हिन्दी',
                                            backgroundColor: Colors.green,
                                            gravity: ToastGravity.BOTTOM);
                                      });
                                    },
                                  ),
                                  // CupertinoSwitch(
                                  //   value: _switchValue,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       _switchValue = value;
                                  //     });
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Card(
                            elevation: 3,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.cropImage!))),
                                      ),
                                      Text(
                                        widget.cropName! +
                                            "\n" +
                                            widget.cropNameHindi!,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff2F3B40)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Card(
                            elevation: 5,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                // give the indicator a decoration (color and border radius)
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black54,
                                indicator: BoxDecoration(
                                  //border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green,
                                ),
                                tabs: [
                                  // first tab [you can add an icon using the icon property]
                                  Tab(
                                    text: 'Package of Practices',
                                  ),

                                  // second tab [you can add an icon using the icon property]
                                  Tab(
                                    text: 'Crop_Protection'.tr,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          // tab bar view here
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // first tab bar view widget
                                  ListView(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<
                                                      List<
                                                          AllPracticesResponse>>(
                                                  future: get_all_practices(),
                                                  builder: (context,
                                                      AsyncSnapshot snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else {
                                                      List<AllPracticesResponse>?
                                                          data = snapshot.data;

                                                      return Container(
                                                        // height: MediaQuery.of(
                                                        //             context)
                                                        //         .size
                                                        //         .height *
                                                        //     0.5,
                                                        child: GridView.builder(
                                                            physics:
                                                                ScrollPhysics(),
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 3,
                                                            ),
                                                            itemCount:
                                                                data!.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        ctx,
                                                                    index) {
                                                              return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: data[index]
                                                                              .advisoryLanguage
                                                                              .toString() ==
                                                                          language
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Advisory_package(
                                                                                          title: 'Package of Practices',
                                                                                          advisry_image: data[index].advisryImage,
                                                                                          advisry_description: data[index].advisryDescription,
                                                                                          advisry_title: data[index].advisryTitle,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                                //color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 80,
                                                                                  width: 110,
                                                                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(data[index].advisryImage.toString()))),
                                                                                  child: Container(
                                                                                    height: 80,
                                                                                    width: 110,
                                                                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        data[index].advisryTitle.toString(),
                                                                                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 9),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Advisory_package(
                                                                                          title: 'Crop Protection',
                                                                                          advisry_image: data[index].advisryImage,
                                                                                          advisry_description: data[index].advisary_des_hindi,
                                                                                          advisry_title: data[index].advisary_title_hindi,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                                //color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 80,
                                                                                  width: 110,
                                                                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(data[index].advisryImage.toString()))),
                                                                                  child: Container(
                                                                                    height: 80,
                                                                                    width: 110,
                                                                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        data[index].advisary_title_hindi.toString(),
                                                                                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 9),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ));
                                                            }),
                                                      );
                                                    }
                                                  })
                                            ],
                                          ),
                                          // GridView.builder(
                                          //     // physics: NeverScrollableScrollPhysics(),
                                          //     scrollDirection: Axis.vertical,
                                          //     shrinkWrap: true,
                                          //     gridDelegate:
                                          //         SliverGridDelegateWithFixedCrossAxisCount(
                                          //       crossAxisCount: 3,
                                          //     ),
                                          //     itemCount: 6,
                                          //     itemBuilder:
                                          //         (BuildContext ctx, index) {
                                          //       return InkWell(
                                          //         onTap: () {
                                          //           Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                   builder: (context) =>
                                          //                       Advisory_package()));
                                          //         },
                                          //         child: Container(
                                          //           alignment: Alignment.center,
                                          //           decoration: BoxDecoration(
                                          //               //color: Colors.white,
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(10)),
                                          //           child: Column(
                                          //             children: [
                                          //               Container(
                                          //                 height: 90,
                                          //                 width: 100,
                                          //                 decoration: BoxDecoration(
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 10),
                                          //                     image: DecorationImage(
                                          //                         fit: BoxFit
                                          //                             .fill,
                                          //                         image: AssetImage(
                                          //                             "assets/gwla.jpg"))),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       );
                                          //     }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // second tab bar view widget
                                  ListView(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<
                                                      List<
                                                          CropDesaesesResponse>>(
                                                  future:
                                                      get_all_crop_disease(),
                                                  builder: (context,
                                                      AsyncSnapshot snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else {
                                                      List<CropDesaesesResponse>?
                                                          data = snapshot.data;

                                                      return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                        child: GridView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 3,
                                                            ),
                                                            itemCount:
                                                                data!.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        ctx,
                                                                    index) {
                                                              return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: data[index]
                                                                              .diseaseLanguage
                                                                              .toString() ==
                                                                          language
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Advisory_package(
                                                                                          title: 'Crop Protection'.tr,
                                                                                          advisry_image: data[index].disesImage,
                                                                                          advisry_description: data[index].disesDescription,
                                                                                          advisry_title: data[index].disesTitle,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                                //color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 80,
                                                                                  width: 110,
                                                                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(data[index].disesImage.toString()))),
                                                                                  child: Container(
                                                                                    height: 80,
                                                                                    width: 110,
                                                                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        data[index].disesTitle.toString(),
                                                                                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 9),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Advisory_package(
                                                                                          title: 'Crop Protection'.tr,
                                                                                          advisry_image: data[index].disesImage,
                                                                                          advisry_description: data[index].disease_dis_hindi,
                                                                                          advisry_title: data[index].disease_title_hindi,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                                //color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: 80,
                                                                                  width: 110,
                                                                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(data[index].disesImage.toString()))),
                                                                                  child: Container(
                                                                                    height: 80,
                                                                                    width: 110,
                                                                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        data[index].disease_title_hindi.toString(),
                                                                                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 9),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ));
                                                            }),
                                                      );
                                                    }
                                                  })
                                            ],
                                          ),

                                          // GridView.builder(
                                          //     physics:
                                          //         NeverScrollableScrollPhysics(),
                                          //     scrollDirection: Axis.vertical,
                                          //     shrinkWrap: true,
                                          //     gridDelegate:
                                          //         SliverGridDelegateWithFixedCrossAxisCount(
                                          //       crossAxisCount: 3,
                                          //     ),
                                          //     itemCount: 4,
                                          //     itemBuilder:
                                          //         (BuildContext ctx, index) {
                                          //       return InkWell(
                                          //         onTap: () {
                                          //           Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                   builder: (context) =>
                                          //                       Advisory_package()));
                                          //         },
                                          //         child: Container(
                                          //           alignment: Alignment.center,
                                          //           decoration: BoxDecoration(
                                          //               //color: Colors.white,
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(8)),
                                          //           child: Column(
                                          //             children: [
                                          //               Container(
                                          //                 height: 90,
                                          //                 width: 100,
                                          //                 decoration: BoxDecoration(
                                          //                     image: DecorationImage(
                                          //                         fit: BoxFit
                                          //                             .fill,
                                          //                         image: AssetImage(
                                          //                             "assets/gwla.jpg"))),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       );
                                          //     }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
