import 'dart:convert';
import 'dart:io';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Crop_health_Solution.dart';
import 'Home_Page.dart';
import 'Sell_Crop_all_page/sellCrop_model/Sellcrop_model.dart';

class crop_health extends StatefulWidget {
  const crop_health({Key? key}) : super(key: key);

  @override
  State<crop_health> createState() => _crop_healthState();
}

class _crop_healthState extends State<crop_health> {
  int _currentIndex = 1;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  final List<String> itemsa = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;
  final picker = ImagePicker();
  File? CropImage;
  Future CropImage1(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        CropImage = new File(pickedFile.path);
        print(CropImage!.path);
      });
    }
  }

  bool loading = false;

  Future check_health() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    String addhar1 = CropImage!.path.split('/').last;
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': user_id.toString(),
      'crop_id': get_crop.toString(),
      'disease_image':
          await MultipartFile.fromFile(CropImage!.path, filename: addhar1),
    });
    print(formData.toString());
    var response = await dio.post(
        'https://doplus.creditmywallet.in.net/api/check_health',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    var msg = res['status_code'];
    print("bjhgbvfjhdfgbfu====>..." + msg.toString());
    if (msg == 200) {
      setState(() {
        loading = false;
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text:
                'Thankyou for submitting your query our team will contact you. $msg',
            onConfirmBtnTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home_page()));
            });
      });
      // Fluttertoast.showToast(
      //     msg: 'Profile Successfully',
      //     backgroundColor: Colors.green,
      //     gravity: ToastGravity.CENTER);
      // setState(() {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Profile_page()));
      // });
    } else {
      setState(() {
        loading = false;
        QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: res['status_message'],
            onConfirmBtnTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home_page()));
            });
        // Fluttertoast.showToast(
        //     msg: 'Server Response $msg',
        //     backgroundColor: Colors.green,
        //     gravity: ToastGravity.CENTER);
      });
    }
  }

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

  List getdisease = [];
  String? get_disease;
  Future getDisease() async {
    final pref = await SharedPreferences.getInstance();
    var id = pref.getString('crop_id');
    Map data = {
      'crop_id': 'CRP9683389',
    };
    var data1 = jsonEncode(data);
    var uri =
        Uri.parse('https://doplus.creditmywallet.in.net/api/get_disease_list');
    final response = await http
        .post(uri, body: data1, headers: {"Content-Type": "Application/json"});
    var res = jsonDecode(response.body)['response'];
    if (response.statusCode == 200) {
      setState(() {
        getdisease = res;
        print(response.toString() + "ccccccccccccccccccccc");
      });
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

  int _value = 1;

  void initState() {
    getCrop();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 2,
                                color: Color(0xffc7e5f0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      width: MediaQuery.of(context).size.width,
                                      //height: MediaQuery.of(context).size.height/5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.list_alt,
                                                color: Color(0xff365d76),
                                                size: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  "Instructions".tr,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff365d76)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.brightness_1,
                                                  color: Color(0xff375b62),
                                                  size: 17,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "ins1".tr,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.brightness_1,
                                                  color: Color(0xff375b62),
                                                  size: 17,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "ins2".tr,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.brightness_1,
                                                  color: Color(0xff375b62),
                                                  size: 17,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "ins3".tr,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.brightness_1,
                                                  color: Color(0xff375b62),
                                                  size: 17,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "ins4".tr,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.brightness_1,
                                                  color: Color(0xff375b62),
                                                  size: 17,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "ins5".tr,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff50899f)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Crop_health".tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff085272)),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xffA8A8A8)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: Text(
                                        'choose_your_crop'.tr,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff508399),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      items: getcrop
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value:
                                                    item['crop_id'].toString(),
                                                child: Text(
                                                  item['crop_name'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: get_crop,
                                      onChanged: (value) {
                                        setState(() {
                                          get_crop = value as String;
                                          getDisease();
                                          print(get_crop.toString() +
                                              ">>>>>>>>>>>");
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xffA8A8A8)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: Text(
                                        'choose_your_disease'.tr,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff508399),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      items: getdisease
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item['disease_id']
                                                    .toString(),
                                                child: Text(
                                                  item['dises_title']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: get_disease,
                                      onChanged: (value) {
                                        setState(() {
                                          get_disease = value as String;
                                          print(get_disease.toString() +
                                              "ddddddddd");
                                        });
                                      },
                                      // buttonHeight: 40,
                                      // itemHeight: 40,
                                      // iconSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  print('love');
                                  // frontDrivingLicense1(context, ImageSource.camera);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Please upload the image"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            child: Text("Camera"),
                                            onPressed: () {
                                              CropImage1(
                                                  context, ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          MaterialButton(
                                            child: Text("Gallery"),
                                            onPressed: () {
                                              CropImage1(
                                                  context, ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffBEBEBE),
                                                width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                        child: CropImage == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .camera_viewfinder,
                                                      size: 120,
                                                      color: Color(0xff7A99A5),
                                                    ),
                                                    Text(
                                                      'Click Here to Upload',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff085272),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(CropImage!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                    Positioned(
                                        right: 25,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              CropImage = null;
                                            });
                                          },
                                          icon: Icon(Icons.highlight_remove),
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Card(
                                elevation: 3,
                                shape: ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(23))),
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
                                        check_health();
                                        // setState(() {
                                        //   QuickAlert.show(
                                        //       context: context,
                                        //       type: QuickAlertType.success,
                                        //       text:
                                        //           'Thankyou for submitting your query our team will contact you.',
                                        //       onConfirmBtnTap: () {
                                        //         Navigator.pushReplacement(
                                        //             context,
                                        //             MaterialPageRoute(
                                        //                 builder: (context) =>
                                        //                     Home_page()));
                                        //       });
                                        // LoginApi();
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             crop_health_Solution()));
                                        // });
                                      },
                                      child: Text(
                                        "save".tr,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
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
