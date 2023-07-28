// ignore_for_file: unused_import

import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Home_Page.dart';
import 'package:agriculture/main.dart';
import 'package:agriculture/profile_all_screen/Profile_page.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OTP_Page.dart';

class Login_page extends StatefulWidget {
  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController _Mobile_no = TextEditingController();
  // Future LoginApi() async {
  //   if (formKey.currentState!.validate()) {
  //     setState(() {
  //       loading = true;
  //     });
  //     Map data = {
  //       'mobile': _Mobile_no.text,
  //     };
  //     Uri url = Uri.parse("https://doplus.creditmywallet.in.net/api/otp");
  //     var body1 = jsonEncode(data);
  //     var response = await http.post(url,
  //         headers: {"Content-Type": "Application/json"}, body: body1);
  //     if (response.statusCode == 200) {
  //       var res = await json.decode(response.body);
  //       String msg = res['status_code'].toString();
  //       print("status_code @@@@@@88 88***>>>" + msg.toString());
  //       if (msg == "200") {
  //         setState(() {
  //           loading = false;
  //         });
  //         Fluttertoast.showToast(
  //             msg: 'OTP Send Success',
  //             backgroundColor: Colors.green,
  //             gravity: ToastGravity.CENTER);
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Otp_page(
  //                       mobile: _Mobile_no.text.toString(),
  //                     )));
  //       } else {
  //         Fluttertoast.showToast(msg: 'Enter valid mobile number');
  //       }
  //     }
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

  int _value = 1;

  // @override
  // void initState() {
  //   super.initState();
  // }
  //bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/farmer.jpeg'),
                  ),
                  color: Color(0xffe1f49e),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
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
                            // setState(() {
                            //   _value = int.parse(value.toString());
                            // });
                          }),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "apptitle".tr,
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.transparent),
                      ),
                    )),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image(image: AssetImage("assets/farmob.png")),
                        // Image.asset("assets/farmob.png"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "apt1".tr,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff00aeef)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "welcome".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "LOGIN/REGISTER",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Form(
                          //key: formKey,
                          child: TextFormField(
                            maxLength: 10,
                            //controller: _Mobile_no,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            decoration: InputDecoration(
                              counterText: "",

                              prefixIcon: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height / 15,
                                width: 60,
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                  color: Color(0xff66cc33),
                                ),
                                child: Text(
                                  "+91",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              hintText: 'Enter Your Mobile Number',
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black87, width: 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black87, width: 0.5),
                              ),
                              //border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile no.....';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
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
                              color: Colors.lightBlueAccent,
                            ),
                            child: loading
                                ? CircularProgressIndicator()
                                : MaterialButton(
                                    height: 45,
                                    minWidth: MediaQuery.of(context).size.width,
                                    highlightColor: Colors.green,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Home_page(),
                                          ),);
                                      // setState(() {
                                      //   LoginApi();
                                      // });
                                    },
                                    child: Text(
                                      "next".tr,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
