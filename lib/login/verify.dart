// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:redbus_admin/database/databaseConnection.dart';
// import 'package:redbus_admin/main.dart';
// import 'package:redbus_admin/model/loginActModel.dart';
//
// import '../screens/home.dart';
//
// class MyVerify extends StatefulWidget {
//   String verificationId;
//   String name;
//   String phone;
//   MyVerify({Key? key, required this.verificationId, required this.name, required this.phone}) : super(key: key);
//
//   @override
//   State<MyVerify> createState() => _MyVerifyState();
// }
//
// class _MyVerifyState extends State<MyVerify> {
//   TextEditingController otp = TextEditingController();
//   DatabaseConnection db = DatabaseConnection();
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: TextStyle(
//           fontSize: 20,
//           color: Color.fromRGBO(30, 60, 87, 1),
//           fontWeight: FontWeight.w600),
//       decoration: BoxDecoration(
//         border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//
//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
//       borderRadius: BorderRadius.circular(8),
//     );
//
//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Color.fromRGBO(234, 239, 243, 1),
//       ),
//     );
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_rounded,
//             color: Colors.black,
//           ),
//         ),
//         elevation: 0,
//       ),
//       body: Container(
//         margin: const EdgeInsets.only(left: 25, right: 25),
//         alignment: Alignment.center,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'images/logo.jpg',
//                 width: 150,
//                 height: 150,
//                 fit: BoxFit.fitWidth,
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               const Text(
//                 "Phone Verification",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "We need to authenticate and verify your phone number before getting started!",
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Pinput(
//                 length: 6,
//                 // defaultPinTheme: defaultPinTheme,
//                 // focusedPinTheme: focusedPinTheme,
//                 // submittedPinTheme: submittedPinTheme,
//
//                 showCursor: true,
//                 onCompleted: (pin) => setState(() {
//                   otp.text = pin;
//                 }),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         primary: Colors.green.shade600,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     onPressed: () async{
//                       print(otp.text);
//                       try{
//                         PhoneAuthCredential credential = await PhoneAuthProvider
//                             .credential(verificationId: widget.verificationId, smsCode: otp.text);
//
//                         LoginActivityModel lm = LoginActivityModel();
//                         lm.adminName = widget.name;
//                         lm.adminPhone = widget.phone;
//                         lm.date = DateTime.now().toString().split(" ")[0];
//                         lm.time = DateTime.now().toString().split(" ")[1].split(".")[0];
//                         db.addLoginActivity(lm);
//
//
//                         FirebaseAuth.instance.signInWithCredential(credential).then((value){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => RedbusAdmin(name: widget.name, phone: widget.phone)));
//                         });
//                       }
//                       catch(ex){
//                         //
//                       }
//                     },
//                     child: const Text("Verify Phone Number")),
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                       onPressed: () async{
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => Buses(from: 'Coimbatore', to: 'Bangalore', date: '2024-01-29', uname: 'sanjay')));
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Edit Phone Number ?",
//                         style: TextStyle(color: Colors.black),
//                       ))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/main.dart';
import 'package:redbus_admin/model/loginActModel.dart';
import '../screens/home.dart';

class MyVerify extends StatefulWidget {
  String verificationId;
  String name;
  String phone;
  MyVerify({Key? key, required this.verificationId, required this.name, required this.phone}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  TextEditingController otp = TextEditingController();
  DatabaseConnection db = DatabaseConnection();
  late Timer _timer;
  int _secondsRemaining = 45;

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    // Start a timer that ticks every second
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_secondsRemaining == 0) {
        // If time is up, navigate back to the previous page
        timer.cancel();
        Navigator.pop(context);
      } else {
        setState(() {
          // Decrement the time remaining
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.jpg',
                width: 150,
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
                "We need to authenticate and verify your phone number before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onCompleted: (pin) => setState(() {
                  otp.text = pin;
                }),
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
                      print(otp.text);
                      try{
                        PhoneAuthCredential credential = await PhoneAuthProvider
                            .credential(verificationId: widget.verificationId, smsCode: otp.text);

                        LoginActivityModel lm = LoginActivityModel();
                        lm.adminName = widget.name;
                        lm.adminPhone = widget.phone;
                        lm.date = DateTime.now().toString().split(" ")[0];
                        lm.time = DateTime.now().toString().split(" ")[1].split(".")[0];
                        db.addLoginActivity(lm);


                        FirebaseAuth.instance.signInWithCredential(credential).then((value){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RedbusAdmin(name: widget.name, phone: widget.phone)));
                        });
                      }
                      catch(ex){
                        //
                      }
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Reset the timer when Edit Phone Number is pressed
                      // _secondsRemaining = 45;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Edit Phone Number", // Show remaining seconds in the button text
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  Text('${_secondsRemaining}s Remainning',)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
