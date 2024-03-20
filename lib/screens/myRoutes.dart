import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/sideScreens/specificRoute.dart';

class MyRoutes extends StatefulWidget {
  const MyRoutes({super.key});

  @override
  State<MyRoutes> createState() => _MyRoutesState();
}

class _MyRoutesState extends State<MyRoutes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(5.0),
              height: 800,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('bus').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'Raleway',
                          fontSize: 18.0,
                        ),
                      ),
                    );
                  } else {
                    List<DocumentSnapshot> list = snapshot.data!.docs;

                    // Use a set to keep track of unique combinations of "from" and "to"
                    Set<String> uniqueFromToCombinations = Set();

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic>? bus = list[index].data() as Map<String, dynamic>?;
                        String fromToCombination = "${bus?['from']}-${bus?['to']}";

                        // Check if the combination of "from" and "to" is unique, if not, skip rendering
                        if (!uniqueFromToCombinations.contains(fromToCombination)) {
                          uniqueFromToCombinations.add(fromToCombination);

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${bus?['from']} - ${bus?['to']}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      fontFamily: 'Raleway',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "Routes : ${bus?['routes']}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: 'Raleway',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "Type : ${bus?['type']}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: 'Raleway',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SpecificRoutes(from: bus?['from'],to: bus?['to'])));
                              },
                            ),
                          );
                        }
                        else {
                          // Skip rendering for duplicate combinations of "from" and "to"
                          return Container();
                        }
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
