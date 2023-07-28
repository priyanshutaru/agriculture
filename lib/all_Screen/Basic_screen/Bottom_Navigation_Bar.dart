import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../all_home_screen/Home_Page.dart';
class Bottom_navigation extends StatefulWidget {
  const Bottom_navigation({Key? key}) : super(key: key);

  @override
  State<Bottom_navigation> createState() => _Bottom_navigationState();
}

class _Bottom_navigationState extends State<Bottom_navigation> {
  int _currentIndex = 0;
  // List allscreen=[
  //   Home_page(),
  //   // Payouts_page(),
  //   // Order_page(),
  //   // More_page(),
  // ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.all(10),
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
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black87.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) {
            // Respond to item press.
            setState(() => _currentIndex = value);
            if(_currentIndex==0){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Home_page()));
            }else if(_currentIndex==1){
             // Navigator.push(context, MaterialPageRoute(builder: (context)=>Contact()));
            }
            else if(_currentIndex==2){
             // Navigator.push(context, MaterialPageRoute(builder: (context)=>Track()));
            }else if(_currentIndex==3){
             // Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
            }
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(CupertinoIcons.house_fill,size: 25,),
            ),
            BottomNavigationBarItem(
              label: 'Contact',
               icon: Icon(Icons.library_books_outlined,size: 25,),
            ),
            BottomNavigationBarItem(
              label: 'Booking',
              icon: Icon(CupertinoIcons.arrow_down_doc_fill,size: 25,),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
               icon: Icon(CupertinoIcons.tray_arrow_down,size: 25,),
            ),

          ],
        ),
      ),
    );
     /* Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: Card(
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Container(
              height: 65,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                backgroundColor: Color(0xff40bdec),
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black87.withOpacity(.60),
                selectedFontSize: 16,
                unselectedFontSize: 13,
                onTap: (int index) {
                  // Respond to item press.
                  setState(() => _selectedIndex = index);
                },
                items: [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(CupertinoIcons.house_fill,size: 25,),

                  ),
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.library_books_outlined,size: 25,),
                  ),
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(CupertinoIcons.arrow_down_doc_fill,size: 25,),
                  ),
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(CupertinoIcons.tray_arrow_down,size: 25,),
                  ),

                ],
              ),
            ),
          ),
        ),
        body: allscreen[0],
      );*/
  }
}
