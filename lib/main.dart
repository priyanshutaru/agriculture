import 'dart:async';
import 'package:agriculture/language_file/LacaleString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_Screen/Basic_screen/Login_Page.dart';
import 'all_Screen/all_home_screen/Home_Page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: Locale('hi', 'IN'),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getLocale() {
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Timer(Duration(milliseconds: 2000), () async {
        final pref = await SharedPreferences.getInstance();
        var user_id = pref.getString('user_id');
        if (user_id != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home_page()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login_page()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Text(""),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/splash.png",
                    height: 180,
                    width: 180,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Text(
                  //   "SHASY MITRA",
                  //   style: TextStyle(
                  //     fontSize: 17,
                  //     fontWeight: FontWeight.w900,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  Text(
                    'हमारी पहचान खुशहाल किसान',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.lightBlueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                children: [
                  Image(image: AssetImage("assets/image-splash.png")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
