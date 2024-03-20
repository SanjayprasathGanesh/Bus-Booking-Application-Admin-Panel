import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/sideScreens/busAnalytics.dart';
import 'package:redbus_admin/sideScreens/bookings.dart';
import 'package:toast/toast.dart';


class SpecificRoutes extends StatefulWidget {
  final String? from;
  final String? to;
  const SpecificRoutes({Key? key, required this.from, required this.to}): super(key: key);

  @override
  State<SpecificRoutes> createState() => _SpecificRoutesState();
}

class _SpecificRoutesState extends State<SpecificRoutes> {

  List<String> months = ['','January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  String month = '';
  
  DatabaseConnection databaseConnection = DatabaseConnection();

  @override
  initState(){
    super.initState();
    month = '${months.elementAt(DateTime.now().month)},${DateTime.now().year}';
  }

  getBuses(String m){
    return Container(
      height: 750,
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(3.0),
      child: FutureBuilder<QuerySnapshot>(
        future: databaseConnection.getSpecificBusRoute(widget.from!, widget.to!, m) ,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: Text('${snapshot.hasError}'),
            );
          }
          else if(snapshot.hasData && snapshot.data!.docs.isEmpty){
            return const Center(
              child: Image(
                image: AssetImage('images/noBus.png'),
                fit: BoxFit.fill,
                height: 250,
                width: 300,
              )
            );
          }
          else{
            List<DocumentSnapshot> list = snapshot.data!.docs;

            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index){
                  String id = list[index].id;
                  Map<String, dynamic> bus = list[index].data() as Map<String, dynamic>;

                  DateTime startTime = parseTime(bus?['startTime']);
                  DateTime endTime = parseTime(bus?['endTime']);
                  if (endTime.isBefore(startTime)) {
                    endTime = endTime.add(const Duration(days: 1));
                  }
                  Duration difference = endTime.difference(startTime);
                  double differenceInHours = difference.inMinutes / 60;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(10.0),
                                height: 40.0,
                                decoration: BoxDecoration(
                                    color: Colors.yellowAccent,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.black
                                    )
                                ),
                                child: Text("${bus?['busNo']}",style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${bus?['startDate']} - ${bus?['endDate']}',style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'Raleway',
                              ),),
                              Text('From ₹${bus?['price']}',style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'Raleway',
                              ),)
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_formatTime(bus?['startTime'])} - ${_formatTime(bus?['endTime'])}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              Text('Total Hrs : $differenceInHours',style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                fontFamily: 'Raleway',
                              ),)
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Text(bus['busName'],style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                fontFamily: 'Raleway',
                              ),)
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Text(bus['type'],style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Raleway',
                              ),)
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Bookings(busId: id)));
                                  },
                                  child: const Text("Bookings",style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                  ),)
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent,
                                  ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BusAnalytics(busId: id)));
                                  },
                                  child: const Text("Analytics",style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                  ),)
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Buses Between ${widget.from} -> ${widget.to} Routes",style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold,),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Text("$month Month Buses",style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
              child: getBuses(month),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            final selected = await showMonthPicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime(2050)
            );

            if (selected != null) {
              setState(() {
                month = '${months[selected.month]},${selected.year}';
                print(month);
              });
              // Fetch buses for the selected month
              getBuses(month);
            }
          },
          child: const Icon(Icons.filter_alt,),
      ),
    );
  }

  DateTime parseTime(String timeStr) {
    List<String> parts = timeStr.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    // Check if the hour is 0 and adjust it to 12
    if (hour == 0) {
      hour = 12;
    }
    return DateTime(DateTime.now().year, 1, 1, hour, minute);
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) {
      return ''; // Handle null case if needed
    }

    List<String> parts = timeStr.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Check if the hour is 0 and adjust it to 12
    if (hour == 0) {
      return '12:${minute.toString().padLeft(2, '0')} AM';
    } else if (hour < 12) {
      return '$hour:${minute.toString().padLeft(2, '0')} AM';
    } else if (hour == 12) {
      return '12:${minute.toString().padLeft(2, '0')} PM';
    } else {
      // Convert 24-hour format to 12-hour format for PM
      return '${(hour - 12).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} PM';
    }
  }
}

