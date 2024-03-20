import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/login/adminLogin.dart';
import 'package:redbus_admin/screens/analytics.dart';
import 'package:redbus_admin/screens/home.dart';
import 'package:redbus_admin/screens/myRoutes.dart';
import 'package:redbus_admin/screens/settings.dart';
import 'package:redbus_admin/sideScreens/addBusImg.dart';
import 'package:redbus_admin/login/phone.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyALqi9ygYrlHxF8_pyGHAU3G0cmuPYTins',
        appId: '1:1008560729657:android:a364e68bfdb10372ef27e8',
        messagingSenderId: '1008560729657',
        projectId: 'redbus-19c55',
        // storageBucket: 'gs://redbus-19c55.appspot.com'
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'DreamLiner Travels Admin',
      home: AdminLogin(),
      // home: RedbusAdmin(name: 'Sanjay Prasath', phone: '9360227091'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RedbusAdmin extends StatefulWidget {
  String name;
  String phone;
  RedbusAdmin({Key? key, required this.name, required this.phone}) : super(key: key);

  @override
  State<RedbusAdmin> createState() => _RedbusAdminState();
}

class _RedbusAdminState extends State<RedbusAdmin> {
  int index = 0;

  List<Widget> get pages => [
    Home(name: widget.name, phone: widget.phone,),
    const MyRoutes(),
    const Analytics(),
    Settings(name: widget.name, phone: widget.phone,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redbus Admin",style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: pages[index],
      bottomNavigationBar: showBottomBar(),
      drawer: Drawer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: UserAccountsDrawerHeader(
                      currentAccountPicture: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(Icons.person_sharp,color: Colors.black,size: 35.0,),
                      ),
                      accountName: Text(widget.name,style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gabarito',
                        fontSize: 17.0,
                        letterSpacing: 1
                      ),),
                      accountEmail: Text(widget.phone,style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gabarito',
                        letterSpacing: 1.5,
                        fontSize: 15.0,
                      ),),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined,color: Colors.blue,size: 30.0,),
                  title: const Text('Add Bus Images',style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),),
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> AddBusImage()));
                    pageAlert();
                  },
                ),
                const Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
                ListTile(
                  leading: const Icon(Icons.message_outlined,color: Colors.blue,size: 30.0,),
                  title: const Text('Send Notification',style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),),
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const SendNotification()));
                    pageAlert();
                  },
                ),
                const Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
                ListTile(
                  leading: const Icon(Icons.mail_outline_sharp,color: Colors.blue,size: 30.0,),
                  title: const Text('Send E-Mails',style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway',
                    fontSize: 15.0,
                  ),),
                  onTap: (){
                    pageAlert();
                  },
                ),
                const Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                color: Colors.blueGrey,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout_rounded,color: Colors.red,size: 30.0,),
                      title: const Text('Logout',style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600
                      ),),
                      onTap: (){
                        logout(context);
                      },
                    ),
                    const Divider(
                      height: 2.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFcaf0f8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.all(5.0),
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    index = 0;
                  });
                },
                icon: Icon(Icons.home_outlined,color: index != 0 ? Colors.black : Colors.blue,),
                iconSize: 25.0,
              ),
              Text("Home",style: TextStyle(
                color: index == 0 ? Colors.blue : Colors.black,
                fontSize: 11.0,
                fontFamily: 'Raleway',
              ),)
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      index = 1;
                    });
                  },
                  icon: Icon(Icons.alt_route,color: index != 1 ? Colors.black : Colors.blue,)
              ),
              Text("My Routes",style: TextStyle(
                color: index == 1 ? Colors.blue : Colors.black,
                fontSize: 11.0,
                fontFamily: 'Raleway',
              ),)
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      index = 2;
                    });
                  },
                  icon: Icon(Icons.analytics_outlined,color: index != 2 ? Colors.black : Colors.blue,)
              ),
              Text("Analytics",style: TextStyle(
                color: index == 2 ? Colors.blue : Colors.black,
                fontSize: 11.0,
                fontFamily: 'Raleway',
              ),)
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      index = 3;
                    });
                  },
                  icon: Icon(Icons.settings,color: index != 3 ? Colors.black : Colors.blue,)
              ),
              Text("Settings",style: TextStyle(
                color: index == 3 ? Colors.blue : Colors.black,
                fontSize: 11.0,
                fontFamily: 'Raleway',
              ),)
            ],
          )
        ],
      ),
    );
  }

  logout(BuildContext context){
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Do You want to Logout from this Account',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(

                      backgroundColor: Colors.red),
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AdminLogin()),
                          (route) => false,
                    );
                  },
                  child: const Text('Logout')),
              TextButton(
                  style: TextButton.styleFrom(

                      backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        }
    );
  }

  pageAlert(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Page Under Construction',style: TextStyle(
            fontFamily: 'Raleway',
          ),),
          content: const Text('This Page is not developed completely, once the development gets finished, it will be deployed soon...',style: TextStyle(
            fontFamily: 'Raleway',
          ),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
