import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../profile_all_screen/Profile_page.dart';
import '../Crop_Advisory_all_page/Crop_Advisory.dart';
import '../Home_Page.dart';
import '../Show_me_plan.dart';
import '../crop_health_page.dart';

class Sell_crop2_page extends StatefulWidget {
  Sell_crop2_page(
      {required this.cropName, required this.cropImage, required this.Crop_id});
  String cropName, cropImage, Crop_id;
  @override
  State<Sell_crop2_page> createState() => _Sell_crop2_pageState();
}

class _Sell_crop2_pageState extends State<Sell_crop2_page> {
  int _currentIndex = 0;
  bool isimageselected1 = false;
  String dropdownvalue = 'भाषा/Language';
  final List<String> itemsa = [
    'Plantains',
    'Yams',
    'Sorghum',
    'Sweet potatoes',
    'Cassava',
  ];
  TextEditingController _variety = TextEditingController();
  String? selectedValue;
  int? selectedvalue;
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
  bool bannerloading = true;

  Future bannerTop() async {
    setState(() {
      bannerloading = true;
    });
    Map data = {
      'screen_id': '2',
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

  final picker = ImagePicker();
  File? CropImage1;
  File? CropImage2;
  File? CropImage3;
  /* Future cropImage1(context, ImageSource source) async {
    final PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        CropImage1 = File(pickedFile.path);
        print(CropImage1!.path);
      });
    }
  }

  Future cropImage2(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() async {
        CropImage2 = new File(pickedFile.path);
        print(CropImage2!.path);
      });
    }
  }

  Future cropImage3(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() async {
        CropImage3 = new File(pickedFile.path);
        print(CropImage3!.path);
      });
    }
  }*/

  // String? dropdownvalue2 = 'Unit';
  // var unititems = ['Quintal', 'Kg', 'Gram ', 'Pieces', 'Dozen', 'Tonne', 'Ml'];
  String dropdownValue = 'unit'.tr;

  // var unitItemlist =  [
  //   'Quintal',
  //   'Kg',
  //   'Gram ',
  //   'Pieces',
  //   'Dozen',
  //   'Tonne',
  //   'Ml'
  // ];
  List varirtylist = [];

  // Future getAllUnit() async {
  //   var baseUrl = "https://doplus.creditmywallet.in.net/api/get_unit";
  //   http.Response response = await http.post(Uri.parse(baseUrl));
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body)["status_message"];
  //     setState(() {
  //       unitItemlist = jsonData;
  //       print("@@@@@@@@@@@@@@@@===>>>>>>" + unitItemlist.toString());
  //     });
  //   }
  // }

  // Future getAllvarity() async {
  //   var baseUrl = "https://doplus.creditmywallet.in.net/api/get_variety";
  //   http.Response response = await http.post(Uri.parse(baseUrl));
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);
  //     setState(() {
  //       varirtylist = jsonData;
  //       print("@@@@@@@@@@@@@@@@===>>>>>>" + varirtylist.toString());
  //     });
  //   }
  // }
  Future SellCrop() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': user_id.toString(),
      'crop_id': Crop_id.toString(),
      'variety': _variety.text.toString(),
      'quantity': quantity.text.toString(),
      'unit': dropdownValue.toString(),
      'images': imageFileList,
      'expected_price': ExpPrice.text.toString()
    });
    print(selectedvalue.toString());
    var response = await dio.post(
        'https://doplus.creditmywallet.in.net/api/sell_crop',
        data: formData);
    print(formData.toString() + "all formData>>>>>>>@@@@@@@@@");
    print("response ====>>>" + response.toString());
    var res = response.data;
    int msg = res['status_code'];
    print("bjhgbvfjhdfgbfu====>..." + msg.toString());
    if (msg == 200) {
      Fluttertoast.showToast(
          msg: 'Request_Submitted_Successfully'.tr,
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
      setState(() {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Request_Submitted_Successfully'.tr,
            onConfirmBtnTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Home_page()));
            });
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Home_page()));
      });
      //Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: 'Server Error..',
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER);
    }
  }

  var cropName, cropImage, Crop_id;
  List imageFileList = [];
  TextEditingController quantity = TextEditingController();
  TextEditingController ExpPrice = TextEditingController();
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
    super.initState();
    setState(() {
      cropName = '${widget.cropName.toString()}';
      cropImage = '${widget.cropImage.toString()}';
      Crop_id = '${widget.Crop_id.toString()}';
      bannerTop();
      getUser();
      // getAllUnit();
      // getAllvarity();
    });
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
              SizedBox(
                height: 10,
              ),
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
                                ? CircularProgressIndicator()
                                : Container(
                                    child: Image.network(imageList!),
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
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Text("your_selected_crop".tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff759eb0),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  cropImage.toString()))),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      cropName.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff447c95)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffD1D1D1),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xfff5fcff),
                                  ),
                                  child: TextFormField(
                                    controller: _variety,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        hintText: "variety_of_crop".tr,
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  ),
                                ),
                                // Container(
                                //   height: 40,
                                //   width: MediaQuery
                                //       .of(context)
                                //       .size
                                //       .width,
                                //   padding: EdgeInsets.symmetric(
                                //       horizontal: 20, vertical: 0),
                                //   decoration: BoxDecoration(
                                //     border: Border.all(
                                //       width: 1, color: Color(0xffD1D1D1),),
                                //     borderRadius: BorderRadius.circular(5),
                                //     color: Color(0xfff5fcff),
                                //   ),
                                //   child: DropdownButtonHideUnderline(
                                //     child:  DropdownButton(
                                //       hint: Text(
                                //         'Variety of Crop',
                                //         style: TextStyle(
                                //             fontSize: 14,
                                //             color: Color(0xff508399),
                                //             fontWeight: FontWeight.w600
                                //         ),
                                //       ),
                                //       items: varirtylist.map((item) =>
                                //           DropdownMenuItem<String>(
                                //             value: item['variety_name']
                                //                 .toString(),
                                //             child: Text(
                                //               item['variety_name']
                                //                   .toString(),
                                //               style: TextStyle(
                                //                 fontSize: 14,),
                                //             ),
                                //           ))
                                //           .toList(),
                                //       value: selectedValue,
                                //       onChanged: (value) {
                                //         setState(() {
                                //           selectedValue =
                                //           value as String;
                                //           print("variety_name==>>" +
                                //               selectedValue.toString());
                                //         });
                                //       },
                                //       iconSize: 25,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.7,
                                      color: Color(0xffD1D1D1),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          width: 95,
                                          decoration: BoxDecoration(
                                              color: Color(0xfff0f0f0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(0xffD1D1D1),
                                                    spreadRadius: 1),
                                              ],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5))),
                                          padding: EdgeInsets.only(left: 10),
                                          child: Center(
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                hint: Text(
                                                  'unit'.tr,
                                                ),
                                                items: <String>[
                                                  'unit'.tr,
                                                  'Quintal/क्विंटल',
                                                  'Kg/किलोग्राम',
                                                  'Gram/चना',
                                                  'Pieces/टुकड़े',
                                                  'Dozen/दर्जन',
                                                  'Tonne/टन',
                                                  'Ml/मिलीलीटर',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff508399),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  );
                                                }).toList(),
                                                value: dropdownValue,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue = newValue!;
                                                    print(dropdownValue
                                                        .toString());
                                                  });
                                                },
                                                iconSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: quantity,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 20, bottom: 7),
                                            fillColor: Color(0xfff5fcff),
                                            filled: true,
                                            hintText: "quantity_to_sell".tr,
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xff447c95),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5)),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("upload_product_image".tr,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff759eb0),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        camera();
                                      },
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  7,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.8,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffBEBEBE),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: CropImage1 == null
                                                  ? Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_viewfinder,
                                                            size: 50,
                                                            color: Color(
                                                                0xff7A99A5),
                                                          ),
                                                          Text(
                                                            'click_here'.tr,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff085272)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Image.file(CropImage1!,
                                                      fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Positioned(
                                              right: -10,
                                              top: -10,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    CropImage1 = null;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  size: 15,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print('love');
                                        camera2();
                                      },
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  7,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.8,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black26,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: CropImage2 == null
                                                  ? Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_viewfinder,
                                                            size: 50,
                                                            color: Color(
                                                                0xff7A99A5),
                                                          ),
                                                          Text(
                                                            'click_here'.tr,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff085272)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Image.file(CropImage2!,
                                                      fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Positioned(
                                              right: -10,
                                              top: -10,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    CropImage2 = null;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  size: 15,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        camera3();
                                      },
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  7,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.8,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black26,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: CropImage3 == null
                                                  ? Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .camera_viewfinder,
                                                            size: 50,
                                                            color: Color(
                                                                0xff7A99A5),
                                                          ),
                                                          Text(
                                                            'click_here'.tr,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff085272)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Image.file(CropImage3!,
                                                      fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Positioned(
                                              right: -10,
                                              top: -10,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    CropImage3 = null;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  size: 15,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: ExpPrice,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 15),
                                    fillColor: Color(0xfff5fcff),
                                    filled: true,
                                    hintText: "pls_enter_expected_price".tr,
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff89afbf),
                                        fontWeight: FontWeight.w600),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black45),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black26),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
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
                                          setState(() {
                                            SellCrop();
                                          });
                                        },
                                        child: Text(
                                          "create_request".tr,
                                          style: TextStyle(
                                              fontSize: 16,
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

  void camera() {
    Widget onPostiveButton = TextButton(
      onPressed: () async {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) return;
        {
          setState(() {
            isimageselected1 = true;
            CropImage1 = File(image.path);
            imageFileList.add(CropImage1);
          });
        }
        Navigator.of(context).pop();
      },
      child: Text(
        "Camera",
        style: TextStyle(
            fontSize: 17,
            fontFamily: 'SairaCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      ),
    );
    Widget onNegativeButton = TextButton(
      onPressed: () async {
        final image = await ImagePicker().getImage(source: ImageSource.gallery);
        if (image == null) return;
        {
          setState(() {
            isimageselected1 = true;
            CropImage1 = File(image.path);
            imageFileList.add(CropImage1);
            print("image all pic>>>??????>>" + imageFileList.toString());
          });
        }
        Navigator.pop(context);
      },
      child: Text(
        "Gallery",
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'SairaCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      ),
    );
    AlertDialog dialog = AlertDialog(
      actions: [onNegativeButton, onPostiveButton],
      title: Text("Select From :"),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void camera2() {
    Widget onPostiveButton = TextButton(
      onPressed: () async {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) return;
        {
          setState(() {
            isimageselected1 = true;
            CropImage2 = File(image.path);
            imageFileList.add(CropImage2);
          });
        }
        Navigator.of(context).pop();
      },
      child: Text(
        "Camera",
        style: TextStyle(
            fontSize: 17,
            fontFamily: 'SairaCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      ),
    );
    Widget onNegativeButton = TextButton(
      onPressed: () async {
        final image = await ImagePicker().getImage(source: ImageSource.gallery);
        if (image == null) return;
        {
          setState(() {
            isimageselected1 = true;
            CropImage2 = File(image.path);
            imageFileList.add(CropImage2);
            print("image all pic>>>??????>>" + imageFileList.toString());
          });
        }
        Navigator.pop(context);
      },
      child: Text(
        "Gallery",
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'SairaCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      ),
    );
    AlertDialog dialog = AlertDialog(
      actions: [onNegativeButton, onPostiveButton],
      title: Text("Select From :"),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void camera3() {
    Widget onPostiveButton = TextButton(
      onPressed: () async {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) return;
        {
          setState(() {
            isimageselected1 = true;
            CropImage3 = File(image.path);
            imageFileList.add(CropImage3);
          });
        }
        Navigator.of(context).pop();
      },
      child: Text(
        "Camera",
        style: TextStyle(
            fontSize: 17,
            fontFamily: 'SairaCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      ),
    );
    Widget onNegativeButton = TextButton(
      onPressed: () async {
        final image = await ImagePicker().getImage(source: ImageSource.gallery);
        if (image == null) return;
        {
          setState(() {
            isimageselected1 = true;
            CropImage3 = File(image.path);
            imageFileList.add(CropImage3);
            print("image all pic>>>??????>>" + imageFileList.toString());
          });
        }
        Navigator.pop(context);
      },
      child: Text(
        "Gallery",
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'SairaCondensed',
            fontWeight: FontWeight.bold,
            color: Colors.green),
      ),
    );
    AlertDialog dialog = AlertDialog(
      actions: [onNegativeButton, onPostiveButton],
      title: Text("Select From :"),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}
