import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../all_Screen/all_home_screen/Crop_Advisory_all_page/Crop_Advisory.dart';
import '../all_Screen/all_home_screen/Home_Page.dart';
import '../all_Screen/all_home_screen/Show_me_plan.dart';
import '../all_Screen/all_home_screen/crop_health_page.dart';
import 'Profile_page.dart';

class Edit_profile extends StatefulWidget {
  Edit_profile(
      {Key? key,
      required this.name,
      required this.image,
      required this.district,
      required this.state,
      required this.pincode,
      required this.address,
      required this.mobile})
      : super(key: key);
  String name, image, address, district, mobile, state, pincode;

  @override
  State<Edit_profile> createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile>
    with SingleTickerProviderStateMixin {
  bool loading = false;

  TabController? _tabController;
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _thana = TextEditingController();
  int _currentIndex = 3;
  String dropdownvalue = 'भाषा/Language';
  // List of items in our dropdown menu
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  var name, image, district, state, pincode, address, mobile;
  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  final picker = ImagePicker();
  File? CropImage;
  Future CropImage1(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        CropImage = new File(pickedFile.path);
        print(CropImage?.path);
        EditImgProfile();
      });
    }
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
      print(percentage.toString() + "%%%%%%%%%%%%%%%%");
      loading = false;
    });
  }

  Future EditImgProfile() async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    // String addhar1 = CropImage!.path.split('/').last;
    Map data = {
      'user_id': user_id.toString(),
      'name': _name.text.toString(),
      'address': _address.text.toString(),
      'district': districtid.toString(),
      'state': location.toString(),
      'pin_code': _pincode.text.toString(),
      'tehsil': tehsile.toString(),
      'thana': _thana.text.toString(),
    };
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/complete_profile");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body);
    String msg = res['status_message'];
    if (msg == 'Success') {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile_page()));
      });
    } else {
      setState(() {
        Fluttertoast.showToast(
            msg: msg.toString(),
            backgroundColor: Colors.green,
            gravity: ToastGravity.CENTER);
        loading = false;
      });
    }
  }
  // Future EditImgProfile() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   // String addhar1 = CropImage!.path.split('/').last;
  //   var dio = Dio();
  //   var formData = FormData.fromMap({
  //     'user_id': user_id.toString(),
  //     'name': _name.text.toString(),
  //     'address': _address.text.toString(),
  //     'district': districtid.toString(),
  //     'state': location.toString(),
  //     'pin_code': _pincode.text.toString(),
  //     'tehsil': tehsile.toString(),
  //     'thana': _thana.text.toString(),
  //     // 'img': await MultipartFile.fromFile(CropImage!.path, filename: addhar1),
  //   });
  //   String? msg;
  //   var response = await dio.post(
  //       'https://doplus.creditmywallet.in.net/api/complete_profile',
  //       data: formData);
  //   print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
  //   print("response ====>>>" + response.toString());
  //   var res = jsonDecode(response.data);
  //   msg = res['response'];
  //   print("bjhgbvfjhdfgbfu====>..." + msg.toString());
  //   if (msg == 1) {
  //     setState(() {
  //       loading = false;
  //       setState(() {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => Profile_page()));
  //         Fluttertoast.showToast(
  //           msg: msg.toString(),
  //           backgroundColor: Colors.green,
  //           gravity: ToastGravity.CENTER,
  //         );
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       Fluttertoast.showToast(
  //           msg: msg.toString(),
  //           backgroundColor: Colors.green,
  //           gravity: ToastGravity.CENTER);
  //       loading = false;
  //     });
  //   }

  //   // } else {
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

  String? location;
  List get_city_list = [];
  Future get_State() async {
    setState(() {
      loading = true;
    });
    Map data = {'country_id': '91'};
    var data1 = jsonEncode(data);
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_state");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['data'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_city_list = res;
      print(get_city_list.toString() + "%%%%%%%%%%%%%%%%");
      loading = false;
    });
  }

  List get_district_list = [];
  String? districtid;
  Future get_District() async {
    setState(() {
      loading = true;
    });
    Map data = {'state_id': location.toString()};
    var data1 = jsonEncode(data);
    var url =
        Uri.parse("https://doplus.creditmywallet.in.net/api/get_district");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['data'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_district_list = res;
      print(get_district_list.toString() + "%%%%%%%%%%%%%%%%");
      loading = false;
    });
  }

  List get_tehsile_list = [];
  String? tehsile;
  Future get_Tehsile() async {
    setState(() {
      loading = true;
    });
    Map data = {'district_id': districtid.toString()};
    var data1 = jsonEncode(data);
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_tehsil");
    final response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: data1);
    var res = jsonDecode(response.body)['data'];
    setState(() {
      print("%%%%%%%%%%%%" + res.toString());
      get_tehsile_list = res;
      setState(() {
        loading = false;
      });
      print(get_tehsile_list.toString() + "%%%%%%%%%%%%%%%%");
    });
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

  @override
  void initState() {
    super.initState();
    getUser();
    get_State();
    EditImgProfile().whenComplete(() {
      _name.clear();
      _address.clear();
      _pincode.clear();
    });
    getpercentage();
    name = "${widget.name.toString()}";
    image = "${widget.image.toString()}";
    district = "${widget.district.toString()}";
    state = "${widget.state.toString()}";
    pincode = "${widget.pincode.toString()}";
    address = "${widget.address.toString()}";
    mobile = "${widget.mobile.toString()}";
    _name.text = name.toString();
    _address.text = address.toString();
    _pincode.text = pincode.toString();
    // if (_address.text == 'null' && _name.text == 'null') {
    //   _address.text == 'Please Update Address';
    //   _name.text == 'Please Update Name';
    // } else {
    //   _address.text = _address.text;
    //   _name.text = _name.text;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
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
                                        // SizedBox(
                                        //   height: 30,
                                        // ),
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
                    // Card(
                    //   elevation: 5,
                    //   color: Color(0xff65AC2B),
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15)),
                    //   child: Container(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(10.0),
                    //       child: Container(
                    //         padding: const EdgeInsets.all(5.0),
                    //         width: MediaQuery.of(context).size.width,
                    //         // height: MediaQuery.of(context).size.height/7.5,
                    //         child: Column(
                    //           crossAxisAlignment:
                    //               CrossAxisAlignment.center,
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.start,
                    //                       children: [
                    //                         Stack(
                    //                           children: [
                    //                             Container(
                    //                               width: MediaQuery.of(
                    //                                           context)
                    //                                       .size
                    //                                       .width /
                    //                                   4.7,
                    //                               child: CropImage == null
                    //                                   ? ClipRRect(
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                                   40.0),
                    //                                       child: loading
                    //                                           ? CircularProgressIndicator()
                    //                                           : Container(
                    //                                               height:
                    //                                                   80,
                    //                                               width: MediaQuery.of(context).size.width /
                    //                                                   4.7,
                    //                                               decoration:
                    //                                                   BoxDecoration(
                    //                                                       image: DecorationImage(
                    //                                                 fit: BoxFit
                    //                                                     .cover,
                    //                                                 image: NetworkImage(image == null
                    //                                                     ? 'https://w7.pngwing.com/pngs/754/2/png-transparent-samsung-galaxy-a8-a8-user-login-telephone-avatar-pawn-blue-angle-sphere-thumbnail.png'
                    //                                                     : image.toString()),
                    //                                               )),
                    //                                             ),
                    //                                     )
                    //                                   : ClipRRect(
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                                   40.0),
                    //                                       child: Container(
                    //                                           height: 80,
                    //                                           width: MediaQuery.of(context)
                    //                                                   .size
                    //                                                   .width /
                    //                                               4.7,
                    //                                           child: Image.file(
                    //                                               CropImage!,
                    //                                               fit: BoxFit
                    //                                                   .cover)),
                    //                                     ),
                    //                             ),
                    //                             Positioned(
                    //                                 bottom: 0,
                    //                                 top: 45,
                    //                                 right: -12,
                    //                                 child: IconButton(
                    //                                   onPressed: () {
                    //                                     showDialog(
                    //                                       context:
                    //                                           context,
                    //                                       builder:
                    //                                           (BuildContext
                    //                                               context) {
                    //                                         return AlertDialog(
                    //                                           title: Text(
                    //                                               "Upload profile image"),
                    //                                           actions: <
                    //                                               Widget>[
                    //                                             MaterialButton(
                    //                                               child: Text(
                    //                                                   "Camera"),
                    //                                               onPressed:
                    //                                                   () {
                    //                                                 CropImage1(
                    //                                                     context,
                    //                                                     ImageSource.camera);
                    //                                                 Navigator.pop(
                    //                                                     context);
                    //                                               },
                    //                                             ),
                    //                                             MaterialButton(
                    //                                               child: Text(
                    //                                                   "Gallery"),
                    //                                               onPressed:
                    //                                                   () {
                    //                                                 CropImage1(
                    //                                                     context,
                    //                                                     ImageSource.gallery);
                    //                                                 Navigator.pop(
                    //                                                     context);
                    //                                               },
                    //                                             )
                    //                                           ],
                    //                                         );
                    //                                       },
                    //                                     );
                    //                                   },
                    //                                   icon: Icon(
                    //                                     CupertinoIcons
                    //                                         .camera_fill,
                    //                                     color:
                    //                                         Colors.white,
                    //                                   ),
                    //                                 ))
                    //                           ],
                    //                         ),
                    //                         Padding(
                    //                           padding:
                    //                               const EdgeInsets.only(
                    //                                   left: 15),
                    //                           child: Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment
                    //                                     .start,
                    //                             children: [
                    //                               Text(
                    //                                 "Hey !!",
                    //                                 style: TextStyle(
                    //                                     fontSize: 14,
                    //                                     fontWeight:
                    //                                         FontWeight
                    //                                             .w400,
                    //                                     color:
                    //                                         Colors.white),
                    //                               ),
                    //                               SizedBox(
                    //                                 height: 5,
                    //                               ),
                    //                               Text(
                    //                                 name.toString(),
                    //                                 style: TextStyle(
                    //                                     fontSize: 13,
                    //                                     fontWeight:
                    //                                         FontWeight
                    //                                             .bold,
                    //                                     color:
                    //                                         Colors.white),
                    //                               ),
                    //                               SizedBox(
                    //                                 height: 5,
                    //                               ),
                    //                               Row(
                    //                                 children: [
                    //                                   Text(
                    //                                     mobile.toString(),
                    //                                     style: TextStyle(
                    //                                         fontSize: 12,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold,
                    //                                         color: Colors
                    //                                             .white),
                    //                                   ),
                    //                                   Icon(
                    //                                     Icons.edit,
                    //                                     size: 18,
                    //                                     color:
                    //                                         Colors.white,
                    //                                   )
                    //                                 ],
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         )
                    //                       ],
                    //                     ),
                    //                     SizedBox(
                    //                       height: 7,
                    //                     ),
                    //                     percentage != 100
                    //                         ? Text(
                    //                             "Get full access complete 100% profile",
                    //                             style: TextStyle(
                    //                                 fontSize: 11,
                    //                                 fontWeight:
                    //                                     FontWeight.bold,
                    //                                 color: Colors.white),
                    //                           )
                    //                         : Text('')
                    //                   ],
                    //                 ),
                    //                 percentage != 100
                    //                     ? Container(
                    //                         child:
                    //                             CircularPercentIndicator(
                    //                           radius: 45.0,
                    //                           lineWidth: 8.0,
                    //                           animation: true,
                    //                           animationDuration: 5000,
                    //                           percent:
                    //                               percentage / 100 == null
                    //                                   ? 10
                    //                                   : percentage / 100,
                    //                           center: Text(
                    //                             percentage == null
                    //                                 ? "10%"
                    //                                 : percentage
                    //                                         .toString() +
                    //                                     "%",
                    //                             style: TextStyle(
                    //                                 fontWeight:
                    //                                     FontWeight.bold,
                    //                                 fontSize: 16.0,
                    //                                 color: Colors.white),
                    //                           ),
                    //                           circularStrokeCap:
                    //                               CircularStrokeCap.round,
                    //                           progressColor: Colors.white,
                    //                         ),
                    //                       )
                    //                     : Text('')
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // tab bar view here
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                Card(
                                  child: Container(
                                    //height:MediaQuery.of(context).size.height/2.5,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        //color: Color(0xff00aeef),
                                        //borderRadius: BorderRadius.circular(25)
                                        ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "edit_profile".tr,
                                              style: TextStyle(
                                                  color: Color(0xff81d3f2),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 80,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Color(0xff40bdeb),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: MaterialButton(
                                                  highlightColor: Colors.green,
                                                  onPressed: () {
                                                    EditImgProfile();
                                                  },
                                                  child: Text(
                                                    "save".tr,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _name,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 15),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "Name".tr,
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _address,
                                          minLines: 5,
                                          maxLines: 10,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 15),
                                            hintText: 'address'.tr,
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 3, bottom: 3),
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField(
                                                value: location,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                hint: Text(
                                                  "       ${'state'.tr}",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                icon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                                items:
                                                    get_city_list.map((item) {
                                                  return DropdownMenuItem(
                                                    value: item['state_id']
                                                        .toString(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Text(
                                                        item['state_title']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    setState(() {
                                                      location =
                                                          newValue! as String?;
                                                      get_District();
                                                    });
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 3, bottom: 3),
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField(
                                                value: districtid,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                hint: Text(
                                                  "       ${'district'.tr}",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                icon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                                items: get_district_list
                                                    .map((item) {
                                                  return DropdownMenuItem(
                                                    value:
                                                        item['id'].toString(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Text(
                                                        item['name'].toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    setState(() {
                                                      districtid =
                                                          newValue! as String?;
                                                      get_Tehsile();
                                                    });
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 10,),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 3, bottom: 3),
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField(
                                                value: tehsile,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                hint: Text(
                                                  "      ${'tehsile'.tr}",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                icon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                                items: get_tehsile_list
                                                    .map((item) {
                                                  return DropdownMenuItem(
                                                    value: item['tehsil_name']
                                                        .toString(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Text(
                                                        item['tehsil_name']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    tehsile =
                                                        newValue! as String?;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _thana,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 15),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "thana".tr,
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _pincode,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 15),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "pincode".tr,
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black45),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
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
