import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../profile_all_screen/Profile_page.dart';
import '../Home_Page.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutter_tts/flutter_tts.dart';

class Advisory_package extends StatefulWidget {
  Advisory_package({
    Key? key,
    this.title,
    this.advisry_image,
    this.advisry_title,
    this.advisry_description,
  }) : super(key: key);
  String? title;
  String? advisry_title;
  String? advisry_image;
  String? advisry_description;
  @override
  State<Advisory_package> createState() => _Advisory_packageState();
}

class _Advisory_packageState extends State<Advisory_package> {
  final FlutterTts fluttertts = FlutterTts();
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  final List<String> itemsa = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];

  var advisery;
  Future getAdvesiry() async {
    final pref = await SharedPreferences.getInstance();
    var crop_id = pref.getString("crop_id");
    Map data = {'user_crop_id': 'CRP8564892'};
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

  String? selectedValue;
  String? selectedvalue;
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  int _value = 1;
  bool convert = false;
  String? converteddiscription;

  void htmlConvert() {
    var document = parse(widget.advisry_description);
    // get_Current_task = res['response'];
    String parsedString = parse(document.body!.text).documentElement!.text;
    setState(() {
      converteddiscription = parsedString;
      convert = true;
    });

    print('de $parsedString');
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

  void speak() async {
    await fluttertts.setLanguage('en-US');
    await fluttertts.setLanguage('hi-IN');
    await fluttertts.setPitch(1);
    await fluttertts.speak(converteddiscription.toString());
    setState(() {
      isPlaying = true;
    });
  }

  void pause() async {
    await fluttertts.pause();
    setState(() {
      isPlaying = false;
    });
  }

  bool isPlaying = false;

  @override
  void initState() {
    // getAdvesiry();
    getUser();
    htmlConvert();
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
                  Container(
                    height: MediaQuery.of(context).size.height * 1.45,
                    width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: NetworkImage(
                    //     widget.advisry_image.toString(),
                    //   ),
                    // )),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.title.toString(),
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff085272)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 5.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    widget.advisry_image.toString()),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height,
                            child: Card(
                              elevation: 5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: SingleChildScrollView(
                                  child: Column(
                                      // crossAxisAlignment:CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(widget.advisry_title
                                                .toString()),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: isPlaying
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          pause();
                                                        },
                                                        child: Icon(
                                                          Icons.mic_off,
                                                        ))
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            isPlaying = true;
                                                          });
                                                          await fluttertts
                                                              .setLanguage(
                                                                  'en-US');
                                                          await fluttertts
                                                              .setLanguage(
                                                                  'hi-IN');

                                                          await fluttertts
                                                              .setPitch(1);
                                                          await fluttertts
                                                              .speak(widget
                                                                  .advisry_title!)
                                                              .whenComplete(() {
                                                            Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                                () {
                                                              setState(() {
                                                                speak();
                                                              });
                                                            });
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.mic,
                                                        ))),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                // height: 550,
                                                width: 300,
                                                child: Text(
                                                  converteddiscription
                                                      .toString(),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [],
                                        )
                                        //Text("Crop Cure or Solution",style: TextStyle(fontWeight:FontWeight.w500,color:Color(0xff709bad),)),
                                      ]),
                                ),
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
