import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:redbus_admin/analytics/mostPreferredRoute.dart';
import 'package:redbus_admin/database/databaseConnection.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {

  final List<BusRoute> busRoutes = [
    BusRoute(
        fromCity: 'Coimbatore',
        toCity: 'Tenkasi',
        image: 'images/tenkasi.jpg'
    ),
    BusRoute(
        fromCity: 'Coimbatore',
        toCity: 'Chennai',
        image: 'images/chennai.jpg'
    ),
    BusRoute(
        fromCity: 'Coimbatore',
        toCity: 'Bangalore',
        image: 'images/bangalore.jpg'
    ),
    BusRoute(
        fromCity: 'Coimbatore',
        toCity: 'Tirunelveli',
        image: 'images/tirunelveli.jpg'
    ),
    BusRoute(
        fromCity: 'Coimbatore',
        toCity: 'Kochi',
        image: 'images/kochi.jpg'
    ),
    BusRoute(
        fromCity: 'Chennai',
        toCity: 'Tirunelveli',
        image: 'images/tirunelveli.jpg'
    ),
    BusRoute(
        fromCity: 'Chennai',
        toCity: 'Tenkasi',
        image: 'images/tenkasi.jpg'
    ),
    BusRoute(
        fromCity: 'Chennai',
        toCity: 'Coimbatore',
        image: 'images/coimbatore.jpg'
    ),
    BusRoute(
        fromCity: 'Bangalore',
        toCity: 'Coimbatore',
        image: 'images/coimbatore.jpg'
    ),
  ];

  DatabaseConnection databaseConnection = DatabaseConnection();
  List<RouteDetails> countList = <RouteDetails>[];
  List<String> months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];
  String month = '';
  bool dataLoaded = false;

  // getMonth() {
  //   setState(() {
  //     month = '${months[DateTime.now().month]},${DateTime.now().year}';
  //   });
  // }

  Future<void> getSpecificRoute() async {
    // getMonth();
    List<RouteDetails> tempCountList = [];

    for (int i = 0; i < busRoutes.length; i++) {
      String from = busRoutes[i].fromCity;
      String to = busRoutes[i].toCity;

      QuerySnapshot querySnapshot = await databaseConnection.getSpecificRouteCount(month, from, to);
      int totalTrips = querySnapshot.docs.length;
      int totalTravelers = 0;

      for (int j = 0; j < querySnapshot.docs.length; j++) {
        String busId = querySnapshot.docs[j].id!;
        QuerySnapshot querySnapshot2 = await databaseConnection.getSpecificBusConfirmedCount(busId);
        totalTravelers += querySnapshot2.docs.length;
      }

      tempCountList.add(RouteDetails(totalTravelers, totalTrips, from, to));
    }

    setState(() {
      countList = tempCountList;
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      getSpecificRoute();
    });
    month = '${months.elementAt(DateTime.now().month)},${DateTime.now().year}';
  }


  @override
  Widget build(BuildContext context) {
    if (!dataLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Text('$month Month Trip Analysis', style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 10.0),
            Container(
              height: 630,
              width: double.infinity,
              child: ListView.builder(
                itemCount: busRoutes.length,
                itemBuilder: (context, index) {
                  RouteDetails routeDetails = countList[index];
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MostPreferredRoute(from: routeDetails.from, to: routeDetails.to, month: month,)));
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                busRoutes[index].image,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text('${busRoutes[index].fromCity} - ${busRoutes[index].toCity}',style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                              ),),
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
                                          const Text('Total Trips', style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          const SizedBox(width: 15.0),
                                          Text('${routeDetails.totalTrips}', style: const TextStyle(
                                            color: Colors.black,
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
                                          const Text('Total Travellers', style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          const SizedBox(width: 15.0),
                                          Text('${routeDetails.totalTravellers}', style: const TextStyle(
                                            color: Colors.black,
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
                      ),
                    ),
                  );
                },
              ),
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
              dataLoaded = false;
            });
            // Fetch buses for the selected month
            getSpecificRoute();
          }
        },
        child: const Icon(Icons.filter_alt,),
      ),
    );
  }
}

class RouteDetails {
  final int totalTravellers;
  final int totalTrips;
  final String from;
  final String to;

  RouteDetails(this.totalTravellers, this.totalTrips, this.from, this.to);
}

class BusRoute {
  final String fromCity;
  final String toCity;
  final String image;

  BusRoute({
    required this.fromCity,
    required this.toCity,
    required this.image,
  });
}
