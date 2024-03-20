/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/databaseConnection.dart';

class MostPreferredRoute extends StatefulWidget {
  const MostPreferredRoute({super.key});

  @override
  State<MostPreferredRoute> createState() => _MostPreferredRouteState();
}

class _MostPreferredRouteState extends State<MostPreferredRoute> {

  Set<String> fromToList = Set<String>();
  List<String> countList = <String>[];
  List<String> months = ['','January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  String month = '';

  getMonth(){
    setState(() {
      month = '${months[DateTime.now().month]},${DateTime.now().year}';
    });
  }

  DatabaseConnection databaseConnection = DatabaseConnection();

  getFromTo() async{
    getMonth();
    QuerySnapshot querySnapshot = await databaseConnection.getBusFromTo(month);
    // print(querySnapshot);
    for(int i = 0;i < querySnapshot.docs.length;i++){
      setState(() {
        Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String,dynamic>;
        String from = map['from'];
        String to = map['to'];
        fromToList.add('$from-$to');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFromTo();
    getSpecificRoute();
  }

  getSpecificRoute() async{
    print('Check 1');
    print('L Before : ${fromToList.length}');
    getFromTo();
    print('L After : ${fromToList.length}');
    for(int i = 0;i < fromToList.length;i++){
      print('Check 2');
      setState(() async {
        String from = fromToList.elementAt(i).split('-')[0];
        String to = fromToList.elementAt(i).split('-')[1];
        print('$from $to');
        QuerySnapshot querySnapshot = await databaseConnection.getSpecificRouteCount(month, from, to);

        for(int j = 0;j < querySnapshot.docs.length;j++){
          String busId = querySnapshot.docs[j].id!;
          Map<String,dynamic> map2 = querySnapshot.docs[j].data() as Map<String,dynamic>;
          int ticketPrice = map2['price'];
          QuerySnapshot querySnapshot2 = await databaseConnection.getSpecificBusConfirmedCount(busId);
          QuerySnapshot querySnapshot3 = await databaseConnection.getSpecificBusCancelledCount(busId);
          countList.add('$from,$to,${querySnapshot2.docs.length},${querySnapshot3.docs.length}, $ticketPrice');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('From to List : ${fromToList.toString()}');
    print('Count List : ${countList.toString()}');
    // getFromTo();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Preferred Route",style:
        TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/databaseConnection.dart';

class RouteDetails {
  final String from;
  final String to;
  final int totalTravellers;
  final int cancelledTickets;
  final int ticketPrice;
  final String busName;

  RouteDetails(this.from, this.to, this.totalTravellers, this.cancelledTickets, this.ticketPrice, this.busName);
}

class MostPreferredRoute extends StatefulWidget {
  final String from;
  final String to;
  final String month;
  const MostPreferredRoute({Key? key, required this.from, required this.to, required this.month}) : super(key: key);

  @override
  State<MostPreferredRoute> createState() => _MostPreferredRouteState();
}

class _MostPreferredRouteState extends State<MostPreferredRoute> {
  Set<String> fromToList = Set<String>();
  List<RouteDetails> countList = <RouteDetails>[];
  List<String> months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  bool dataLoaded = false;

  DatabaseConnection databaseConnection = DatabaseConnection();

  @override
  void initState() {
    super.initState();
    getSpecificRoute();
  }

  int ttlTravellers = 0,cancelledTic = 0,profit = 0,loss = 0;

  Future<void> getSpecificRoute() async {
    List<RouteDetails> tempCountList = [];
    String from = widget.from;
    String to = widget.to;
    QuerySnapshot querySnapshot = await databaseConnection.getSpecificRouteCount(widget.month, from, to);
    for (int j = 0; j < querySnapshot.docs.length; j++) {
      String busId = querySnapshot.docs[j].id!;
      Map<String, dynamic> map2 = querySnapshot.docs[j].data() as Map<String, dynamic>;
      int ticketPrice = map2['price'];
      String busName = map2['busName'];
      QuerySnapshot querySnapshot2 = await databaseConnection.getSpecificBusConfirmedCount(busId);
      QuerySnapshot querySnapshot3 = await databaseConnection.getSpecificBusCancelledCount(busId);
      int totalTravellers = querySnapshot2.docs.length;
      ttlTravellers += totalTravellers;
      int cancelledTickets = querySnapshot3.docs.length;
      cancelledTic += cancelledTickets;
      tempCountList.add(RouteDetails(from, to, totalTravellers, cancelledTickets, ticketPrice, busName));
      profit = (ttlTravellers * ticketPrice);
      loss = (cancelledTic * ticketPrice);
    }
    setState(() {
      countList = tempCountList;
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!dataLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Most Preferred Route",
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

    else if (dataLoaded && countList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Most Preferred Route",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
            ),
          ),
        ),
        body: Center(
          child: Container(
            height: 350,
            width: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/nodatafound.jpg',
                  ),
                  fit: BoxFit.fitHeight
              )
            ),
            child: const Text(
              "No Data Found on this Search",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.pink,
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
        title: const Text(
          "Most Preferred Routes",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 600,
              margin: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: countList.length,
                itemBuilder: (context, index) {
                  RouteDetails routeDetails = countList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    elevation: 5.0,
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('From : ${routeDetails.from}', style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                              )),
                              const SizedBox(width: 15.0),
                              Text('To : ${routeDetails.to}', style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(routeDetails.busName, style: const TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                              )),
                              const SizedBox(width: 15.0),
                              Text('Price : ${routeDetails.ticketPrice}', style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.greenAccent,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Total Travellers', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      const SizedBox(width: 15.0),
                                      Text('${routeDetails.totalTravellers}', style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0,),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 3.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('Cancelled Tickets', style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                    )),
                                    const SizedBox(width: 15.0),
                                    Text('${routeDetails.cancelledTickets}', style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.greenAccent,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Profit', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      const SizedBox(width: 15.0),
                                      Text('₹ ${(routeDetails.totalTravellers * routeDetails.ticketPrice)}', style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0,),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text('Loss', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                      )),
                                      const SizedBox(width: 15.0),
                                      Text('₹ ${(routeDetails.cancelledTickets * routeDetails.ticketPrice)}', style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Travellers : ', style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(width: 10.0,),
                Text('$ttlTravellers', style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Cancelled Tickets : ', style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(width: 10.0,),
                Text('$cancelledTic', style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Profit : ', style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(width: 10.0,),
                Text('₹ $profit', style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Loss : ', style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(width: 10.0,),
                Text('₹ $loss', style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        )
      ],
    );
  }
}
