import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/adminModel.dart';
import 'package:redbus_admin/settingsScreens/addAdmin.dart';
import 'package:redbus_admin/settingsScreens/updateAdmin.dart';
import 'package:redbus_admin/settingsScreens/updateDrivers.dart';
import 'package:toast/toast.dart';

import '../model/driverModel.dart';
import 'addDriver.dart';

class Drivers extends StatefulWidget {
  const Drivers({Key? key}) : super(key: key);

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  DatabaseConnection databaseConnection = DatabaseConnection();
  List<DriverModel> driverList = [];
  List<String> driverIds = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getDriverDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDriverDetails() async {
    try {
      QuerySnapshot querySnapshot = await databaseConnection.getAllDrivers();
      if (mounted) {
        List<DriverModel> tempList = [];
        List<String> tempIds = [];

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
          var dm = DriverModel();
          dm.driverName = map['driverName'];
          dm.driverPhone = map['driverPhone'];
          dm.driverDob = map['driverDob'];
          dm.driverAddress = map['driverAddress'];
          dm.driverAge = map['driverAge'];
          dm.driverType = map['driverType'];
          dm.driverAadharNumber = map['driverAadharNumber'];
          dm.driverLicenceId = map['driverLicenseId'];
          dm.driverImg = map['driverImg'];
          tempList.add(dm);
          tempIds.add(querySnapshot.docs[i].id);
        }

        setState(() {
          driverList = tempList;
          driverIds = tempIds;
          isLoaded = true;
        });
      }
    } catch (e) {
      print("Error fetching Driver details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Drivers",
            style: TextStyle(
              fontSize: 17.0,
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
        title: const Text(
          "Drivers",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 750,
            child: driverList.isEmpty
                ? const Center(
                    child: Text(
                      "No Drivers Currently, Please add a New Driver",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                  : getDrivers(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Driver',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDrivers())).then((data) {
            if (data != null) {
              getDriverDetails();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget getDrivers() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 200) / 2;
    final double itemWidth = size.width / 2;
    return GridView.builder(
      itemCount: driverList.length,
      controller: ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 40.0,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 5,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 40.0,
                    child: Icon(Icons.person,color: Colors.blue,size: 40.0,),
                  ),
                  const SizedBox(height: 5.0,),
                  Text(
                    '${driverList[index].driverName}', style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway',
                  ),
                  ),
                  const SizedBox(height: 8.0,),
                  Text(
                    '${driverList[index].driverType}', style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontFamily: 'Raleway',
                  ),
                  ),
                  const SizedBox(height: 8.0,),
                  Text(
                    '${driverList[index].driverPhone}', style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway',
                  ),
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDrivers(driverId: driverIds[index]))).then((value){
                              if(value != null){
                                getDriverDetails();
                              }
                            });
                          },
                          icon: const Icon(Icons.edit_location_alt_outlined,color: Colors.green,size: 30.0,)
                      ),
                      const SizedBox(width: 10.0,),
                      IconButton(
                          onPressed: (){
                            deleteDriver(context, driverIds[index]);
                          },
                          icon: const Icon(Icons.delete_outline,color: Colors.red,size: 30.0,)
                      )
                    ],
                  )
                ],
              )
          ),
        );
      },
    );
  }

  deleteDriver(BuildContext context, String id){
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Do You want to Delete this Driver',
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
                    databaseConnection.deleteAdmin(id);
                    Navigator.pop(context);
                    ToastContext().init(context);
                    Toast.show(
                      'Driver Details Deleted Successfully',
                      duration: 3,
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                      ),
                      gravity: Toast.bottom,
                    );
                  },
                  child: const Text('Delete')),
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
}
