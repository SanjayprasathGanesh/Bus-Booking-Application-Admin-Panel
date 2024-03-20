import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/contactusModel.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsReplies extends StatefulWidget {
  const ContactUsReplies({super.key});

  @override
  State<ContactUsReplies> createState() => _ContactUsRepliesState();
}

class _ContactUsRepliesState extends State<ContactUsReplies> {
  DatabaseConnection databaseConnection = DatabaseConnection();
  List<ContactUsModel> contactList = <ContactUsModel>[];
  List<String> contactIds = <String>[];
  bool isLoaded = false;

  getAllReplies() async{
    QuerySnapshot querySnapshot = await databaseConnection.getAllContactUs();
    List<ContactUsModel> tempList = [];
    List<String> tempIds = [];
    for(int i = 0;i < querySnapshot.docs.length;i++){
      Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
      ContactUsModel contactUsModel = ContactUsModel();
      contactUsModel.uEmail = map['uEmail'];
      contactUsModel.sub = map['sub'];
      contactUsModel.content = map['content'];
      contactUsModel.email = map['email'];
      contactUsModel.day = map['day'];
      contactUsModel.date = map['date'];
      contactUsModel.isReplied = map['isReplied'];
      tempList.add(contactUsModel);
      tempIds.add(querySnapshot.docs[i].id);
    }

    setState(() {
      contactList = tempList;
      contactIds = tempIds;
      isLoaded = true;
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllReplies();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Contact Form Replies",
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

    if (isLoaded && contactList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Contact Form Replies",
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
        title: const Text("Contact us Replies",style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 700,
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index){
                bool isChecked = contactList[index].isReplied!;
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${contactList[index].date} - ${contactList[index].day}",style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Raleway'
                            ),),
                            const SizedBox(width: 10.0,),
                            contactList[index].isReplied! ?
                                IconButton(
                                  onPressed: () async{
                                    setState(() {
                                      isChecked = !isChecked;
                                      contactList[index].isReplied = isChecked;
                                    });
                                    await databaseConnection.updateContactReply(contactIds[index], isChecked);

                                  },
                                  icon: isChecked ? const Icon(Icons.check_circle_outline,color: Colors.green,size: 40.0,) :
                                        const Icon(Icons.circle_outlined,color: Colors.green,size: 30.0,),
                                )
                                :
                                IconButton(
                                  onPressed: () async{
                                    setState(() {
                                      isChecked = !isChecked; // Toggle the checked state
                                      contactList[index].isReplied = isChecked;
                                    });
                                    await databaseConnection.updateContactReply(contactIds[index], isChecked);
                                  },
                                  icon: isChecked ? const Icon(Icons.check_circle_outline,color: Colors.green,size: 40.0,) :
                                        const Icon(Icons.circle_outlined,color: Colors.green,size: 30.0,),
                                )
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Text("From User : ${contactList[index].uEmail}",style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Raleway'
                        ),),
                        const SizedBox(height: 10.0,),
                        Text("Sub : ${contactList[index].sub}",style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Raleway'
                        ),),
                        const SizedBox(height: 10.0,),
                        Text("Content : ${contactList[index].content}",style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Raleway'
                        ),
                          textAlign: TextAlign.justify,
                        ),
                        // const SizedBox(height: 10.0,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () async{
                                openMailApp(contactList[index].email!);
                              },
                              icon: const Icon(Icons.send_rounded,color: Colors.blue,)
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
