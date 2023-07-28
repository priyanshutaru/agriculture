import 'dart:convert';
import 'package:agriculture/all_Screen/all_home_screen/Sell_Crop_all_page/sellCrop_model/Sellcrop_model.dart';
import 'package:agriculture/all_Screen/all_home_screen/Show_me_plan.dart';
import 'package:agriculture/all_Screen/all_home_screen/crop_health_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile_all_screen/Profile_page.dart';
import 'Crop_Advisory_all_page/Crop_Advisory.dart';
import 'Home_Page.dart';
import 'cropp_calender_page.dart';

class Crop_calendar extends StatefulWidget {
  const Crop_calendar({Key? key}) : super(key: key);
  @override
  State<Crop_calendar> createState() => _Crop_calendarState();
}

class _Crop_calendarState extends State<Crop_calendar> {
  Future getId() async {
    final pref = await SharedPreferences.getInstance();
    var user_id = pref.getString('user_id');
  }

  int _currentIndex = 2;
  String dropdownvalue = 'भाषा/Language';
  var items = [
    'भाषा/Language',
    'हिन्दी/Hindi',
    'इंग्लिश/English',
  ];
  // List imageList = [];
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
      mainimg = res['img'].toString();
      print(user_id.toString() + "%%%%%%%%%%%%%%%%");
    });
  }

  bool isloading = true;
  // bool bannerloading = true;
  // Future bannerTop() async {
  //   var api = Uri.parse("https://onway.creditmywallet.in.net/api/banner_top");
  //   final response = await http.get(
  //     api,
  //   );
  //   var res = await json.decode(response.body);
  //   var msg = res['status_message'].toString();
  //   if (msg == "Success") {
  //     setState(() {
  //       bannerloading = true;
  //       imageList = res['response_userRegister'];
  //       isloading = true;
  //     });
  //   }
  // }

  String? search;
  var cropName, cropImage, Crop_id, planId;
  TextEditingController carsearch = TextEditingController();

  Future<List<StatusMessage>> getSellCrop() async {
    var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_crop");
    var response = await http.post(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["status_message"];
      return data.map((data) => StatusMessage.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  // Future getUserTask() async{
  //   final pref = await SharedPreferences.getInstance();
  //   var user_id = pref.getString('user_id');
  //   var api = Uri.parse('https://doplus.creditmywallet.in.net/api/get_current_user_task');
  //   Map data = {
  //     'user_id':user_id.toString(),
  //     'user_crop_plan_id':planId.toString(),
  //   };
  //   var data1 = jsonEncode(data);
  //   final response = await http.post(api,headers: {"Content-Type":"Application/json"},body: data1);
  //   var res = jsonDecode(response.body)['response'];
  //   if(response.statusCode==200){
  //     get_task = res;
  //     print(response.toString()+"AAAAAAAAAAAAA");
  //   }
  // }
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];
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

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  int _value = 1;
  String? imageList;
  bool bannerloading = false;
  Future bannerTop() async {
    setState(() {
      bannerloading = true;
    });
    Map data = {
      'screen_id': '3',
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

  @override
  void initState() {
    super.initState();
    // setState(() {
    bannerTop();
    getUser();
    checkcroplist();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
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
                                                updateLanguage(
                                                    Locale('hi', 'IN'));
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
                                                  updateLanguage(
                                                      Locale('en', 'US'));
                                                },
                                                child: Text(
                                                  "इंग्लिश/English",
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                        ),
                      ),
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
                    Center(
                      child: bannerloading
                          ? CircularProgressIndicator()
                          : Container(
                              child: Image.network(imageList!),
                            ),
                    ),
                    // Center(

                    //   // child: CarouselSlider(
                    //   //     options: CarouselOptions(
                    //   //         aspectRatio: 2.0,
                    //   //         enlargeCenterPage: true,
                    //   //         scrollDirection: Axis.horizontal,
                    //   //         autoPlay: true,
                    //   //         viewportFraction: 1),
                    //   //     items: [
                    //   //       for (var i = 0; i < img.length; i++)
                    //   //         bannerloading
                    //   //             ? Card(
                    //   //                 shape: RoundedRectangleBorder(
                    //   //                     borderRadius:
                    //   //                         BorderRadius.circular(15)),
                    //   //                 elevation: 5,
                    //   //                 child: Container(
                    //   //                   width:
                    //   //                       MediaQuery.of(context).size.width,
                    //   //                   decoration: BoxDecoration(
                    //   //                     borderRadius:
                    //   //                         BorderRadius.circular(15),
                    //   //                   ),
                    //   //                   child: ClipRRect(
                    //   //                     borderRadius:
                    //   //                         BorderRadius.circular(15),
                    //   //                     child: Image.asset(
                    //   //                         //imageList[i]['banner_img'].toString(),
                    //   //                         img[i].toString(),
                    //   //                         fit: BoxFit.fill),
                    //   //                   ),
                    //   //                 ),
                    //   //               )
                    //   //             : Container(
                    //   //                 child: Center(
                    //   //                   child: CupertinoActivityIndicator(
                    //   //                       color: Colors.green, radius: 30),
                    //   //                 ),
                    //   //               )
                    //   //     ]),
                    // ),
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
                      height: 15,
                    ),
                    Text(
                      "crop_calender".tr,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff447c94)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 40,
                      child: TextField(
                        cursorHeight: 25,
                        textInputAction: TextInputAction.search,
                        //controller: carsearch,
                        onChanged: (String? value) {
                          setState(() {
                            // search=value.toString();
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xff447c94),
                          ),
                          prefixText: "     ",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black45),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black45),
                          ),
                          hintText: 'Search Your Crop',
                          hintStyle: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                    
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
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
                                                planId = data[index]
                                                    .planId
                                                    .toString();
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Crop_calender(
                                                              cropName: data[
                                                                      index]
                                                                  .cropName
                                                                  .toString(),
                                                              cropImage: data[
                                                                      index]
                                                                  .img
                                                                  .toString(),
                                                              cropId: data[
                                                                      index]
                                                                  .cropId
                                                                  .toString(),
                                                              user_id: data[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              planid: data[
                                                                      index]
                                                                  .planId
                                                                  .toString())));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  //color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      height: 80,
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  data[index]
                                                                      .img
                                                                      .toString()))),
                                                      child: Container(
                                                        height: 80,
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.black38,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    data[index]
                                                                        .cropName
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
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
                                                planId = data[index]
                                                    .planId
                                                    .toString();
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Crop_calender(
                                                              cropName: data[
                                                                      index]
                                                                  .cropName
                                                                  .toString(),
                                                              cropImage: data[
                                                                      index]
                                                                  .img
                                                                  .toString(),
                                                              cropId: data[
                                                                      index]
                                                                  .cropId
                                                                  .toString(),
                                                              user_id: data[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              planid: data[
                                                                      index]
                                                                  .planId
                                                                  .toString())));
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
              // Expanded(
              //   child: ListView(
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           FutureBuilder<List<StatusMessage>>(
              //               future: getSellCrop(),
              //               builder:(context, AsyncSnapshot snapshot) {
              //                 if (!snapshot.hasData) {
              //                   return Center(child: CircularProgressIndicator());
              //                 } else {
              //                   List<StatusMessage>? data=snapshot.data;
              //                   return Container(
              //                     width: MediaQuery.of(context).size.width,
              //                     child: GridView.builder(
              //                         physics: NeverScrollableScrollPhysics(),
              //                         scrollDirection: Axis.vertical,
              //                         shrinkWrap: true,
              //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //                           crossAxisCount:2,
              //                         ),
              //                         itemCount:data!.length,
              //                         itemBuilder: (BuildContext ctx, index) {
              //                           String? postion=data[index].cropName.toString();
              //                           if(carsearch.text.isEmpty){
              //                             return InkWell(
              //                               onTap: (){
              //                                 setState(() {
              //                                   cropName=data[index].cropName.toString();
              //                                   cropImage=data[index].img.toString();
              //                                   Crop_id=data[index].cropId.toString();
              //                                 });
              //                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>
              //                                     Sell_crop2_page(
              //                                       cropName: cropName.toString(),
              //                                       cropImage: cropImage.toString(),
              //                                       Crop_id: Crop_id.toString(),
              //                                     )));
              //                               },
              //                               child: Container(
              //                                 alignment: Alignment.center,
              //                                 child: Container(
              //
              //                                   height: 90,
              //                                   width: MediaQuery.of(context).size.width*0.43,
              //                                   decoration: BoxDecoration(
              //                                     borderRadius: BorderRadius.circular(15),
              //                                       image: DecorationImage(
              //                                           image: NetworkImage(data[index].img.toString()),fit: BoxFit.fill
              //                                       )
              //                                   ),
              //                                   child: Padding(
              //                                     padding: const EdgeInsets.only(top: 65,right: 50),
              //                                     child: Container(
              //                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
              //                                         child: Center(child: Text(data[index].cropName.toString(),style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),))),
              //                                   ),
              //                                 ),
              //                               ),
              //                             );
              //                           }else if(postion.toLowerCase().contains(carsearch.text.toLowerCase())){
              //                             return InkWell(
              //                               onTap: (){
              //                                 setState(() {
              //                                   cropName=data[index].cropName.toString();
              //                                   cropImage=data[index].img.toString();
              //                                   Crop_id=data[index].cropId.toString();
              //                                 });
              //                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>
              //                                     Sell_crop2_page(
              //                                       cropName: cropName.toString(),
              //                                       cropImage: cropImage.toString(),
              //                                       Crop_id: Crop_id.toString(),
              //                                     )));
              //                               },
              //                               child: Container(
              //                                 alignment: Alignment.center,
              //                                 decoration: BoxDecoration(
              //                                   //color: Colors.white,
              //                                     borderRadius: BorderRadius.circular(8)),
              //                                 child: Column(
              //                                   children: [
              //                                     Container(
              //                                       height: 80,
              //                                       width: 80,
              //                                       decoration: BoxDecoration(
              //                                           image: DecorationImage(
              //                                               image: NetworkImage(data[index].img.toString())
              //                                           )
              //                                       ),
              //                                     ),
              //                                     Text(data[index].cropName.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xff447c95)),),
              //                                   ],
              //                                 ),
              //                               ),
              //                             );
              //                           }else{
              //                             return Container();
              //                           }
              //                         }),
              //                   );
              //                 }
              //               }
              //           )
              //
              //         ],
              //       ),
              //     ],
              //   ),
              // )
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
}
