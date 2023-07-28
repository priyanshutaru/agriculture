import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../all_Screen/Basic_screen/Login_Page.dart';
import '../all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import '../all_Screen/all_home_screen/Home_Page.dart';
import '../all_Screen/all_home_screen/Show_me_plan.dart';
import '../all_Screen/all_home_screen/crop_calendar.dart';
import '../all_Screen/all_home_screen/crop_health_page.dart';
import 'Edit_profile.dart';
import 'add_farm_land.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({Key? key}) : super(key: key);
  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page>
    with SingleTickerProviderStateMixin {
  bool loading = false;

  TabController? _tabController;
  TextEditingController user_name = TextEditingController();
  TextEditingController upi_id = TextEditingController();
  int _currentIndex = 0;
  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  var name, mobileNo, image, address, district, state, pincode, ggf;
  var payment_details, payment_name, payment_upi_id, thana, tehsile;

  Future getProfilegetProfile() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {
      'user_id': user_id.toString(),
      //'user_id':"USR681808989",
    };
    Uri url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_user");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    var res = await json.decode(response.body);
    print('ankit$res');
    setState(() {
      name = res["name"];
      mobileNo = res["mobile"];
      image = res["img"];
      address = res["address"];
      district = res["district"];
      state = res["state"];
      pincode = res["pin"];
      thana = res['thana'];
      tehsile = res['tehsil'];
      payment_details = res["payment_details"];
      payment_name = res["payment_name"];
      payment_upi_id = res["payment_upi_id"];
      print('Name =========>>>>>>>>' + district.toString());
      loading = false;
    });
    print(name);
    print(mobileNo);
    print(image);
    print(address);
    print(district);
    print(state);
  }

  var percentage;
  Future getpercentage() async {
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
        "https://doplus.creditmywallet.in.net/api/get_profile_percentage");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      percentage = res['response'];

      loading = false;

      print(percentage.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    setState(() {
      getProfilegetProfile();
      getpercentage();
      getFormLand();
      getUser();
      checkcroplist();
      user_name.text = payment_name.toString();
      upi_id.text = payment_upi_id.toString();
    });
  }

  final picker = ImagePicker();
  File? CropImage;
  Future CropImage1(context, ImageSource source) async {
    setState(() {
      loading = true;
    });
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        loading = false;
        CropImage = new File(pickedFile.path);
        print(CropImage!.path);
        EditProfile();
      });
    }
  }

  Future EditProfile() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    String addhar1 = CropImage!.path.split('/').last;
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': user_id.toString(),
      'name': name.toString(),
      'address': address.toString(),
      'district': district.toString(),
      'state': state.toString(),
      'pin_code': pincode.toString(),
      'tehsil': tehsile.toString(),
      'thana': thana.toString(),
      'img': await MultipartFile.fromFile(CropImage!.path, filename: addhar1),
    });
    print(formData.toString());
    var response = await dio.post(
        'https://doplus.creditmywallet.in.net/api/complete_profile',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    int msg = res['status_code'];
    print("bjhgbvfjhdfgbfu====>..." + msg.toString());
    if (msg == 200) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: 'Profile Successfully',
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile_page()));
      });
    } else {}
  }

  List get_form_land = [];
  Future getFormLand() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    Map data = {'user_id': user_id.toString()};
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_farm_land");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['response'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_form_land = res;
      loading = false;
      print(get_form_land.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  Future Add_pay() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': user_id.toString(),
      'payment_name': user_name.text.toString(),
      'payment_upi_id': upi_id.text.toString(),
    });
    var response = await dio.post(
        'https://doplus.creditmywallet.in.net/api/update_payment_details',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    String msg = res['status_message'];
    print("bjhgbvfjhdfgbfu====>..." + msg.toString());
    if (msg == "Payment Details Updated") {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Payment Details Updated",
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile_page()));
      });
      //Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "Server Error..",
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER);
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

  int _value = 1;
  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
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
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            color: Color(0xff65AC2B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width,
                                  //height: MediaQuery.of(context).size.height/7.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.7,
                                                        child: CropImage == null
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40.0),
                                                                child: loading
                                                                    ? CircularProgressIndicator()
                                                                    : Container(
                                                                        height:
                                                                            80,
                                                                        width: MediaQuery.of(context).size.width /
                                                                            4.7,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                                image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: NetworkImage(image == null
                                                                              ? 'https://w7.pngwing.com/pngs/754/2/png-transparent-samsung-galaxy-a8-a8-user-login-telephone-avatar-pawn-blue-angle-sphere-thumbnail.png'
                                                                              : image.toString()),
                                                                        )),
                                                                      ))
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40.0),
                                                                child: Container(
                                                                    height: 80,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        4.7,
                                                                    child: Image.file(
                                                                        CropImage!,
                                                                        fit: BoxFit
                                                                            .cover)),
                                                              ),
                                                      ),
                                                      Positioned(
                                                          bottom: 0,
                                                          right: -12,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Upload profile image"),
                                                                    actions: <
                                                                        Widget>[
                                                                      MaterialButton(
                                                                        child: Text(
                                                                            "Camera"),
                                                                        onPressed:
                                                                            () {
                                                                          CropImage1(
                                                                              context,
                                                                              ImageSource.camera);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      MaterialButton(
                                                                        child: Text(
                                                                            "Gallery"),
                                                                        onPressed:
                                                                            () {
                                                                          CropImage1(
                                                                              context,
                                                                              ImageSource.gallery);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                              CupertinoIcons
                                                                  .camera_fill,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Hey !!",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        name != null
                                                            ? Text(
                                                                name.toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            : Text(
                                                                "Shasy Mitra"
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            mobileNo != null
                                                                ? Text(
                                                                    mobileNo
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                : Text(
                                                                    "Shasy Mitra"
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                            Icon(
                                                              Icons.edit,
                                                              size: 24,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                "profile_complete".tr,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          // percentage != 100
                                          //     ?
                                          Container(
                                            child: CircularPercentIndicator(
                                              radius: 45.0,
                                              lineWidth: 8.0,
                                              animation: true,
                                              percent: percentage == null
                                                  ? '10'
                                                  : percentage / 100,
                                              center: Text(
                                                percentage == null
                                                    ? "10%"
                                                    : percentage.toString() +
                                                        "%",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              ),
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              progressColor: Colors.white,
                                            ),
                                          )
                                          // : Text('')
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                  color: Color(0xff65AC2B),
                                ),
                                tabs: [
                                  // first tab [you can add an icon using the icon property]
                                  Tab(
                                    text: 'profile_information'.tr,
                                  ),

                                  // second tab [you can add an icon using the icon property]
                                  Tab(
                                    text: 'farm_Information'.tr,
                                  ),
                                ],
                              ),
                            ),
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
                                    physics: ScrollPhysics(),
                                    children: [
                                      Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              // height:MediaQuery.of(context).size.height/2.5,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  //color: Color(0xff00aeef),
                                                  //borderRadius: BorderRadius.circular(25)
                                                  ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "your_name".tr,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: name != 'null'
                                                              ? Text(
                                                                  name.toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  "Please update"
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${'address'.tr} :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            27.0),
                                                                child: address !=
                                                                        'null'
                                                                    ? Text(
                                                                        address
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        "Please update"
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      )),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${'district'.tr} :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 35.0),
                                                          child:
                                                              district == 'null'
                                                                  ? Text(
                                                                      "Please update"
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      district
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${'state'.tr} :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 50.0),
                                                          child: state != 'null'
                                                              ? Text(
                                                                  state
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  "Please update"
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${'tehsile'.tr} :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 35.0),
                                                        child: tehsile != 'null'
                                                            ? Text(
                                                                tehsile
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Please update"
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${'thana'.tr} :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 40.0),
                                                          child: thana != 'null'
                                                              ? Text(
                                                                  thana
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  "Please update"
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "land_number".tr,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 32.0),
                                                          child:
                                                              pincode != 'null'
                                                                  ? Text(
                                                                      pincode
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      "Please update"
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                  ),
                                                  Card(
                                                    elevation: 3,
                                                    shape: ContinuousRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    60))),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        color:
                                                            Color(0xff65AC2B),
                                                      ),
                                                      child: MaterialButton(
                                                          height: 45,
                                                          minWidth:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                          highlightColor:
                                                              Colors.redAccent,
                                                          onPressed: () {
                                                            setState(() {
                                                              // LoginApi();
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Edit_profile(
                                                                            name:
                                                                                name.toString(),
                                                                            image:
                                                                                image.toString(),
                                                                            district:
                                                                                district.toString(),
                                                                            state:
                                                                                state.toString(),
                                                                            pincode:
                                                                                pincode.toString(),
                                                                            address:
                                                                                address.toString(),
                                                                            mobile:
                                                                                mobileNo.toString(),
                                                                          )));
                                                            });
                                                          },
                                                          child: Text(
                                                            "edit_string".tr,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (BuildContext) {
                                              //       return AlertDialog(
                                              //         content: Container(
                                              //           height: 100,
                                              //           child: Column(
                                              //             children: [
                                              //               Text(
                                              //                   "Are you sure want to logout?"),
                                              //               Divider(
                                              //                 thickness: 1,
                                              //               ),
                                              //               SizedBox(
                                              //                 height: 5,
                                              //               ),
                                              //               Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .end,
                                              //                 children: [
                                              //                   TextButton(
                                              //                       onPressed:
                                              //                           () async {
                                              //                         final pref =
                                              //                             await SharedPreferences
                                              //                                 .getInstance();
                                              //                         var user_id =
                                              //                             pref.remove(
                                              //                                 'user_id');
                                              //                         // await HelperFunctions.saveUserLoggedInSharedPreference(false);
                                              //                         Navigator.push(
                                              //                             context,
                                              //                             MaterialPageRoute(
                                              //                                 builder: (context) => Login_page()));
                                              //                       },
                                              //                       child: Text(
                                              //                         "Yes",
                                              //                         style: TextStyle(
                                              //                             color:
                                              //                                 Colors.blue),
                                              //                       )),
                                              //                   TextButton(
                                              //                       onPressed:
                                              //                           () {
                                              //                         Navigator.pop(
                                              //                             context);
                                              //                       },
                                              //                       child: Text(
                                              //                         "No",
                                              //                         style: TextStyle(
                                              //                             color:
                                              //                                 Colors.red),
                                              //                       )),
                                              //                 ],
                                              //               )
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       );
                                              //     });
                                            },
                                            child: Card(
                                              child: Container(
                                                // height:MediaQuery.of(context).size.height/2.5,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
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
                                                          "log_out".tr,
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext) {
                                                                  return AlertDialog(
                                                                    content:
                                                                        Container(
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                              "Are you sure want to logout?"),
                                                                          Divider(
                                                                            thickness:
                                                                                1,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              TextButton(
                                                                                  onPressed: () async {
                                                                                    final pref = await SharedPreferences.getInstance();
                                                                                    var user_id = pref.remove('user_id');
                                                                                    // await HelperFunctions.saveUserLoggedInSharedPreference(false);
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login_page()));
                                                                                  },
                                                                                  child: Text(
                                                                                    "Yes",
                                                                                    style: TextStyle(color: Colors.blue),
                                                                                  )),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    "No",
                                                                                    style: TextStyle(color: Colors.red),
                                                                                  )),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                });

                                                            // setState(() {
                                                            //   user_name.text =
                                                            //       payment_name
                                                            //           .toString();
                                                            //   upi_id.text =
                                                            //       payment_upi_id
                                                            //           .toString();
                                                            // });
                                                            // await showDialog(
                                                            //     context: context,
                                                            //     builder:
                                                            //         (context) {
                                                            //       return StatefulBuilder(
                                                            //           builder:
                                                            //               (context,
                                                            //                   setState) {
                                                            //         return AlertDialog(
                                                            //           contentPadding: EdgeInsets.symmetric(
                                                            //               horizontal:
                                                            //                   10,
                                                            //               vertical:
                                                            //                   15),
                                                            //           insetPadding:
                                                            //               EdgeInsets.symmetric(
                                                            //                   horizontal:
                                                            //                       15),
                                                            //           //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            //           shape: RoundedRectangleBorder(
                                                            //               borderRadius:
                                                            //                   BorderRadius.all(Radius.circular(10))),
                                                            //           content:
                                                            //               SingleChildScrollView(
                                                            //             child:
                                                            //                 Column(
                                                            //               crossAxisAlignment:
                                                            //                   CrossAxisAlignment.start,
                                                            //               children: [
                                                            //                 Row(
                                                            //                   mainAxisAlignment:
                                                            //                       MainAxisAlignment.center,
                                                            //                   children: [
                                                            //                     Text(
                                                            //                       "Payment Details",
                                                            //                       style: TextStyle(fontSize: 17, color: Color(0xff085272), fontWeight: FontWeight.w500),
                                                            //                     ),
                                                            //                   ],
                                                            //                 ),
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       10,
                                                            //                 ),
                                                            //                 Text(
                                                            //                   "User Name ",
                                                            //                   style: TextStyle(
                                                            //                       fontSize: 15,
                                                            //                       color: Color(0xff085272),
                                                            //                       fontWeight: FontWeight.w500),
                                                            //                 ),
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       10,
                                                            //                 ),
                                                            //                 Container(
                                                            //                   //width: MediaQuery.of(context).size.width/2.4,
                                                            //                   child:
                                                            //                       TextFormField(
                                                            //                     controller: user_name,
                                                            //                     keyboardType: TextInputType.text,
                                                            //                     decoration: InputDecoration(
                                                            //                       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                                            //                       fillColor: Colors.white,
                                                            //                       filled: true,
                                                            //                       hintText: "Enter User Name",
                                                            //                       hintStyle: TextStyle(
                                                            //                         fontSize: 13,
                                                            //                       ),
                                                            //                       enabledBorder: OutlineInputBorder(
                                                            //                         borderSide: BorderSide(width: 1, color: Colors.black45),
                                                            //                         borderRadius: BorderRadius.circular(10),
                                                            //                       ),
                                                            //                       focusedBorder: OutlineInputBorder(
                                                            //                         borderSide: BorderSide(width: 1, color: Colors.black45),
                                                            //                         borderRadius: BorderRadius.circular(10),
                                                            //                       ),
                                                            //                       border: InputBorder.none,
                                                            //                     ),
                                                            //                   ),
                                                            //                 ),
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       10,
                                                            //                 ),
                                                            //                 Text(
                                                            //                   "UPI Id ",
                                                            //                   style: TextStyle(
                                                            //                       fontSize: 15,
                                                            //                       color: Color(0xff085272),
                                                            //                       fontWeight: FontWeight.w500),
                                                            //                 ),
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       10,
                                                            //                 ),
                                                            //                 Container(
                                                            //                   // width: MediaQuery.of(context).size.width/2.4,
                                                            //                   child:
                                                            //                       TextFormField(
                                                            //                     controller: upi_id,
                                                            //                     keyboardType: TextInputType.text,
                                                            //                     decoration: InputDecoration(
                                                            //                       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                                            //                       fillColor: Colors.white,
                                                            //                       filled: true,
                                                            //                       hintText: "Enter Upi Id",
                                                            //                       hintStyle: TextStyle(
                                                            //                         fontSize: 13,
                                                            //                       ),
                                                            //                       enabledBorder: OutlineInputBorder(
                                                            //                         borderSide: BorderSide(width: 1, color: Colors.black45),
                                                            //                         borderRadius: BorderRadius.circular(10),
                                                            //                       ),
                                                            //                       focusedBorder: OutlineInputBorder(
                                                            //                         borderSide: BorderSide(width: 1, color: Colors.black45),
                                                            //                         borderRadius: BorderRadius.circular(10),
                                                            //                       ),
                                                            //                       border: InputBorder.none,
                                                            //                     ),
                                                            //                   ),
                                                            //                 ),
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       15,
                                                            //                 ),
                                                            //                 Card(
                                                            //                   elevation:
                                                            //                       3,
                                                            //                   shape:
                                                            //                       ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                            //                   child:
                                                            //                       Container(
                                                            //                     alignment: Alignment.center,
                                                            //                     height: 45,
                                                            //                     decoration: BoxDecoration(
                                                            //                       borderRadius: BorderRadius.all(Radius.circular(5)),
                                                            //                       color: Color.fromARGB(255, 226, 62, 29),
                                                            //                     ),
                                                            //                     child: MaterialButton(
                                                            //                         height: 45,
                                                            //                         minWidth: MediaQuery.of(context).size.width,
                                                            //                         highlightColor: Colors.redAccent,
                                                            //                         onPressed: () {
                                                            //                           setState(() {
                                                            //                             Add_pay();
                                                            //                           });
                                                            //                         },
                                                            //                         child: Text(
                                                            //                           "Add Details",
                                                            //                           style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                            //                         )),
                                                            //                   ),
                                                            //                 ),
                                                            //                 SizedBox(
                                                            //                   height:
                                                            //                       15,
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           ),
                                                            //         );
                                                            //       });
                                                            //     });
                                                          },
                                                          icon:
                                                              //  payment_details ==
                                                              //         "1"
                                                              //     ? Icon(
                                                              //         Icons
                                                              //             .login_outlined,
                                                              //         color: Colors
                                                              //             .green,
                                                              //         size: 40,
                                                              //       )
                                                              //     :
                                                              Icon(
                                                            Icons.logout_sharp,
                                                            color: Colors.red,
                                                            size: 30,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    payment_details != "1"
                                                        ? Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "User Name :",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child: payment_name !=
                                                                            null
                                                                        ? Text(
                                                                            payment_name.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            "Shasy Mitra".toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                  )
                                                                ],
                                                              ),
                                                              // SizedBox(
                                                              //   height: 15,
                                                              // ),
                                                              // Row(
                                                              //   children: [
                                                              //     Text(
                                                              //       "UPI Id:",
                                                              //       style: TextStyle(
                                                              //           fontSize:
                                                              //               14,
                                                              //           fontWeight:
                                                              //               FontWeight.w500),
                                                              //     ),
                                                              //     Expanded(
                                                              //       child:
                                                              //           Column(
                                                              //         crossAxisAlignment:
                                                              //             CrossAxisAlignment
                                                              //                 .start,
                                                              //         children: [
                                                              //           Padding(
                                                              //               padding:
                                                              //                   const EdgeInsets.only(left: 5.0),
                                                              //               child: payment_upi_id != null
                                                              //                   ? Text(
                                                              //                       payment_upi_id.toString(),
                                                              //                       style: TextStyle(
                                                              //                         fontSize: 14,
                                                              //                       ),
                                                              //                     )
                                                              //                   : Text(
                                                              //                       "user@paymknj".toString(),
                                                              //                       style: TextStyle(
                                                              //                         fontSize: 14,
                                                              //                       ),
                                                              //                     )),
                                                              //         ],
                                                              //       ),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              // SizedBox(
                                                              //   height: 15,
                                                              // ),
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  // second tab bar view widget
                                  Container(
                                    // height: MediaQuery.of(context).size.height*0.4,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "your_farm_lands".tr,
                                                style: TextStyle(
                                                    color: Color(0xff81d3f2),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                child: IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Add_farm_land(
                                                                    mobile: mobileNo
                                                                        .toString(),
                                                                    image: image
                                                                        .toString(),
                                                                    name: name
                                                                        .toString(),
                                                                  )));
                                                    },
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      color: Colors.green,
                                                      size: 45,
                                                    )),
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.28,
                                            child: ListView.builder(
                                                physics: ScrollPhysics(),
                                                itemCount: get_form_land.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return get_form_land == null
                                                      ? Center(
                                                          child: Text(
                                                              'No Data Please Update Form Data'),
                                                        )
                                                      : SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Divider(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      get_form_land[index]
                                                                              [
                                                                              'title']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Color(
                                                                              0xff085272),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.4,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text("District :",
                                                                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                                                                              child: Text("${'tehsile'.tr} :", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                            ),
                                                                            Text("${"gramsabha".tr} :",
                                                                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                                                                              child: Text("${"land_size".tr} :", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                            ),
                                                                            Text("${'land_number'.tr} :",
                                                                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                                                                              child: Text("${'account_holder_name'.tr} :", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                            ),
                                                                            Text("${'pincode'.tr} :",
                                                                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff66ad2d))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      // width: MediaQuery.of(context).size.width*0.4,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              get_form_land[index]['district_id'].toString(),
                                                                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 5, top: 5),
                                                                            child:
                                                                                Text(get_form_land[index]['tehsil_id'].toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                          ),
                                                                          Text(
                                                                              get_form_land[index]['gram_shabha'].toString(),
                                                                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 5, top: 5),
                                                                            child:
                                                                                Text(get_form_land[index]['land_size'].toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                          ),
                                                                          Text(
                                                                              get_form_land[index]['land_no'].toString(),
                                                                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 5, top: 5),
                                                                            child:
                                                                                Text(get_form_land[index]['ac_name'].toString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                          ),
                                                                          Text(
                                                                              get_form_land[index]['pin'].toString(),
                                                                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xff00aeef))),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Visibility(
                                                                  visible:
                                                                      istrue,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                          "cdghfasdg")
                                                                    ],
                                                                  )),
                                                              Divider(),
                                                              Divider(),
                                                            ],
                                                          ),
                                                        );
                                                }),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(right:55.0),
                                          //   child: InkWell(
                                          //     onTap: (){
                                          //       Navigator.push(context,
                                          //           MaterialPageRoute(builder: (context)=>
                                          //               Add_farm_land(
                                          //                 mobile:mobileNo.toString(),
                                          //                 image: image.toString(),
                                          //                 name: name.toString(),
                                          //               )));
                                          //     },
                                          //     child: Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text(title.toString(),style: TextStyle(color:Color(0xff707070),fontSize: 14,fontWeight: FontWeight.w500),),
                                          //         Icon(Icons.arrow_forward_ios,size: 20,color:Color(0xff707070),),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(height:15,),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(right:55.0),
                                          //   child: InkWell(
                                          //     onTap: (){
                                          //       Navigator.push(context,
                                          //           MaterialPageRoute(builder: (context)=>
                                          //               Add_farm_land(
                                          //                 mobile:mobileNo.toString(),
                                          //                 image: image.toString(),
                                          //                 name: name.toString(),
                                          //               )));
                                          //     },
                                          //     child: Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text("Wheal farms",style: TextStyle(color:Color(0xff707070),fontSize: 14,fontWeight: FontWeight.w500),),
                                          //         Icon(Icons.arrow_forward_ios,size: 20,color:Color(0xff707070),),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 15,),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(right:55.0),
                                          //   child: InkWell(
                                          //     onTap: (){
                                          //       Navigator.push(context,
                                          //           MaterialPageRoute(builder: (context)=>
                                          //               Add_farm_land(
                                          //                 mobile:mobileNo.toString(),
                                          //                 image: image.toString(),
                                          //                 name: name.toString(),
                                          //               )));
                                          //     },
                                          //     child: Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text("Wheal farms",style: TextStyle(color:Color(0xff707070),fontSize: 14,fontWeight: FontWeight.w500),),
                                          //         Icon(Icons.arrow_forward_ios,size: 20,color:Color(0xff707070),),
                                          //       ],
                                          //     ),
                                          //   ),
                                          //
                                        ]),
                                      ),
                                    )),
                                  ),
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
      bottomNavigationBar: percentage >= 80
          ? Container(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => crop_health()));
                    } else if (_currentIndex == 2) {
                      have_crop_plan == 'no'
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Crop_calendar()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Show_me_plan()));
                    } else if (_currentIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Crop_Advisory()));
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
            )
          : Container(
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Home_page()));
                    } else if (_currentIndex == 1) {
                      Fluttertoast.showToast(
                        msg: "completeprofilealert".tr,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => crop_health()));
                    } else if (_currentIndex == 2) {
                      Fluttertoast.showToast(
                        msg: "completeprofilealert".tr,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Show_me_plan()));
                    } else if (_currentIndex == 3) {
                      Fluttertoast.showToast(
                        msg: "completeprofilealert".tr,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                      );
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Crop_Advisory()));
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

  bool istrue = false;
}
