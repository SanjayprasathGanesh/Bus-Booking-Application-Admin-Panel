import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/settingsScreens/admins.dart';
import 'package:redbus_admin/settingsScreens/contactusReplies.dart';
import 'package:redbus_admin/settingsScreens/drivers.dart';
import 'package:redbus_admin/settingsScreens/loginActivity.dart';
import 'package:redbus_admin/settingsScreens/offers.dart';
import 'package:redbus_admin/settingsScreens/rentBus.dart';

class Settings extends StatefulWidget {
  String name;
  String phone;
  Settings({Key? key, required this.name, required this.phone}) : super(key: key);


  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String adType = '';
  DatabaseConnection db = DatabaseConnection();

  Set<String> operatorsSet = {};
  int driversCount = 0;

  getAdminType() async{
    String s = await db.getAdminType(widget.name, widget.phone);
    setState(() {
      if(s != 'Not Found'){
        adType = s;
      }
      else{
        adType = '';
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdminType();
    getCount();
  }

  getCount() async{
    QuerySnapshot querySnapshot = await db.getOperatorsCount();
    for(int i = 0;i < querySnapshot.size;i++){
      Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
      String busName = map['busName'];

      setState(() {
        operatorsSet.add(busName);
      });
    }

    QuerySnapshot querySnapshot2 = await db.getDriversCount();
    setState(() {
      driversCount = querySnapshot2.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF52b788),Color(0xFFb7e4c7),Color(0xFFd8f3dc)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                              ),
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Users',textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),),
                                  Text('80',style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),)
                                ],
                              ),
                            ),
                          )
                      ),
                      Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFbc6c25),Color(0xFFdda15e),Color(0xFFd4a373)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )
                              ),
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Drivers',textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),),
                                  Text('$driversCount',style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),)
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFe63946),Color(0xFFf4978e),Color(0xFFffdab9)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                      ),
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Bus Operators',textAlign: TextAlign.center,style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Raleway',
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                            maxLines: 2,
                          ),
                          Text('${operatorsSet.length}',style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),textAlign: TextAlign.center,
                            maxLines: 2,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined,color: Colors.pink,),
              title: const Text("Admins",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
              onTap: (){
                if(adType == 'Super Admin') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Admins()));
                }
                else{
                  adminAlert();
                }
              },
            ),
            const Divider(
              height: 3.0,
              thickness: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt,color: Colors.orange,),
              title: const Text("Drivers",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Drivers()));
              },
            ),
            const Divider(
              height: 3.0,
              thickness: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail_outlined,color: Colors.brown,),
              title: const Text("Contact Us Replies",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
              onTap: (){
                if(adType == 'Super Admin') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsReplies()));
                }
                else{
                  adminAlert();
                }
              },
            ),
            const Divider(
              height: 3.0,
              thickness: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.local_offer_outlined,color: Colors.teal,),
              title: const Text("Add Offers",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Offers()));
              },
            ),
            const Divider(
              height: 3.0,
              thickness: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus,color: Colors.lightGreenAccent,),
              title: const Text("Renting Bus",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RentBus()));
              },
            ),
            const Divider(
              height: 3.0,
              thickness: 2.0,
            ),
            ListTile(
              leading: const Icon(Icons.access_alarm,color: Colors.red,),
              title: const Text("Login Activity",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginActivity()));
              },
            ),
            const Divider(
              height: 3.0,
              thickness: 2.0,
            ),
          ],
        ),
      ),
    );
  }

  adminAlert(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied',style: TextStyle(
            fontFamily: 'Raleway',
          ),),
          content: const Text('Only Super Admin can able to Access this Page',style: TextStyle(
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
