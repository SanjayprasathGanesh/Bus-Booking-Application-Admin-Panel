import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/busModel.dart';
import 'package:redbus_admin/services/busService.dart';
import 'package:redbus_admin/sideScreens/addBus.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';


import '../sideScreens/updateBus.dart';

class Home extends StatefulWidget {
  String name;
  String phone;
  Home({Key? key, required this.name, required this.phone}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  BusService busService = BusService();
  List<BusModel> _busList = <BusModel>[];
  String? id;
  List<String> idList = <String>[];

  @override
  initState() {
    super.initState();
    getAllBuses();
  }

  getAllBuses() async{
    var bus = await busService.ReadBus(DateTime.now().toString().split(" ")[0]);
    _busList = <BusModel>[];
    if(_busList.isNotEmpty) {
      bus.forEach((b) {
        setState(() {
          var busModel = BusModel();
          busModel.busNo = b['busNo'];
          busModel.busName = b['busName'];
          busModel.ttlSeats = b['ttlSeats'];
          busModel.startDate = b['startDate'];
          busModel.startTime = b['startTime'];
          busModel.endDate = b['endDate'];
          busModel.endTime = b['endTime'];
          busModel.from = b['from'];
          busModel.to = b['to'];
          busModel.routes = b['routes'];
          busModel.boarding = b['boarding'];
          busModel.price = b['price'];
          busModel.type = b['type'];
          busModel.driverName = b['driverName'];
          busModel.driverNo = b['driverNo'];
          _busList.add(busModel);
        });
      });
    }
  }

  showBus() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bus').where('startDate', isGreaterThanOrEqualTo: DateTime.now().toString().split(" ")[0]).snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return Text('Error : ${snapshot.error}');
          }
          else{
            List<DocumentSnapshot> list = snapshot.data!.docs;
            return list.isNotEmpty ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index){
                  idList.add(list[index].id!);
                  // print(idList.toString());
                  Map<String, dynamic>? bus = list[index].data() as Map<String, dynamic>?;

                  DateTime startTime = parseTime(bus?['startTime']);
                  DateTime endTime = parseTime(bus?['endTime']);
                  if (endTime.isBefore(startTime)) {
                    endTime = endTime.add(const Duration(days: 1));
                  }

                  Duration difference = endTime.difference(startTime);
                  double differenceInHours = difference.inMinutes / 60;

                  return Container(
                    margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${bus?['startDate']} - ${bus?['endDate']}',style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                ),),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${bus?['startTime']} - ${bus?['endTime']}',style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                ),),
                                Text('From ₹${bus?['price']}',style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                ),)
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$differenceInHours hrs - ${bus?['ttlSeats']} Seats',style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Raleway',
                                  fontSize: 13.0
                                ),),
                                Text('₹${bus?['price']+200}',style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontFamily: 'Raleway',
                                  fontSize: 13.0
                                ),)
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Text('${bus?['from']} - ${bus?['to']}',style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                ),)
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${bus?['busName']}',style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0
                                ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          print('Update Id : ${idList.elementAt(index)}');
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBus(id: idList.elementAt(index))));
                                        },
                                        icon: const Icon(Icons.edit_calendar_outlined,color: Colors.green,size: 30.0,)
                                    ),
                                    IconButton(
                                        onPressed: () async{
                                          deleteBus(idList.elementAt(index));
                                        },
                                        icon: const Icon(Icons.delete_outline,color: Colors.red,size: 30.0,)
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text('${bus?['type']}',style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Raleway',
                                fontSize: 13.0
                            ),),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ) : emptyBus();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: showBus(),
      ),
      // backgroundColor: const Color(0xFFade8f4),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBus()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  DateTime parseTime(String timeStr) {
    List<String> parts = timeStr.split(':');
    return DateTime(2023, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }

  deleteBus(String? id){
    return showDialog(
        context: context,
        builder: (param){
          return AlertDialog(
            title: const Text('Do You want to delete this Bus',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                fontSize: 17.0
            ),),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: (){
                      busService.DeleteBus(id!);
                      ToastContext().init(context);
                      Toast.show(
                        'Bus Deleted Successfully',
                        duration: 3,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 14.0,
                        )
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Delete',style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontSize: 13.0
                    ),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontSize: 13.0
                  ),),
                ),
              ],
            ),
          );
        }
    );
  }

  emptyBus(){
    return Center(
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        child: const Center(
          child: Column(
            children: [
              Text('No Buses Found on Today',style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 18.0,
              ),),
              SizedBox(
                height: 10.0,
              ),
              Image(
                  image: AssetImage('images/emptyBus.jpg'),
                  fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10.0,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
