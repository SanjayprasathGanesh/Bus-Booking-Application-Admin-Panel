import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/login/verify.dart';
import 'package:toast/toast.dart';

class MyPhone extends StatefulWidget {
  final String name;
  const MyPhone({Key? key, required this.name}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  DatabaseConnection db = DatabaseConnection();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.jpg',
                width: 280,
                height: 150,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to authenticate your phone number before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          controller: phoneNumber,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async{
                      ToastContext().init(context);

                      String adPhone = await db.getAdminPhone(widget.name);
                      if(adPhone != 'Not Found'){
                        if(adPhone == phoneNumber.text){
                          const CircularProgressIndicator();
                          await FirebaseAuth
                              .instance
                              .verifyPhoneNumber(
                              verificationCompleted: (PhoneAuthCredential credential) async{
                                try {
                                  await FirebaseAuth.instance.signInWithCredential(credential);
                                  // Navigate to the next screen or perform other actions upon successful verification
                                  print('Verification completed automatically');
                                } catch (e) {
                                  print('Error signing in automatically: $e');
                                }
                              },
                              verificationFailed: (FirebaseAuthException ex){},
                              codeSent: (String verificationId, int? resendToken){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> MyVerify(verificationId: verificationId, name: widget.name, phone: phoneNumber.text,)));
                              },
                              codeAutoRetrievalTimeout: (String verificationId){},
                              phoneNumber: '+91${phoneNumber.text}'
                          );
                        }
                        else{
                          Toast.show(
                              'Invalid Phone Number',
                              duration: 3,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                      }

                    },
                    child: const Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }
}