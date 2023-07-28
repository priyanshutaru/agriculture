import 'dart:convert';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateCropPlan extends StatefulWidget {
  const GenerateCropPlan({Key? key}) : super(key: key);
  @override
  State<GenerateCropPlan> createState() => _GenerateCropPlanState();
}

class _GenerateCropPlanState extends State<GenerateCropPlan> {
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  bool isloading = true;
  List imageList = [];
  List<String> img = [
    "assets/slid1.jpg",
    "assets/slid2.jpg",
    "assets/slid3.jpg",
    "assets/slid4.jpg",
    "assets/slid5.jpg"
  ];
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
      mainimg = res['img'].toString();;
      print(user_id.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  bool bannerloading = true;
  Future bannerTop() async {
    var api = Uri.parse("https://onway.creditmywallet.in.net/api/banner_top");
    final response = await http.get(
      api,
    );
    var res = await json.decode(response.body);
    var msg = res['status_message'].toString();
    if (msg == "Success") {
      setState(() {
        bannerloading = true;
        imageList = res['response_userRegister'];
        isloading = true;
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

  static DateTime date = DateTime.now();
  static var DropDate = "Start_date".tr;
  List varirtylist = [];
  String? selectedValue;
  Future getAllvarity() async {
    var baseUrl = "https://doplus.creditmywallet.in.net/api/get_variety";
    http.Response response = await http.post(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        varirtylist = jsonData;
        print("@@@@@@@@@@@@@@@@===>>>>>>" + varirtylist.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    getAllvarity();
    getUser();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile_page()));
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
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: TextButton(
                                    onPressed: () {
                                      updateLanguage(Locale('hi', 'IN'));
                                    },
                                    child: Text(
                                      "हिन्दी/Hindi",
                                      style: TextStyle(fontSize: 12),
                                    )),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                  child: TextButton(
                                      onPressed: () {
                                        updateLanguage(Locale('en', 'US'));
                                      },
                                      child: Text(
                                        "इंग्लिश/English",
                                        style: TextStyle(fontSize: 12),
                                      )),
                                  value: 3),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _value = int.parse(value.toString());
                              });
                            }),
                      ),
                      // DropdownButton(
                      //   style: TextStyle(
                      //       fontSize: 11,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color(0xff00aeef)),
                      //   iconEnabledColor: Colors.black87,
                      //   iconSize: 25,
                      //   elevation: 00,
                      //   underline: SizedBox(),
                      //   value: dropdownvalue,
                      //   icon: const Icon(
                      //     Icons.arrow_drop_down,
                      //   ),
                      //   items: items.map((String items) {
                      //     return DropdownMenuItem(
                      //       value: items,
                      //       child: Column(
                      //         children: [
                      //           Text('भाषा/Language'),
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               updateLanguage(
                      //                   Locale('hi', 'IN'));
                      //               // var locale = Locale('hi', 'IN');
                      //               // Get.updateLocale(locale);
                      //             },
                      //             child: Text('हिन्दी/Hindi'),
                      //           ),
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               updateLanguage(
                      //                   Locale('en', 'US'));

                      //               // var locale = Locale('en', 'US');
                      //               // Get.updateLocale(locale);
                      //             },
                      //             child: Text('इंग्लिश/English'),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       dropdownvalue = newValue!;
                      //     });
                      //   },
                      // ),
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
                                        Uri.encodeComponent('9936868049'));
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
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: CarouselSlider(
                      options: CarouselOptions(
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          viewportFraction: 1),
                      items: [
                        for (var i = 0; i < img.length; i++)
                          bannerloading
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 5,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                          //imageList[i]['banner_img'].toString(),
                                          img[i].toString(),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                        color: Colors.green, radius: 30),
                                  ),
                                )
                      ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfff5fcff),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(
                        'variety_of_crop'.tr,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff508399),
                            fontWeight: FontWeight.w600),
                      ),
                      items: varirtylist
                          .map((item) => DropdownMenuItem<String>(
                                value: item['variety_name'].toString(),
                                child: Text(
                                  item['variety_name'].toString(),
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
                          print("variety_name==>>" + selectedValue.toString());
                        });
                      },
                      iconSize: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
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
                                onPrimary: Colors.white, // header text color
                                onSurface: Color(0xff00aeef), // body text color
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
                                DateFormat('d MMM yyyy').format(selectedDate);
                          });
                        }
                      });
                    },
                    child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Color(0xfff5fcff),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12)),
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/calendar3.png"),
                              height: 35,
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Text(
                              DropDate,
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color(0xff66ad2d),
              borderRadius: BorderRadius.circular(10),
            ),
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Generate Crop Plans",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          )
        ]),
      ),
    ));
  }
}
