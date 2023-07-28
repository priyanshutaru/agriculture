import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile_all_screen/Profile_page.dart';
import '../all_home_screen/Home_Page.dart';

class Otp_page extends StatefulWidget {
  Otp_page({required this.mobile});
  String mobile;
  @override
  State<Otp_page> createState() => _Otp_pageState();
}

class _Otp_pageState extends State<Otp_page> {
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController _otp = TextEditingController();
  var user_id;
  void _setValue(user_id) async {
    final pref = await SharedPreferences.getInstance();
    final set1 = pref.setString('user_id', user_id);
    print("user_id  %%==>>>=++++" + set1.toString());
  }

  Future LoginApi() async {
    setState(() {
      loading = true;
    });
    if (formKey.currentState!.validate()) {
      Map data = {
        'mobile': widget.mobile.toString(),
      };
      Uri url = Uri.parse("https://doplus.creditmywallet.in.net/api/otp");
      var body1 = jsonEncode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "Application/json"}, body: body1);
      if (response.statusCode == 200) {
        var res = await json.decode(response.body);
        String msg = res['status_code'].toString();
        print("status_code @@@@@@88 88***>>>" + msg.toString());
        if (msg == "200") {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: 'OTP Send Success',
              backgroundColor: Colors.green,
              gravity: ToastGravity.CENTER);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>Otp_page(
          //   mobile: widget.mobile.toString(),
          // )));
        } else {
          Fluttertoast.showToast(msg: 'Not valid mobile number');
        }
      }
    }
  }

  Future OTP_Api() async {
    if (formKey.currentState!.validate()) {
      Map data = {
        'mobile': widget.mobile.toString(),
        'otp': _otp.text.toString()
      };
      Uri url =
          Uri.parse("https://doplus.creditmywallet.in.net/api/otp_verify");
      var body1 = jsonEncode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "Application/json"}, body: body1);
      if (response.statusCode == 200) {
        var res = await json.decode(response.body);
        String msg = res['status_message'].toString();
        setState(() {
          user_id = res["user_id"];
          _setValue(user_id);
        });
        print("status_code @@@@@@88 88***>>>" + msg.toString());
        if (msg == "Login Successfully") {
          Fluttertoast.showToast(
              msg: 'Login Successfully' + percentage.toString(),
              backgroundColor: Colors.green,
              gravity: ToastGravity.CENTER);
          if (percentage == 11) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Profile_page()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home_page()));
          }
        } else {
          Fluttertoast.showToast(msg: 'Invalid OTP');
        }
      }
    }
  }

  var percentage;
  Future getpercentage() async {
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _setValue(user_id);
      getpercentage();
    });
  }

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
                    // color: Colors.yellowAccent[100],
                    //  image: DecorationImage(
                    //    alignment: Alignment.topCenter,
                    //    image: AssetImage("assets/agri1 copy.png")
                    //  )
                    ),
                child: Column(
                  children: [
                    //SizedBox(height: 100,),

                    Container(
                      height: MediaQuery.of(context).size.height / 1.6,
                      decoration: BoxDecoration(
                          //color: Colors.yellowAccent[100],
                          image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/farmer.jpeg'),
                      )),
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
                                  setState(() {
                                    _value = int.parse(value.toString());
                                  });
                                }),
                          ),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "apptitle".tr,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.lightBlue),
                            ),
                          )),
                        ],
                      ),
                    ),
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
                        SizedBox(
                          height: 17,
                        ),
                        Text(
                          "enter_otp".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        /* Form(
                          key: formKey,
                          child: TextFormField(
                            controller: _Mobile_no,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon:Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 45,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft:  Radius.circular(5)),
                                    color: Colors.lightGreen,
                                  ),
                                  child: Text("+91",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                ) ,
                                //fillColor: Colors.brown.shade50,
                                // filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                                hintText: 'Enter Your Mobile Number',
                                hintStyle:TextStyle(fontSize: 15,color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black87,width: 0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black87,width: 0.5),
                                )

                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile no.....';
                              }
                              return null;
                            },
                          ),
                        ),*/
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: PinCodeTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Valid OTP";
                                  }
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(4)
                                ],
                                controller: _otp,
                                obscuringCharacter: '*',
                                appContext: context,
                                length: 4,
                                obscureText: false,
                                blinkWhenObscuring: true,
                                pinTheme: PinTheme(
                                    borderWidth: 0.1,
                                    shape: PinCodeFieldShape.box,
                                    fieldHeight: 45,
                                    fieldWidth: 45,
                                    activeFillColor: Color(0xff66cc33),
                                    disabledColor: Color(0xff66cc33),
                                    inactiveColor: Color(0xff66cc33),
                                    inactiveFillColor: Color(0xff66cc33),
                                    selectedFillColor: Colors.white,
                                    errorBorderColor: Colors.red,
                                    activeColor: Colors.white,
                                    selectedColor: Colors.white),
                                cursorColor: Colors.black54,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                keyboardType: TextInputType.number,
                                boxShadows: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.blueAccent,
                                    blurRadius: 1,
                                  )
                                ],
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {});
                                },
                                beforeTextPaste: (text) {
                                  debugPrint("Allowing to paste $text");
                                  return true;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                                      setState(() {
                                        OTP_Api();
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home_page()));
                                      });
                                    },
                                    child: Text(
                                      "Login".tr,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "not_recieved_otp".tr,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        LoginApi();
                                      });
                                    },
                                    child: Text(
                                      "resend".tr,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.lightBlueAccent),
                                    ))
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 10,
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
