// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart' as g;
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../profile_all_screen/Profile_page.dart';
// import '../Crop_Advisory_all_page/Crop_Advisory.dart';
// import '../Home_Page.dart';
// import '../Show_me_plan.dart';
// import '../crop_health_page.dart';
// import 'Tubewell_All_model/Tubewel_bill_model.dart';
// import 'add_bill_page.dart';

// class Tubewell_page extends StatefulWidget {
//   Tubewell_page(
//       {Key? key, this.name, this.number, this.user_mobile, this.c_name})
//       : super(key: key);
//   String? name, number, user_mobile, c_name;
//   @override
//   State<Tubewell_page> createState() => _Tubewell_pageState();
// }

// class _Tubewell_pageState extends State<Tubewell_page> {
//   int _currentIndex = 0;
//   bool isChecked = true;
//   int? Car = 0;
//   String dropdownvalue = 'भाषा/Language';
//   var items = [
//     'भाषा/Language',
//     'हिन्दी/Hindi',
//     'इंग्लिश/English',
//   ];
//   String? payment_type;
//   Future<List<Data>> getTubewellBill() async {
//     final pref = await SharedPreferences.getInstance();
//     var user_id = pref.getString('user_id');
//     Map data = {
//       'user_id': user_id.toString(),
//     };
//     var url = Uri.parse("https://doplus.creditmywallet.in.net/api/get_bills");
//     var response = await http.post(url, body: data);
//     if (response.statusCode == 200) {
//       Map<String, dynamic> map = json.decode(response.body);
//       List<dynamic> data = map["data"];
//       return data.map((data) => Data.fromJson(data)).toList();
//     } else {
//       throw Exception('unexpected error occurred');
//     }
//   }

//   TextEditingController payment = TextEditingController();
//     final List locale = [
//     {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
//     {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
//   ];

//   updateLanguage(Locale locale) {
//     g.Get.back();
//     g.Get.updateLocale(locale);
//   }

//   int _value = 1;
//   @override
//   void initState() {
//     super.initState();
//     // setState(() {
//     //   getTubewellBill();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 Profile_page()));
//                                   },
//                                   child: Icon(
//                                     CupertinoIcons.person_circle,
//                                     size: 37,
//                                     color: Color(0xff00aeef),
//                                   )),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Text(
//                                 "apt1".tr,
//                                 style: TextStyle(
//                                     fontStyle: FontStyle.italic,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xff66ad2d)),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Text(
//                                 "apt2".tr,
//                                 style: TextStyle(
//                                     fontStyle: FontStyle.italic,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xff00aeef)),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 13,
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(5.0),
//                                 child: DropdownButton(
//                                     value: _value,
//                                     items: [
//                                       DropdownMenuItem(
//                                         child: Text(
//                                           "भाषा/Language",
//                                           style: TextStyle(fontSize: 8),
//                                         ),
//                                         value: 1,
//                                       ),
//                                       DropdownMenuItem(
//                                         child: TextButton(
//                                             onPressed: () {
//                                               updateLanguage(
//                                                   Locale('hi', 'IN'));
//                                             },
//                                             child: Text(
//                                               "हिन्दी/Hindi",
//                                               style: TextStyle(fontSize: 8),
//                                             )),
//                                         value: 2,
//                                       ),
//                                       DropdownMenuItem(
//                                           child: TextButton(
//                                               onPressed: () {
//                                                 updateLanguage(
//                                                     Locale('en', 'US'));
//                                               },
//                                               child: Text(
//                                                 "इंग्लिश/English",
//                                                 style: TextStyle(fontSize: 8),
//                                               )),
//                                           value: 3),
//                                     ],
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _value = int.parse(value.toString());
//                                       });
//                                     }),
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 45,
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     height: 25,
//                                     width: 40,
//                                     child: CircleAvatar(
//                                       backgroundColor: Colors.white24,
//                                       child: IconButton(
//                                           onPressed: () {
//                                             launch("tel:" +
//                                                 Uri.encodeComponent(
//                                                     '1234567890'));
//                                           },
//                                           icon: Icon(Icons.call,
//                                               color: Color(0xff66ad2d))),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Text(
//                                     "help".tr,
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         color: Color(0xff00aeef),
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   SizedBox(
//                                     height: 30,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                       )),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Tubewell Bills and Management",
//                         style: TextStyle(
//                             color: Color(0xff085272),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   Container(
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 45, left: 5, right: 5),
//                             child: Column(
//                               children: [
//                                 Card(
//                                   elevation: 8,
//                                   child: Container(
//                                     height: MediaQuery.of(context).size.height /
//                                         1.5,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.all(13),
//                                     child: Column(
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 45.0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(
//                                                         Icons.library_books,
//                                                         color:
//                                                             Color(0xff40BDEB),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 10,
//                                                       ),
//                                                       Text(
//                                                         "Collections",
//                                                         style: TextStyle(
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                             color: Color(
//                                                                 0xff085272)),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                               IconButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 Add_bill_page()));
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.add_circle,
//                                                     size: 45,
//                                                     color: Colors.green,
//                                                   )),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Expanded(
//                                           child: FutureBuilder<List<Data>>(
//                                               future: getTubewellBill(),
//                                               builder: (context,
//                                                   AsyncSnapshot snapshot) {
//                                                 if (!snapshot.hasData) {
//                                                   return Center(
//                                                       child:
//                                                           CircularProgressIndicator());
//                                                 } else {
//                                                   List<Data>? data =
//                                                       snapshot.data;
//                                                   return Container(
//                                                     // height: MediaQuery.of(context).size.height*0.2,
//                                                     child: ListView.builder(
//                                                         itemCount: data!.length,
//                                                         itemBuilder:
//                                                             (context, index) {
//                                                           return Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     bottom: 10),
//                                                             child: Card(
//                                                               shadowColor: data[
//                                                                               index]
//                                                                           .paidStatus
//                                                                           .toString() ==
//                                                                       "1"
//                                                                   ? Colors.red
//                                                                   : Colors
//                                                                       .green,
//                                                               elevation: 10,
//                                                               child: Container(
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .all(8),
//                                                                 child: Column(
//                                                                   children: [
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .spaceBetween,
//                                                                       children: [
//                                                                         Text(
//                                                                           "#" +
//                                                                               data[index].billId.toString(),
//                                                                           style: TextStyle(
//                                                                               fontSize: 11,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w500),
//                                                                         ),
//                                                                         Text("Created-On:" + data[index].createdDate.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500)),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height:
//                                                                           10,
//                                                                     ),
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Text(
//                                                                           "Type",
//                                                                           style: TextStyle(
//                                                                               fontSize: 13,
//                                                                               color: Color(0xff085272),
//                                                                               fontWeight: FontWeight.w500),
//                                                                         ),
//                                                                         SizedBox(
//                                                                           width:
//                                                                               8,
//                                                                         ),
//                                                                         Text(
//                                                                           ": Tubewell",
//                                                                           style: TextStyle(
//                                                                               fontSize: 12,
//                                                                               color: Color(0xff085272)),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height:
//                                                                           10,
//                                                                     ),
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.4,
//                                                                           child:
//                                                                               Text(
//                                                                             "Name",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.4,
//                                                                           child:
//                                                                               Text(
//                                                                             "Start-date",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.4,
//                                                                           child:
//                                                                               Text(
//                                                                             "End-date",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.6,
//                                                                           child:
//                                                                               Text(
//                                                                             "Unit",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 13,
//                                                                           child:
//                                                                               Text(
//                                                                             "Hrs",
//                                                                             style: TextStyle(
//                                                                                 fontSize: 12,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height: 3,
//                                                                     ),
//                                                                     Divider(),
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.4,
//                                                                           child:
//                                                                               Text(
//                                                                             data[index].name.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.4,
//                                                                           child:
//                                                                               Text(
//                                                                             data[index].startDate.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 10,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.4,
//                                                                           child:
//                                                                               Text(
//                                                                             data[index].endDate.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 10,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 5.6,
//                                                                           child:
//                                                                               Text(
//                                                                             data[index].unit.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               MediaQuery.of(context).size.width / 13,
//                                                                           child:
//                                                                               Text(
//                                                                             data[index].hours.toString(),
//                                                                             style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 color: Color(0xff085272),
//                                                                                 fontWeight: FontWeight.w500),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height:
//                                                                           15,
//                                                                     ),
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .spaceBetween,
//                                                                       children: [
//                                                                         Column(
//                                                                           children: [
//                                                                             Text(
//                                                                               "${"total_due".tr}: Rs. " + data[index].total.toString(),
//                                                                               style: TextStyle(fontSize: 12, color: Color(0xff3DBA3D), fontWeight: FontWeight.w500),
//                                                                             ),
//                                                                             SizedBox(
//                                                                               height: 5,
//                                                                             ),
//                                                                             data[index].paidStatus.toString() == "1"
//                                                                                 ? Text(
//                                                                                     "Curent Due: Rs. " + data[index].currentDue.toString(),
//                                                                                     style: TextStyle(fontSize: 10, color: Color(0xff43567B)),
//                                                                                   )
//                                                                                 : Container(),
//                                                                           ],
//                                                                         ),
//                                                                         data[index].paidStatus.toString() ==
//                                                                                 "1"
//                                                                             ? InkWell(
//                                                                                 onTap: () async {
//                                                                                   await showDialog(
//                                                                                       context: context,
//                                                                                       builder: (context) {
//                                                                                         return StatefulBuilder(builder: (context, setState) {
//                                                                                           return AlertDialog(
//                                                                                             contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
//                                                                                             insetPadding: EdgeInsets.symmetric(horizontal: 15),
//                                                                                             //clipBehavior: Clip.antiAliasWithSaveLayer,
//                                                                                             title: Row(
//                                                                                               children: [
//                                                                                                 Icon(
//                                                                                                   Icons.library_books,
//                                                                                                   color: Color(0xff40BDEB),
//                                                                                                 ),
//                                                                                                 Text(
//                                                                                                   "Update Payment Status",
//                                                                                                   style: TextStyle(fontSize: 15, color: Color(0xff085272), fontWeight: FontWeight.w500),
//                                                                                                 ),
//                                                                                               ],
//                                                                                             ),
//                                                                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
//                                                                                             content: SingleChildScrollView(
//                                                                                               child: Column(
//                                                                                                 children: [
//                                                                                                   Padding(
//                                                                                                     padding: const EdgeInsets.all(8.0),
//                                                                                                     child: Row(
//                                                                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                                                                       children: [
//                                                                                                         Text(
//                                                                                                           "Name : ",
//                                                                                                           style: TextStyle(fontSize: 14, color: Color(0xff085272)),
//                                                                                                         ),
//                                                                                                         SizedBox(
//                                                                                                           width: 8,
//                                                                                                         ),
//                                                                                                         Text(
//                                                                                                           data[index].name.toString(),
//                                                                                                           style: TextStyle(fontSize: 14, color: Color(0xff085272)),
//                                                                                                         ),
//                                                                                                       ],
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   SizedBox(
//                                                                                                     height: 10,
//                                                                                                   ),
//                                                                                                   Container(
//                                                                                                     width: MediaQuery.of(context).size.width * 0.95,
//                                                                                                     child: Row(
//                                                                                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                                                                       children: [
//                                                                                                         SizedBox(
//                                                                                                           height: 32,
//                                                                                                           width: 32,
//                                                                                                           child: Radio(
//                                                                                                             value: 1,
//                                                                                                             activeColor: Color(0xff48719A),
//                                                                                                             groupValue: Car,
//                                                                                                             onChanged: (value) {
//                                                                                                               setState(() {
//                                                                                                                 Car = value! as int?;
//                                                                                                                 isChecked = true;
//                                                                                                                 if (Car == 1) {
//                                                                                                                   setState(() {
//                                                                                                                     payment_type = "0";
//                                                                                                                   });
//                                                                                                                 }
//                                                                                                               });
//                                                                                                             },
//                                                                                                           ),
//                                                                                                         ),
//                                                                                                         // SizedBox(width: 3,),
//                                                                                                         Text('Partial Payment Collected.', style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500)),
//                                                                                                         //  SizedBox(width:3,),
//                                                                                                         SizedBox(
//                                                                                                           height: 30,
//                                                                                                           width: 30,
//                                                                                                           child: Radio(
//                                                                                                             value: 2,
//                                                                                                             activeColor: Color(0xff48719A),
//                                                                                                             groupValue: Car,
//                                                                                                             onChanged: (value) {
//                                                                                                               setState(() {
//                                                                                                                 Car = value! as int?;
//                                                                                                                 isChecked = false;
//                                                                                                                 if (Car == 2) {
//                                                                                                                   setState(() {
//                                                                                                                     payment_type = "1";
//                                                                                                                   });
//                                                                                                                 }
//                                                                                                               });
//                                                                                                             },
//                                                                                                           ),
//                                                                                                         ),
//                                                                                                         // SizedBox(width: 5,),
//                                                                                                         Text('Full Payment Collected.', style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500)),
//                                                                                                       ],
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   SizedBox(
//                                                                                                     height: 10,
//                                                                                                   ),
//                                                                                                   Visibility(
//                                                                                                     visible: isChecked,
//                                                                                                     child: Padding(
//                                                                                                       padding: const EdgeInsets.all(8.0),
//                                                                                                       child: Row(
//                                                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                                                         children: [
//                                                                                                           Container(
//                                                                                                             width: MediaQuery.of(context).size.width / 2.4,
//                                                                                                             child: TextFormField(
//                                                                                                               controller: payment,
//                                                                                                               keyboardType: TextInputType.number,
//                                                                                                               decoration: InputDecoration(
//                                                                                                                 contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
//                                                                                                                 fillColor: Colors.white,
//                                                                                                                 filled: true,
//                                                                                                                 hintText: "Payment Collected",
//                                                                                                                 hintStyle: TextStyle(
//                                                                                                                   fontSize: 11,
//                                                                                                                 ),
//                                                                                                                 enabledBorder: OutlineInputBorder(
//                                                                                                                   borderSide: BorderSide(width: 1, color: Colors.black45),
//                                                                                                                   borderRadius: BorderRadius.circular(10),
//                                                                                                                 ),
//                                                                                                                 focusedBorder: OutlineInputBorder(
//                                                                                                                   borderSide: BorderSide(width: 1, color: Colors.black45),
//                                                                                                                   borderRadius: BorderRadius.circular(10),
//                                                                                                                 ),
//                                                                                                                 border: InputBorder.none,
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           ),
//                                                                                                           Container(
//                                                                                                               width: MediaQuery.of(context).size.width / 2.4,
//                                                                                                               alignment: Alignment.center,
//                                                                                                               decoration: BoxDecoration(
//                                                                                                                 border: Border.all(color: Colors.black45),
//                                                                                                                 borderRadius: BorderRadius.circular(10),
//                                                                                                               ),
//                                                                                                               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                                                                                                               child: Text(
//                                                                                                                 "Payment Due:" + data[index].currentDue.toString(),
//                                                                                                                 style: TextStyle(fontSize: 11),
//                                                                                                               )),
//                                                                                                         ],
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   SizedBox(
//                                                                                                     height: 15,
//                                                                                                   ),
//                                                                                                   Padding(
//                                                                                                     padding: const EdgeInsets.all(8.0),
//                                                                                                     child: Card(
//                                                                                                       elevation: 3,
//                                                                                                       shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
//                                                                                                       child: Container(
//                                                                                                         alignment: Alignment.center,
//                                                                                                         height: 45,
//                                                                                                         decoration: BoxDecoration(
//                                                                                                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                                                                                                           color: Color(0xff65AC2B),
//                                                                                                         ),
//                                                                                                         child: MaterialButton(
//                                                                                                             height: 45,
//                                                                                                             minWidth: MediaQuery.of(context).size.width,
//                                                                                                             highlightColor: Colors.redAccent,
//                                                                                                             onPressed: () async {
//                                                                                                               if (payment.text.isNotEmpty) {
//                                                                                                                 var dio = Dio();
//                                                                                                                 var formData = FormData.fromMap({
//                                                                                                                   'bill_id': data[index].billId.toString(),
//                                                                                                                   'due_amount': payment.text.toString(),
//                                                                                                                   'payment_type': payment_type,
//                                                                                                                 });
//                                                                                                                 var response = await dio.post('https://doplus.creditmywallet.in.net/api/add_tubewell_bill_collection', data: formData);
//                                                                                                                 var res = response.data;
//                                                                                                                 setState(() {
//                                                                                                                   print(res.toString() + "uhkjkbhjgvghghhg");
//                                                                                                                 });
//                                                                                                                 String msg = res['status_message'];
//                                                                                                                 if (msg == "Bill Updated Successfully") {
//                                                                                                                   Fluttertoast.showToast(msg: 'Bill Updated Successfully', backgroundColor: Colors.green, gravity: ToastGravity.CENTER);
//                                                                                                                   setState(() {
//                                                                                                                     //Navigator.push(context, MaterialPageRoute(builder: (context)=>Tubewell_page()));
//                                                                                                                     payment.clear();
//                                                                                                                   });
//                                                                                                                   //Navigator.pop(context);
//                                                                                                                 } else {
//                                                                                                                   Fluttertoast.showToast(msg: msg.toString(), backgroundColor: Colors.red, gravity: ToastGravity.CENTER, textColor: Colors.white);
//                                                                                                                 }
//                                                                                                                 Navigator.pop(context);
//                                                                                                               } else {
//                                                                                                                 Fluttertoast.showToast(msg: 'Payment is Empty.', backgroundColor: Colors.red, gravity: ToastGravity.CENTER);
//                                                                                                               }
//                                                                                                             },
//                                                                                                             child: Text(
//                                                                                                               "Update",
//                                                                                                               style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
//                                                                                                             )),
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   SizedBox(
//                                                                                                     height: 15,
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               ),
//                                                                                             ),
//                                                                                           );
//                                                                                         });
//                                                                                       });
//                                                                                 },
//                                                                                 child: Container(
//                                                                                   alignment: Alignment.center,
//                                                                                   width: MediaQuery.of(context).size.width / 3.3,
//                                                                                   padding: EdgeInsets.all(8),
//                                                                                   decoration: BoxDecoration(
//                                                                                     borderRadius: BorderRadius.circular(10),
//                                                                                     color: Color(0xff40BDEB),
//                                                                                   ),
//                                                                                   child: Text(
//                                                                                     "Update Payment",
//                                                                                     style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
//                                                                                   ),
//                                                                                 ),
//                                                                               )
//                                                                             : Text(
//                                                                                 "Paid",
//                                                                                 style: TextStyle(fontSize: 12, color: Color(0xff3DBA3D), fontWeight: FontWeight.w500),
//                                                                               ),
//                                                                         data[index].paidStatus.toString() !=
//                                                                                 "1"
//                                                                             ? Text('')
//                                                                             : IconButton(
//                                                                                 onPressed: () async {
//                                                                                   setState(() {
//                                                                                     String name = data[index].name.toString();
//                                                                                     String due = data[index].currentDue.toString();
//                                                                                     String user = "user@hdfgbank&pn";
//                                                                                     Share.share('check tubewel bill\n upi://pay?pa=$user=&am=$due&cu=INR\n$name=TestingGpay\namount : $due', subject: 'Look what I made!');
//                                                                                   });
//                                                                                 },
//                                                                                 icon: Icon(Icons.share)),
//                                                                         SizedBox(
//                                                                           width:
//                                                                               5,
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }),
//                                                   );
//                                                 }
//                                               }),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                             top: -20,
//                             right: 0,
//                             left: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Card(
//                                 elevation: 8,
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   //height: MediaQuery.of(context).size.height/8,
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                                 height: 45,
//                                                 width: 45,
//                                                 margin: EdgeInsets.all(10),
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       "assets/tubewell.png"),
//                                                   height: 35,
//                                                 )),
//                                             Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   1.88,
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Welcome !! Pradeep Jha",
//                                                     style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color:
//                                                             Color(0xff085272)),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 10,
//                                                   ),
//                                                   Text(
//                                                     "You can manage, check, edit, pay and collect your Tubewell Bills",
//                                                     style: TextStyle(
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color:
//                                                             Color(0xff085272)),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             Spacer(),
//                                             Icon(
//                                               Icons.calendar_month,
//                                               size: 30,
//                                               color: Colors.red,
//                                             )
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ))
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 70,
//         margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.green,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             currentIndex: _currentIndex,
//             backgroundColor: Color(0xff40bdec),
//             selectedItemColor: Colors.black87,
//             unselectedItemColor: Colors.white.withOpacity(.90),
//             selectedFontSize: 14,
//             unselectedFontSize: 14,
//             onTap: (value) {
//               // Respond to item press.
//               setState(() => _currentIndex = value);
//               if (_currentIndex == 0) {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Home_page()));
//               } else if (_currentIndex == 1) {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => crop_health()));
//               } else if (_currentIndex == 2) {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Show_me_plan()));
//               } else if (_currentIndex == 3) {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Crop_Advisory()));
//               }
//             },
//             items: [
//               BottomNavigationBarItem(
//                 label: "home".tr,
//                 icon: Icon(
//                   CupertinoIcons.house_fill,
//                   size: 25,
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 label: "crop_doctor".tr,
//                 icon: Icon(
//                   Icons.local_hospital,
//                   size: 25,
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 label: "crop_plans".tr,
//                 icon: Icon(
//                   CupertinoIcons.crop_rotate,
//                   size: 25,
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 label: "crop_advisory".tr,
//                 icon: Icon(
//                   CupertinoIcons.question_diamond,
//                   size: 25,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       );
//   }
// }
