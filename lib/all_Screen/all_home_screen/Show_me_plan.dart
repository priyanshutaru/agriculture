import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import 'package:agriculture/all_Screen/all_home_screen/Crop_Advisory_all_page/all_list_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/Tubewell_booking_all_page/Tubewell_All_model/crop_disease_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_calendar.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Home_Page.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutter_tts/flutter_tts.dart';

class Show_me_plan extends StatefulWidget {
  Show_me_plan(
      {Key? key, this.cropImage, this.cropName, this.cropId, this.planid})
      : super(key: key);
  String? cropName;
  String? cropImage;
  String? cropId;
  String? planid;
  @override
  State<Show_me_plan> createState() => _Show_me_planState();
}

class _Show_me_planState extends State<Show_me_plan> {
  int _currentIndex = 2;
  bool checktask = false;
  String dropdownvalue = 'भाषा/Language';
  String? selectedValue;
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  String? imageList;

  List<String> img = [
    "assets/slid1.jpg",
    "assets/slid2.jpg",
    "assets/slid3.jpg",
    "assets/slid4.jpg",
    "assets/slid5.jpg"
  ];
  bool isloading = true;
  bool alltask = false;
  bool bannerloading = true;
  Future bannerTop() async {
    setState(() {
      bannerloading = true;
    });
    Map data = {
      'screen_id': '5',
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

  String? get_Current_task;
  String? task_no;
  String? title;
  String? discription;
  bool _switchValue = false;

  Future getUserCurrentTask() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
      'user_crop_plan_id': widget.planid.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_current_user_task");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    setState(() {
      print("KKKKKKKKKKK" + res.toString());
      // print('ankit ${res['response']['inst_des']}');
      var document = parse('${res['response']['inst_des']}');
      // get_Current_task = res['response'];
      String parsedString = parse(document.body!.text).documentElement!.text;
      print('de $parsedString');
      task_no = res['response']['task_no'];
      title = res['response']['title'];
      discription = parsedString;
      print('de $task_no');
      print('de $title');
      print('de $discription');
    });
  }

  bool isPlaying = false;
  bool convert = false;
  String? converteddiscription;
  final FlutterTts fluttertts = FlutterTts();

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

  void htmlConvert(String apiString) {
    var document = parse(apiString);
    // get_Current_task = res['response'];
    String parsedString = parse(document.body!.text).documentElement!.text;
    setState(() {
      converteddiscription = parsedString;
      convert = true;
    });

    print('de $parsedString');
  }

  String current_task = 'current_task';
  List get_All_task = [];

  Future<List<AllTaskResponse>> get_all_task_list() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
      'user_crop_plan_id': widget.planid.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/show_user_task_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      List<dynamic> data = map["response"];
      // print(data);
      return data.map((data) => AllTaskResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<DiseaseResponse>> get_all_task_disease(String crop_id) async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'crop_id': crop_id,
      // 'user_crop_plan_id': widget.planid.toString(),
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
      return data.map((data) => DiseaseResponse.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  // Future getUserAllTask() async {
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   Map data = {
  //     'user_id': user_id.toString(),
  //     'user_crop_plan_id': widget.planid.toString(),
  //   };
  //   var data1 = jsonEncode(data);
  //   var url = Uri.parse(
  //       "https://doplus.creditmywallet.in.net/api/show_user_task_list");
  //   final response = await http.post(url,
  //       headers: {"Content-Type": "Application/json"}, body: data1);
  //   var res = jsonDecode(response.body)['response'];
  //   setState(() {
  //     print("PPPPPPP" + res['response'].toString());
  //     // get_All_task = res;
  //     // print(get_All_task.toString() + "PPPPPPP");
  //   });
  // }

  Future deleteCropId() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/deleteCropPlan");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    setState(() {
      print("dddd" + res.toString());
    });
  }

  bool loading = false;

  Future getUserCropPlans() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
    };
    var data1 = jsonEncode(data);
    var url = Uri.parse(
        "https://doplus.creditmywallet.in.net/api/get_user_crop_plan_list");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    if (response.statusCode == 200) {
      setState(() {
        getCropPlans = res;
        print("QQQQQQQQ>>>>>" + getCropPlans.toString());
        loading = false;
      });
    }
  }

  String language = 'hin';
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

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  int _value = 1;

  // Future<List<Response>>  getUserCropPlans() async {
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   Map data={'user_id':user_id.toString()};
  //   var data1 = jsonEncode(data);
  //   var url=Uri.parse("https://doplus.creditmywallet.in.net/api/get_user_crop_plan_list");
  //   var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: data1);
  //   if (response.statusCode == 200) {
  //     Map<String,dynamic> map=json.decode(response.body);
  //     List<dynamic> data=map["response"];
  //     return data.map((data) => Response.fromJson(data)).toList();
  //   }else{
  //     throw Exception('unexpected error occurred');
  //   }
  // }

  List getCropPlans = [];
  @override
  void initState() {
    super.initState();
    // getUserCurrentTask();
    bannerTop();
    getUser();
    getUserCropPlans();
    checkcroplist();
    // getUserAllTask();
    // get_all_task_list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: bannerloading
                                  ? CircularProgressIndicator()
                                  : Container(
                                      child: Image.network(imageList!),
                                    ),
                              // child: Center(
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
                              //                           BorderRadius.circular(
                              //                               10),
                              //                     ),
                              //                     child: ClipRRect(
                              //                       borderRadius:
                              //                           BorderRadius.circular(
                              //                               10),
                              //                       child: Image.asset(
                              //                           //imageList[i]['banner_img'].toString(),
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
                            ),
                            SizedBox(
                              height: 15,
                            ),
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
                                          get_all_task_list();
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

                                          get_all_task_list();
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
                                // Row(
                                //   children: [
                                //     Text('English'),
                                //     CupertinoSwitch(
                                //       value: _switchValue,
                                //       onChanged: (value) {
                                //         setState(() {
                                //           _switchValue = value;
                                //           language = 'eng';
                                //           get_all_task_list();
                                //         });
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 3,
                                  child: Container(
                                    padding: EdgeInsets.all(7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Crop_calendar()));
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          "assets/add.png"))),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                7.5,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            child: ListView.builder(
                                                physics: ScrollPhysics(),
                                                itemCount: getCropPlans.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      // deleteCropId();
                                                      setState(() {
                                                        widget.cropName =
                                                            getCropPlans[index][
                                                                    'crop_name']
                                                                .toString();
                                                        widget
                                                            .planid = getCropPlans[
                                                                    index][
                                                                'user_CropPlan_id']
                                                            .toString();
                                                        // task_no =
                                                        //     getCropPlans[index]
                                                        //             ['task_no']
                                                        //         .toString();
                                                        // title =
                                                        //     getCropPlans[index]
                                                        //             ['title']
                                                        //         .toString();
                                                        // discription =
                                                        //     getCropPlans[index]
                                                        //             ['inst_des']
                                                        //         .toString();
                                                        get_all_task_list();
                                                        alltask = true;

                                                        // get_all_task_list();
                                                      });
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Column(
                                                        children: [
                                                          // Container(
                                                          //   height: 55,
                                                          //   width: 55,
                                                          //   margin: EdgeInsets.only(
                                                          //       left: 10,
                                                          //       top: 2,
                                                          //       right: 13),
                                                          //   decoration: BoxDecoration(
                                                          //       borderRadius:
                                                          //           BorderRadius
                                                          //               .circular(50),
                                                          //       image:
                                                          //           DecorationImage(
                                                          //         image: NetworkImage(
                                                          //             getCropPlans[
                                                          //                         index]
                                                          //                     ['img']
                                                          //                 .toString()),
                                                          //       )),
                                                          // ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            // height: 24,
                                                            // width: 24 * 1.7,
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Container(
                                                                    height: 55,
                                                                    width: 55,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        top: 2,
                                                                        right:
                                                                            13),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(50),
                                                                            image: DecorationImage(
                                                                              image: NetworkImage(getCropPlans[index]['img'].toString()),
                                                                            )),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      (() async {
                                                                    await showDialog(
                                                                          //show confirm dialogue
                                                                          //the return value will be from "Yes" or "No" options
                                                                          context:
                                                                              context,
                                                                          builder: (context) =>
                                                                              CupertinoAlertDialog(
                                                                            title:
                                                                                Text(
                                                                              'Delete Crop Plan',
                                                                            ),
                                                                            content:
                                                                                Text(
                                                                              'Do you want to Delete Crop Plan ?',
                                                                            ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(primary: Colors.transparent, elevation: 0),
                                                                                onPressed: () => Navigator.of(context).pop(false),
                                                                                //return false when click on "NO"
                                                                                child: Text(
                                                                                  'No',
                                                                                  style: TextStyle(fontSize: 14),
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  final pref = await SharedPreferences.getInstance();
                                                                                  var user_id = pref.getString('user_id');
                                                                                  Map data = {
                                                                                    'user_id': user_id.toString(),
                                                                                    'plan_id': getCropPlans[index]['user_CropPlan_id'].toString(),
                                                                                  };
                                                                                  var data1 = jsonEncode(data);
                                                                                  var url = Uri.parse("https://doplus.creditmywallet.in.net/api/deleteCropPlan");
                                                                                  final response = await http.post(url,
                                                                                      headers: {
                                                                                        "Content-Type": "Application/json"
                                                                                      },
                                                                                      body: data1);
                                                                                  var res = jsonDecode(response.body)['response'];
                                                                                  if (response.statusCode == 200) {
                                                                                    setState(() {
                                                                                      Fluttertoast.showToast(
                                                                                        msg: 'Deleted Successfully',
                                                                                        backgroundColor: Colors.green,
                                                                                        gravity: ToastGravity.CENTER,
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                      // getCropPlans = res;
                                                                                      // print("QQQQQQQQ>>>>>" + getCropPlans.toString());
                                                                                    });
                                                                                  }
                                                                                  setState(() {
                                                                                    getUserCropPlans();
                                                                                  });
                                                                                },
                                                                                style: ElevatedButton.styleFrom(primary: Colors.transparent, elevation: 0),
                                                                                //return true when click on "Yes"
                                                                                child: Text(
                                                                                  'Yes',
                                                                                  style: TextStyle(fontSize: 14),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ) ??
                                                                        false; //if showDialouge had returned null, then return false
                                                                    // setState(() {
                                                                    //   showCropDeletePlanPopup();
                                                                    // });
                                                                  }),
                                                                  child:
                                                                      Container(
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: 40,
                                                                      left: 30,
                                                                    ),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomRight,
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.red,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          _switchValue
                                                              ? Text(
                                                                  getCropPlans[
                                                                              index]
                                                                          [
                                                                          'crop_name']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xff447c95),
                                                                      fontSize:
                                                                          12),
                                                                )
                                                              : Text(
                                                                  getCropPlans[
                                                                              index]
                                                                          [
                                                                          'crop_name_hindi']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xff447c95),
                                                                      fontSize:
                                                                          12),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       get_all_task_list();

                        //       alltask = true;
                        //     });
                        //   },
                        //   child: Text("All Task",
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w500,
                        //       )),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 3,
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xffD8D8D8),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("ur_crop".tr,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff447c94))),
                                        widget.cropName == null
                                            ? Text("selectcrop".tr,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff447c94)))
                                            : Text("${widget.cropName}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff447c94)))
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        // if (activeStep > 0) {
                                        //   setState(() {
                                        //     activeStep--;
                                        //   });
                                        // }
                                        // if (activeStep == 0) {
                                        //   setState(() {
                                        //     Fluttertoast.showToast(
                                        //       msg: "This is first Task",
                                        //       textColor: Colors.white,
                                        //       backgroundColor:
                                        //           Color(0xff66ad2d),
                                        //     );
                                        //   });
                                        // }
                                        setState(() {
                                          current_task = 'previous_task';
                                          get_all_task_list();
                                        });
                                      },
                                      icon: Icon(
                                          Icons.keyboard_double_arrow_left)),
                                  Text("prv_task".tr,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff447c94))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        current_task = 'current_task';
                                        get_all_task_list();
                                      });
                                    },
                                    child: Text("Current_Task".tr,
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("next_task".tr,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff447c94))),
                                  IconButton(
                                      onPressed: () {
                                        // if (activeStep < upperBound) {
                                        //   setState(() {
                                        //     activeStep++;
                                        //     getUserCurrentTask();
                                        //   });
                                        //   if (activeStep == get_All_task[10]) {
                                        //     setState(() {
                                        //       Fluttertoast.showToast(
                                        //         msg: "Last Task",
                                        //         textColor: Colors.white,
                                        //         backgroundColor:
                                        //             Color(0xff66ad2d),
                                        //       );
                                        //     });
                                        //   }
                                        // }
                                        setState(() {
                                          current_task = 'next_task';
                                          get_all_task_list();
                                        });
                                      },
                                      icon: Icon(
                                          Icons.keyboard_double_arrow_right))
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     left: 5,
                        //     top: 15,
                        //     right: 5,
                        //   ),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       // discription == null
                        //       //     ? Text("Your Task",
                        //       //         style: TextStyle(
                        //       //           fontWeight: FontWeight.w500,
                        //       //           color: Color(0xff759eb0),
                        //       //         ))
                        //       //     : Text("Current Task",
                        //       //         style: TextStyle(
                        //       //           fontWeight: FontWeight.w500,
                        //       //           color: Color(0xff759eb0),
                        //       //         )),
                        //     ],
                        //   ),
                        // ),
                        // discription == null
                        //     ? Padding(
                        //         padding: const EdgeInsets.all(10),
                        //         child: Text(
                        //             "Here all task will show in text format and it will dynamic as par land size and crop",
                        //             style: TextStyle(
                        //               fontSize: 12,
                        //               fontWeight: FontWeight.w500,
                        //               color: Color(0xff759eb0),
                        //             )),
                        //       )
                        //     :
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   task_no == 'null'
                                //       ? 'No Data'
                                //       : task_no!,
                                //   style: TextStyle(
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w700),
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Text(
                                //   title == 'null' ? 'No Data' : title!,
                                //   style: TextStyle(
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w700),
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Container(
                                //   width: MediaQuery.of(context)
                                //           .size
                                //           .width *
                                //       .88,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //         left: 0, right: 0),
                                //     child: Text(
                                //       discription == 'null'
                                //           ? 'No Data'
                                //           : discription!,
                                //     ),
                                //   ),
                                // ),
                                alltask == true
                                    ? FutureBuilder<List<AllTaskResponse>>(
                                        future: get_all_task_list(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          // else if (snapshot.hasData &&
                                          //     snapshot.data.isEmpty) {
                                          //   return Padding(
                                          //     padding: const EdgeInsets.all(10),
                                          //     child: Text("No Data",
                                          //         style: TextStyle(
                                          //           fontSize: 12,
                                          //           fontWeight: FontWeight.w500,
                                          //           color: Color(0xff759eb0),
                                          //         )),
                                          //   );
                                          // }
                                          else {
                                            List<AllTaskResponse>? data =
                                                snapshot.data;

                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: ListView.builder(
                                                  physics: ScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: data!.length,
                                                  itemBuilder:
                                                      (BuildContext ctx,
                                                          index) {
                                                    return
                                                        // data[index].taskStatus ==
                                                        //         'null'
                                                        //     ? Padding(
                                                        //         padding:
                                                        //             const EdgeInsets
                                                        //                 .all(10),
                                                        //         child: Text("No Data",
                                                        //             style: TextStyle(
                                                        //               fontSize: 12,
                                                        //               fontWeight:
                                                        //                   FontWeight
                                                        //                       .w500,
                                                        //               color: Color(
                                                        //                   0xff759eb0),
                                                        //             )),
                                                        //       )
                                                        //     :
                                                        data[index]
                                                                    .taskLanguage
                                                                    .toString() ==
                                                                language
                                                            ? data[index]
                                                                        .taskStatus
                                                                        .toString() ==
                                                                    current_task
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      // height: 70,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.9,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color: data[index].taskStatus.toString() == "current_task"
                                                                                ? Colors.green
                                                                                : Colors.grey,
                                                                          )),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                width: 60,
                                                                                height: 60,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    child: ClipOval(
                                                                                      child: Image.network(data[index].img.toString()),
                                                                                    )),
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  data[index].taskLanguage.toString() == language
                                                                                      ? data[index].taskStatus.toString() == "current_task"
                                                                                          ? Text(
                                                                                              'Current' + "\n" + data[index].taskNo.toString(),
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                                                                                            )
                                                                                          : Text(
                                                                                              data[index].taskNo.toString(),
                                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff50899f)),
                                                                                            )
                                                                                      : SizedBox(),
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  data[index].taskLanguage.toString() == language
                                                                                      ? Text(
                                                                                          // _switchValue
                                                                                          //     ? data[index].cropNameHindi.toString()
                                                                                          //     :
                                                                                          data[index].title.toString(),
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: data[index].taskStatus.toString() == "current_task" ? Colors.green : Colors.black,
                                                                                          ),
                                                                                        )
                                                                                      : SizedBox(),

                                                                                  data[index].taskLanguage.toString() == language
                                                                                      ?
                                                                                      // convert == false
                                                                                      //     ?
                                                                                      Row(children: [
                                                                                          ElevatedButton.icon(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              elevation: 0,
                                                                                              primary: Colors.white, // background
                                                                                              onPrimary: Colors.blue, // foreground
                                                                                            ),
                                                                                            icon: Icon(
                                                                                              Icons.arrow_drop_down_circle,
                                                                                              size: 15,
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              htmlConvert(data[index].instDes.toString());
                                                                                              await showModalBottomSheet(
                                                                                                  backgroundColor: Colors.white,
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                                  ),
                                                                                                  context: context,
                                                                                                  builder: (builder) {
                                                                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                                                                                      return Container(
                                                                                                        child: SingleChildScrollView(
                                                                                                          child: Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 15,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                                                                                                                child: Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                  children: [
                                                                                                                    Center(
                                                                                                                      child: data[index].taskLanguage.toString() == language
                                                                                                                          ? Text(
                                                                                                                              data[index].title.toString(),
                                                                                                                              style: TextStyle(
                                                                                                                                fontSize: 16,
                                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                                color: data[index].taskStatus.toString() == "current_task" ? Colors.green : Colors.black,
                                                                                                                              ),
                                                                                                                            )
                                                                                                                          : SizedBox(),
                                                                                                                    ),
                                                                                                                    Padding(
                                                                                                                        padding: const EdgeInsets.all(0.0),
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
                                                                                                                                  await fluttertts.setLanguage('en-US');
                                                                                                                                  await fluttertts.setLanguage('hi-IN');

                                                                                                                                  await fluttertts.setPitch(1);
                                                                                                                                  await fluttertts.speak(data[index].title.toString()).whenComplete(() {
                                                                                                                                    Future.delayed(const Duration(milliseconds: 500), () {
                                                                                                                                      setState(() {
                                                                                                                                        speak();
                                                                                                                                      });
                                                                                                                                    });
                                                                                                                                  });
                                                                                                                                },
                                                                                                                                child: Icon(
                                                                                                                                  Icons.mic,
                                                                                                                                ))),
                                                                                                                    GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                          pause();

                                                                                                                          Navigator.pop(context);
                                                                                                                        },
                                                                                                                        child: Icon(
                                                                                                                          Icons.close,
                                                                                                                          color: Colors.red,
                                                                                                                        ))
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ),
                                                                                                              Divider(),
                                                                                                              new Container(
                                                                                                                // height: 400,
                                                                                                                color: Colors.transparent, //could change this to Color(0xFF737373),
                                                                                                                //so you don't have to change MaterialApp canvasColor
                                                                                                                child: new Container(
                                                                                                                    decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                                                                                                                    child: new Center(
                                                                                                                      child: Padding(
                                                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                                                        child: new Text(data[index].createdAt.toString()),
                                                                                                                      ),
                                                                                                                    )),
                                                                                                              ),
                                                                                                              Divider(),
                                                                                                              new Container(
                                                                                                                // height: 400,
                                                                                                                color: Colors.transparent, //could change this to Color(0xFF737373),
                                                                                                                //so you don't have to change MaterialApp canvasColor
                                                                                                                child: new Container(
                                                                                                                    decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                                                                                                                    child: new Center(
                                                                                                                      child: Padding(
                                                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                                                        child: new Text(converteddiscription!),
                                                                                                                      ),
                                                                                                                    )),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                    });
                                                                                                  });

                                                                                              // setState(() {
                                                                                              //   convert = true;
                                                                                              // });
                                                                                            },
                                                                                            label: Text(
                                                                                              'View_Task'.tr,
                                                                                              style: TextStyle(
                                                                                                fontSize: 14,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          data[index].diseaseStatus.toString() == '0'
                                                                                              ? ElevatedButton.icon(
                                                                                                  style: ElevatedButton.styleFrom(
                                                                                                    elevation: 0,
                                                                                                    primary: Colors.white, // background
                                                                                                    onPrimary: Colors.red, // foreground
                                                                                                  ),
                                                                                                  icon: Icon(
                                                                                                    Icons.arrow_drop_down_circle,
                                                                                                    color: Colors.red,
                                                                                                    size: 15,
                                                                                                  ),
                                                                                                  onPressed: () async {
                                                                                                    // // htmlConvert(data[index].instDes.toString());
                                                                                                    await showModalBottomSheet(
                                                                                                        backgroundColor: Colors.white,
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                                                        ),
                                                                                                        context: context,
                                                                                                        builder: (builder) {
                                                                                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                                                                                            return FutureBuilder<List<DiseaseResponse>>(
                                                                                                                future: get_all_task_disease(data[index].cropId.toString()),
                                                                                                                builder: (context, AsyncSnapshot snapshot) {
                                                                                                                  if (!snapshot.hasData) {
                                                                                                                    return Center(child: CircularProgressIndicator());
                                                                                                                  } else {
                                                                                                                    List<DiseaseResponse>? diseasedata = snapshot.data;
                                                                                                                    return ListView.builder(
                                                                                                                        physics: ScrollPhysics(),

                                                                                                                        // scrollDirection: Axis.vertical,
                                                                                                                        shrinkWrap: true,
                                                                                                                        itemCount: diseasedata!.length,
                                                                                                                        itemBuilder: (
                                                                                                                          BuildContext ctx,
                                                                                                                          index,
                                                                                                                        ) {
                                                                                                                          return Container(
                                                                                                                            child: SingleChildScrollView(
                                                                                                                              child: Column(
                                                                                                                                children: [
                                                                                                                                  SizedBox(
                                                                                                                                    height: 15,
                                                                                                                                  ),
                                                                                                                                  Padding(
                                                                                                                                    padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                                                                                                                                    child: Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                      children: [
                                                                                                                                        Center(
                                                                                                                                          child: diseasedata[index].diseaseLanguage.toString() == language
                                                                                                                                              ? Text(
                                                                                                                                                  diseasedata[index].disesTitle.toString(),
                                                                                                                                                  style: TextStyle(
                                                                                                                                                    fontSize: 16,
                                                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                                                    color: Colors.black,
                                                                                                                                                  ),
                                                                                                                                                )
                                                                                                                                              : SizedBox(),
                                                                                                                                        ),
                                                                                                                                        TextButton(
                                                                                                                                          onPressed: () async {
                                                                                                                                            htmlConvert(diseasedata[index].disesDescription.toString());
                                                                                                                                            await showModalBottomSheet(
                                                                                                                                                backgroundColor: Colors.white,
                                                                                                                                                shape: RoundedRectangleBorder(
                                                                                                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                                                                                                ),
                                                                                                                                                context: context,
                                                                                                                                                builder: (builder) {
                                                                                                                                                  return StatefulBuilder(builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                                                                                                                                    return Container(
                                                                                                                                                      child: SingleChildScrollView(
                                                                                                                                                        child: Column(
                                                                                                                                                          children: [
                                                                                                                                                            SizedBox(
                                                                                                                                                              height: 15,
                                                                                                                                                            ),
                                                                                                                                                            Padding(
                                                                                                                                                              padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                                                                                                                                                              child: Row(
                                                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                                                children: [
                                                                                                                                                                  Center(
                                                                                                                                                                    child: data[index].taskLanguage.toString() == language
                                                                                                                                                                        ? Text(
                                                                                                                                                                            diseasedata[index].disesTitle.toString(),
                                                                                                                                                                            style: TextStyle(
                                                                                                                                                                              fontSize: 16,
                                                                                                                                                                              fontWeight: FontWeight.bold,
                                                                                                                                                                              color: data[index].taskStatus.toString() == "current_task" ? Colors.green : Colors.black,
                                                                                                                                                                            ),
                                                                                                                                                                          )
                                                                                                                                                                        : SizedBox(),
                                                                                                                                                                  ),
                                                                                                                                                                  Padding(
                                                                                                                                                                      padding: const EdgeInsets.all(0.0),
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
                                                                                                                                                                                await fluttertts.setLanguage('en-US');
                                                                                                                                                                                await fluttertts.setLanguage('hi-IN');

                                                                                                                                                                                await fluttertts.setPitch(1);
                                                                                                                                                                                await fluttertts.speak(diseasedata[index].disesTitle.toString()).whenComplete(() {
                                                                                                                                                                                  Future.delayed(const Duration(milliseconds: 500), () {
                                                                                                                                                                                    setState(() {
                                                                                                                                                                                      speak();
                                                                                                                                                                                    });
                                                                                                                                                                                  });
                                                                                                                                                                                });
                                                                                                                                                                              },
                                                                                                                                                                              child: Icon(
                                                                                                                                                                                Icons.mic,
                                                                                                                                                                              ))),
                                                                                                                                                                  GestureDetector(
                                                                                                                                                                      onTap: () {
                                                                                                                                                                        pause();
                                                                                                                                                                        Navigator.pop(context);
                                                                                                                                                                      },
                                                                                                                                                                      child: Icon(
                                                                                                                                                                        Icons.close,
                                                                                                                                                                        color: Colors.red,
                                                                                                                                                                      ))
                                                                                                                                                                ],
                                                                                                                                                              ),
                                                                                                                                                            ),
                                                                                                                                                            Divider(),
                                                                                                                                                            new Container(
                                                                                                                                                              // height: 400,
                                                                                                                                                              color: Colors.transparent, //could change this to Color(0xFF737373),
                                                                                                                                                              //so you don't have to change MaterialApp canvasColor
                                                                                                                                                              child: new Container(
                                                                                                                                                                  decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                                                                                                                                                                  child: new Center(
                                                                                                                                                                    child: Padding(
                                                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                                                      child: new Text(diseasedata[index].createdAt.toString()),
                                                                                                                                                                    ),
                                                                                                                                                                  )),
                                                                                                                                                            ),
                                                                                                                                                            Divider(),
                                                                                                                                                            new Container(
                                                                                                                                                              // height: 400,
                                                                                                                                                              color: Colors.transparent, //could change this to Color(0xFF737373),
                                                                                                                                                              //so you don't have to change MaterialApp canvasColor
                                                                                                                                                              child: new Container(
                                                                                                                                                                  decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                                                                                                                                                                  child: new Center(
                                                                                                                                                                    child: Padding(
                                                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                                                      child: new Text(converteddiscription!),
                                                                                                                                                                    ),
                                                                                                                                                                  )),
                                                                                                                                                            ),
                                                                                                                                                          ],
                                                                                                                                                        ),
                                                                                                                                                      ),
                                                                                                                                                    );
                                                                                                                                                  });
                                                                                                                                                });
                                                                                                                                          },
                                                                                                                                          child: language == 'eng' ? Text('Show Description') : Text('रोग विवरण'),
                                                                                                                                        )
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  Divider(),
                                                                                                                                  CarouselSlider(options: CarouselOptions(aspectRatio: 2.0, enlargeCenterPage: true, scrollDirection: Axis.horizontal, autoPlay: false, viewportFraction: 1), items: [
                                                                                                                                    for (var i = 0; i < img.length; i++)
                                                                                                                                      bannerloading
                                                                                                                                          ? Card(
                                                                                                                                              elevation: 5,
                                                                                                                                              child: Container(
                                                                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                                                                decoration: BoxDecoration(
                                                                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                                                                ),
                                                                                                                                                child: ClipRRect(
                                                                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                                                                  child: Image.network(
                                                                                                                                                      // imageList[i]['banner_img'].toString(),
                                                                                                                                                      diseasedata[index].diseaseImages![i],
                                                                                                                                                      fit: BoxFit.fill),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            )
                                                                                                                                          : Container(
                                                                                                                                              child: Center(
                                                                                                                                                child: CupertinoActivityIndicator(color: Color.fromARGB(255, 76, 144, 175), radius: 30),
                                                                                                                                              ),
                                                                                                                                            )
                                                                                                                                  ]),
                                                                                                                                  // new Container(
                                                                                                                                  //   // height: 400,
                                                                                                                                  //   color: Colors.transparent, //could change this to Color(0xFF737373),
                                                                                                                                  //   //so you don't have to change MaterialApp canvasColor
                                                                                                                                  //   child: new Container(
                                                                                                                                  //       decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                                                                                                                                  //       child: new Center(
                                                                                                                                  //         child: Padding(
                                                                                                                                  //           padding: const EdgeInsets.all(8.0),
                                                                                                                                  //           child: new Image.network(
                                                                                                                                  //             diseasedata[index].disesImage!,
                                                                                                                                  //           ),
                                                                                                                                  //         ),
                                                                                                                                  //       )),
                                                                                                                                  // ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          );
                                                                                                                        });
                                                                                                                  }
                                                                                                                });
                                                                                                          });
                                                                                                        });

                                                                                                    // // setState(() {
                                                                                                    // //   convert = true;
                                                                                                    // // });
                                                                                                  },
                                                                                                  label: Text(
                                                                                                    'view_disease'.tr,
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 14,
                                                                                                    ),
                                                                                                  ))
                                                                                              : SizedBox()
                                                                                        ])
                                                                                      // : Container(
                                                                                      //     width: 250,
                                                                                      //     margin: EdgeInsets.fromLTRB(0, 5, 10, 10),
                                                                                      //     child: data[index].taskLanguage.toString() == language
                                                                                      //         ? Text(
                                                                                      //             converteddiscription!,
                                                                                      //             style: TextStyle(
                                                                                      //               fontSize: 14,
                                                                                      //               // fontWeight: FontWeight.bold,
                                                                                      //               color: data[index].taskStatus.toString() == "current_task" ? Colors.black : Colors.black,
                                                                                      //             ),
                                                                                      //           )
                                                                                      : SizedBox()
                                                                                  // : SizedBox(),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox()
                                                            : SizedBox();
                                                  }),
                                            );
                                          }
                                        })
                                    : Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text("click_crop".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff759eb0),
                                            )),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

  int activeStep = 0;
  int upperBound = 6;
}
