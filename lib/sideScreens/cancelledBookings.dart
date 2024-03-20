import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/databaseConnection.dart';

class CancelledBookings extends StatefulWidget {
  String? busId;
  CancelledBookings({Key? key, required this.busId}) : super(key: key);

  @override
  State<CancelledBookings> createState() => _CancelledBookingsState();
}

class _CancelledBookingsState extends State<CancelledBookings> {
  DatabaseConnection databaseConnection = DatabaseConnection();
  List<String> seatsList = <String>[];

  emptyBookings(){
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('images/emptyBookings.png'),fit: BoxFit.fitWidth,),
          SizedBox(
            height: 10.0,
          ),
          Text('No Bookings Found on This Bus', style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
          ),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cancelled Bookings",style:
        TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 750,
              margin: const EdgeInsets.all(10.0),
              // padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: FutureBuilder(
                future: databaseConnection.getCancelledBookings(widget.busId!),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  else {
                    List<QueryDocumentSnapshot> bookings = snapshot.data!.docs;
                    // print(bookings.length);

                    return bookings.isEmpty ? emptyBookings() : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> bookingData = bookings[index].data() as Map<String, dynamic>;

                        String details = bookingData['passengerDetails'].toString();

                        String boarding = bookingData['boarding'].toString().trim();
                        String dropping = bookingData['dropping'].toString().trim();
                        String boardingTime = bookingData['startTime'].toString();
                        String bookedDate = bookingData['bookedDate'].toString();
                        String seatNo = details.split(",")[0].replaceAll(RegExp(r'[^0-9]'), '');
                        String name = details.split(",")[1].split(':')[1];

                        // print('$seatNo, $name, $boarding, $dropping, $boardingTime, $bookedDate');

                        return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.blue,
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Seat No : $seatNo',style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Raleway',
                                      ),),
                                      Text('Passenger Name : $name',style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.5,
                                        fontFamily: 'Raleway',
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('$boarding - $dropping',style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Raleway',
                                      ),),
                                      Text(boardingTime,style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontFamily: 'Raleway',
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text('Booked Date : $bookedDate',style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.0,
                                    fontFamily: 'Raleway',
                                  ),),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                ],
                              )
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
