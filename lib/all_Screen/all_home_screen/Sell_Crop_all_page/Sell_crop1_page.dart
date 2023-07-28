import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Sell_Crop_all_page/sellCrop_model/Sellcrop_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../profile_all_screen/Profile_page.dart';
import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../Home_Page.dart';
import '../Show_me_plan.dart';
import '../crop_health_page.dart';
import 'Sell_crop2_page.dart';

class Sell_crop1_page extends StatefulWidget {
  const Sell_crop1_page({Key? key}) : super(key: key);

  @override
  State<Sell_crop1_page> createState() => _Sell_crop1_pageState();
}

class _Sell_crop1_pageState extends State<Sell_crop1_page> {
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  String? imageList;
  String? imagename;
  List<String> img = [
    "assets/slid1.jpg",
    "assets/slid2.jpg",
    "assets/slid3.jpg",
    "assets/slid4.jpg",
    "assets/slid5.jpg"
  ];

  bool bannerloading = false;
  Future bannerTop() async {
    setState(() {
      bannerloading = true;
    });
    Map data = {
      'screen_id': '1',
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
    // }
  }

  String? crop_id;
  void _setValue(crop_id) async {
    final pref = await SharedPreferences.getInstance();
    final set1 = pref.setString('crop_id', crop_id);
    print("user_id  %%==>>>=++++" + set1.toString());
  }

  String? search;
  var cropName, cropImage, Crop_id;
  TextEditingController carsearch = TextEditingController();
  Future<List<StatusMessage>> getSellCrop() async {
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_crop");
    // var body1= jsonEncode(data1);
    var response = await http.post(url);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      // List data=json.decode(response.body)["response2"];
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["status_message"];
      setState(() {
        setState(() {
          // crop_id=map["crop_id"];
          // _setValue(crop_id);
        });
      });

      return data.map((data) => StatusMessage.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
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

  String msg = '';

  List banner1_list = [];
  bool imageloading = false;
  Future getBannerList2() async {
    var api =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_ads_banner");
    final response = await http.post(
      api,
    );
    var res = await json.decode(response.body);
    msg = res['message'].toString();
    if (msg == "Record found") {
      setState(() {
        banner1_list = res['data'];
        imageloading = true;
      });
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
    super.initState();
    // setState(() {
    getUser();
    getSellCrop();
    bannerTop();
    _setValue(crop_id);
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: bannerloading
                          ? CircularProgressIndicator()
                          : Container(
                              child: Image.network(imageList!),
                            ),
                      // CarouselSlider(
                      //     options: CarouselOptions(
                      //         aspectRatio: 2.0,
                      //         enlargeCenterPage: true,
                      //         scrollDirection: Axis.horizontal,
                      //         autoPlay: true,
                      //         viewportFraction: 1),
                      //     items: [
                      //       for (var i = 0; i < img.length; i++)
                      //         bannerloading
                      //             ? Card(
                      //                 elevation: 5,
                      //                 shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10)),
                      //                 child: Container(
                      //                   // width: MediaQuery.of(context).size.width,
                      //                   decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10),
                      //                   ),
                      //                   child: ClipRRect(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10),
                      //                     child: Image.asset(
                      //                         // imageList[i]['banner_img'].toString(),
                      //                         img[i].toString(),
                      //                         fit: BoxFit.fill),
                      //                   ),
                      //                 ),
                      //               )
                      //             : Container(
                      //                 child: Center(
                      //                   child: CupertinoActivityIndicator(
                      //                       color: Colors.green, radius: 30),
                      //                 ),
                      //               )
                      //     ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Sell_crop".tr,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff447c94)),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          cursorHeight: 25,
                          textInputAction: TextInputAction.search,
                          controller: carsearch,
                          onChanged: (String? value) {
                            setState(() {
                              search = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 2),
                            suffixIcon: Icon(
                              Icons.search,
                              color: Color(0xff447c94),
                            ),
                            prefixText: "     ",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black45),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black45),
                            ),
                            hintText: 'Search Your Crop',
                            hintStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("choose_your_product".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff759eb0),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<StatusMessage>>(
                            future: getSellCrop(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<StatusMessage>? data = snapshot.data;
                                return Container(
                                  child: GridView.builder(
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      itemCount: data!.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        String? postion =
                                            data[index].cropName.toString();
                                        if (carsearch.text.isEmpty) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                cropName = data[index]
                                                    .cropName
                                                    .toString();
                                                cropImage =
                                                    data[index].img.toString();
                                                Crop_id = data[index]
                                                    .cropId
                                                    .toString();
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Sell_crop2_page(
                                                            cropName: cropName
                                                                .toString(),
                                                            cropImage: cropImage
                                                                .toString(),
                                                            Crop_id: Crop_id
                                                                .toString(),
                                                          )));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  //color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                data[index]
                                                                    .img
                                                                    .toString()))),
                                                  ),
                                                  Text(
                                                    data[index]
                                                        .cropName
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff447c95)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else if (postion
                                            .toLowerCase()
                                            .contains(
                                                carsearch.text.toLowerCase())) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                cropName = data[index]
                                                    .cropName
                                                    .toString();
                                                cropImage =
                                                    data[index].img.toString();
                                                Crop_id = data[index]
                                                    .cropId
                                                    .toString();
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Sell_crop2_page(
                                                            cropName: cropName
                                                                .toString(),
                                                            cropImage: cropImage
                                                                .toString(),
                                                            Crop_id: Crop_id
                                                                .toString(),
                                                          )));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  //color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                data[index]
                                                                    .img
                                                                    .toString()))),
                                                  ),
                                                  Text(
                                                    data[index]
                                                        .cropName
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff447c95)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                );
                              }
                            })
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // bottomSheet:
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
