import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/loginActModel.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {

  List<LoginActivityModel> loginList = <LoginActivityModel>[];
  bool isLoaded = false;
  DatabaseConnection databaseConnection = DatabaseConnection();

  getAllLogins() async{
    QuerySnapshot querySnapshot = await databaseConnection.getLoginActivity();
    List<LoginActivityModel> tempList = <LoginActivityModel>[];
    for(int i = 0;i < querySnapshot.size;i++){
      Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
      var l = LoginActivityModel();
      l.adminName = map['adminName'];
      l.adminPhone = map['adminPhone'];
      l.date = map['date'];
      l.time = map['time'];
      tempList.add(l);
    }

    setState(() {
      loginList = tempList;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllLogins();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login Activity",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Activity",style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: Container(
        height: 800,
        child: ListView.builder(
            itemCount: loginList.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return ListTile(
                title: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Date on the left
                          Text(
                            loginList[index].date!,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Raleway',
                            ),
                          ),
                          SizedBox(width: 10.0),
                          // Vertical line with icon
                          // const VerticalDivider(
                          //   thickness: 2.0,
                          //   color: Colors.grey,
                          // ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 2.0,
                                height: double.infinity,
                                color: Colors.grey,
                              ),
                              Icon(
                                Icons.circle,
                                size: 20,
                                color: _getCircleColor(index),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10.0),
                          // Card holding name and time
                          Expanded(
                            child: Card(
                              child: ListTile(
                                title: Text(loginList[index].adminName!,style: const TextStyle(
                                  fontFamily: 'Raleway'
                                ),),
                                subtitle: Text(loginList[index].time!,style: const TextStyle(
                                    fontFamily: 'Raleway'
                                ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  Color _getCircleColor(int index) {
    // Define your own logic to get different colors for circle icons
    // Example: Return different colors based on index or any other condition
    // Here's a simple example:
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red];
    return colors[index % colors.length];
  }
}
