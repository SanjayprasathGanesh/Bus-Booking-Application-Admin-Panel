import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/rentBusModel.dart';
import 'package:url_launcher/url_launcher.dart';

class RentBus extends StatefulWidget {
  const RentBus({super.key});

  @override
  State<RentBus> createState() => _RentBusState();
}

class _RentBusState extends State<RentBus> {

  DatabaseConnection databaseConnection = DatabaseConnection();
  List<RentBusModel> rentList = <RentBusModel>[];
  List<String> rentIds = <String>[];
  bool isLoaded = false;

  Future<void> getAllReq() async {
    try {
      QuerySnapshot querySnapshot = await databaseConnection.getAllRent();
      if (mounted) {
        List<RentBusModel> tempList = [];
        List<String> tempIds = [];

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
          var rm = RentBusModel();
          rm.phone = map['phone'];
          rm.uEmail = map['uEmail'];
          rm.from = map['from'];
          rm.to = map['to'];
          rm.busType = map['busType'];
          rm.fromDate = map['fromDate'];
          rm.toDate = map['toDate'];
          rm.ttlDays = map['ttlDays'];
          rm.reqDriver = map['reqDriver'];
          rm.isAssigned = map['isAssigned'];
          tempList.add(rm);
          tempIds.add(querySnapshot.docs[i].id);
        }

        setState(() {
          rentList = tempList;
          rentIds = tempIds;
          isLoaded = true;
        });
      }
    } catch (e) {
      print("Error fetching Driver details: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllReq();
  }

  Future<void> openMailApp(String recipientEmail) async {
    final String emailUri = 'mailto:$recipientEmail';
    try {
      await launch(emailUri);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to open the email app.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> requestSmsPermission() async {
    var status = await Permission.sms.status;

    if (status.isProvisional || status.isDenied) {
      var result = await [Permission.sms].request();

      if (result[Permission.sms] == PermissionStatus.granted) {
        print('SMS permission granted');
        return true;
      } else if (result[Permission.sms] == PermissionStatus.denied) {
        print('SMS permission denied');
        // Handle the case where the user denies the permission.
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      print('SMS permission permanently denied');
      // Handle the case where the user permanently denies the permission.
      return false;
    }

    // If the permission is already granted, return true
    return true;
  }

  Future<void> sendSms( String phone) async {
    bool hasSmsPermission = await requestSmsPermission();

    if (hasSmsPermission) {
      final _text = 'sms:$phone';
      if (await canLaunch(_text)) {
        await launch(_text);
      }
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('SMS permission is required to send messages.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Exit'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> requestPhoneCallPermission() async {
    var status = await Permission.phone.status;

    if (status.isProvisional || status.isDenied) {
      var result = await [Permission.phone].request();

      if (result[Permission.phone] == PermissionStatus.granted) {
        print('Phone call permission granted');
        return true;
      } else if (result[Permission.phone] == PermissionStatus.denied) {
        print('Phone call permission denied');
        // Handle the case where the user denies the permission.
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      print('Phone call permission permanently denied');
      // Handle the case where the user permanently denies the permission.
      return false;
    }

    // If the permission is already granted, return true
    return true;
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    bool hasPhoneCallPermission = await requestPhoneCallPermission();

    if (hasPhoneCallPermission) {
      final _phoneCallUri = 'tel:$phoneNumber';
      if (await canLaunch(_phoneCallUri)) {
        await launch(_phoneCallUri);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Phone call permission is required to make calls.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Exit'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Rent Bus",
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

    if (isLoaded && rentList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Rent Bus",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
            ),
          ),
        ),
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/nodatafound.jpg'),
                  fit: BoxFit.fitHeight,
                )
            ),
            child: const Text(
              "No Forms Found",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Bus", style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 700,
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: rentList.length,
              itemBuilder: (context, index){
                bool isChecked = rentList[index].isAssigned!;
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${rentList[index].from} - ${rentList[index].to}", style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Raleway',
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            rentList[index].isAssigned! ?
                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  isChecked = !isChecked;
                                  rentList[index].isAssigned = isChecked;
                                });
                                await databaseConnection.updateBusRentReply(rentIds[index], isChecked);

                              },
                              icon: isChecked ? const Icon(Icons.check_circle_outline,color: Colors.green,size: 30.0,) :
                              const Icon(Icons.circle_outlined,color: Colors.green,size: 30.0,),
                            )
                                :
                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  isChecked = !isChecked; // Toggle the checked state
                                  rentList[index].isAssigned = isChecked;
                                });
                                await databaseConnection.updateBusRentReply(rentIds[index], isChecked);
                              },
                              icon: isChecked ? const Icon(Icons.check_circle_outline,color: Colors.green,size: 30.0,) :
                              const Icon(Icons.circle_outlined,color: Colors.green,size: 30.0,),
                            )
                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${rentList[index].fromDate} - ${rentList[index].toDate}", style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                            ),
                            ),
                            const SizedBox(width: 10.0,),
                            Text("Total Days : ${rentList[index].ttlDays}", style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                            ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${rentList[index].busType}", style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                            ),
                            ),
                            const SizedBox(width: 10.0,),
                            Text("${rentList[index].reqDriver}", style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Raleway',
                            ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        const Divider(
                          height: 3.0,
                          thickness: 2.0,
                        ),
                        const SizedBox(height: 3.0,),
                        const Center(
                          child: Text("User Details", style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                            ),
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        Text("Phone Number : ${rentList[index].phone}", style: const TextStyle(
                          fontSize: 15,
                            fontFamily: 'Raleway',
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        Text("Email Id : ${rentList[index].uEmail}", style: const TextStyle(
                          fontSize: 14,
                            fontFamily: 'Raleway',
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        const Divider(
                          height: 3.0,
                          thickness: 2.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () async{
                                  openMailApp(rentList[index].uEmail!);
                                },
                                icon: const Icon(Icons.send_rounded,color: Colors.blue,)
                            ),
                            IconButton(
                                onPressed: () async{
                                  makePhoneCall(rentList[index].phone!);
                                },
                                icon: const Icon(Icons.phone,color: Colors.green,)
                            ),
                            IconButton(
                                onPressed: () async{
                                  sendSms(rentList[index].phone!);
                                },
                                icon: const Icon(Icons.messenger_outline,color: Colors.orange,)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      )
    );
  }
}
