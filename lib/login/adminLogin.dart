// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:redbus_admin/database/databaseConnection.dart';
// import 'package:redbus_admin/login/phone.dart';
// import 'package:toast/toast.dart';
//
// class AdminLogin extends StatefulWidget {
//   const AdminLogin({super.key});
//
//   @override
//   State<AdminLogin> createState() => _AdminLoginState();
// }
//
// class _AdminLoginState extends State<AdminLogin> {
//
//   TextEditingController name = TextEditingController();
//   TextEditingController psw = TextEditingController();
//   bool validateName = false, validatePsw = false, showPsw = true;
//   DatabaseConnection db = DatabaseConnection();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Container(
//                 height: 100,
//                 width: 300,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage('images/logo.jpg'),
//                   )
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(15.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     decoration: InputDecoration(
//                       label: const Text('Enter Admin Name',style: TextStyle(
//                         fontFamily: 'Raleway',
//                       ),),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                         )
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: const BorderSide(
//                           color: Colors.blue,
//                         )
//                       ),
//                       errorText: validateName ? 'Empty Admin Name Field' : null,
//                     ),
//                     controller: name,
//                     keyboardType: TextInputType.text,
//                   ),
//                   const SizedBox(height: 10.0,),
//                   Stack(
//                     children: [
//                       TextField(
//                         decoration: InputDecoration(
//                           label: const Text('Enter Admin Password',style: TextStyle(
//                             fontFamily: 'Raleway',
//                           ),),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.black,
//                               )
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.blue,
//                               )
//                           ),
//                           errorText: validatePsw ? 'Empty Admin Password Field' : null,
//                         ),
//                         controller: psw,
//                         keyboardType: TextInputType.visiblePassword,
//                         obscureText: showPsw,
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                           margin: const EdgeInsets.all(6.0),
//                           child: IconButton(
//                               onPressed: (){
//                                 setState(() {
//                                   showPsw = !showPsw;
//                                 });
//                               },
//                               icon: showPsw ? const Icon(Icons.remove_red_eye_outlined, size: 30.0,) : const Icon(Icons.visibility_off_outlined, size: 30.0,),
//                           ),
//                         ),
//                       )
//                     ]
//                   ),
//                   const SizedBox(height: 10.0,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                           onPressed: (){},
//                           child: const Text('Forgot Password?',style: TextStyle(
//                             fontFamily: 'Raleway',
//                             fontWeight: FontWeight.w600,
//                             color: Colors.red,
//                           ),),
//                       ),
//                       const SizedBox(width: 10.0,),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () async{
//                           ToastContext().init(context);
//                           setState(() {
//                             validateName = name.text.isEmpty;
//                             validatePsw = psw.text.isEmpty;
//                           });
//
//                           if(!validateName && !validatePsw){
//                             bool check = await db.checkAdminCred(name.text, psw.text);
//                             if(check){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => MyPhone(name: name.text,)));
//                             }
//                             else{
//                               Toast.show(
//                                 'Invalid Credentials',
//                                 duration: 3,
//                                 gravity: Toast.bottom,
//                                 backgroundColor: Colors.red,
//                                 textStyle: const TextStyle(
//                                   fontFamily: 'Raleway',
//                                 )
//                               );
//                             }
//                           }
//                           else{
//                             Toast.show(
//                                 'Empty Fields',
//                                 duration: 3,
//                                 gravity: Toast.bottom,
//                                 backgroundColor: Colors.red,
//                                 textStyle: const TextStyle(
//                                   fontFamily: 'Raleway',
//                                 )
//                             );
//                           }
//                         },
//                         child: const Text('LOGIN',style: TextStyle(
//                           fontFamily: 'Raleway',
//                           fontWeight: FontWeight.w600,
//                         ),),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 10.0,),
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/login/phone.dart';
import 'package:toast/toast.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController name = TextEditingController();
  TextEditingController psw = TextEditingController();
  bool validateName = false, validatePsw = false, showPsw = true;
  DatabaseConnection db = DatabaseConnection();

  // Save admin credentials in shared preferences
  void _saveAdminCredentials(String adminName, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminName', adminName);
    await prefs.setString('password', password);
  }

  // Retrieve admin credentials from shared preferences
  Future<Map<String, String>> _getAdminCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminName = prefs.getString('adminName');
    String? password = prefs.getString('password');
    print('Admin Name : $adminName');
    return {'adminName': adminName ?? '', 'password': password ?? ''};
  }
  
  Future<void> _loadAdminCredentials() async {
    Map<String, String> credentials = await _getAdminCredentials();
    name.text = credentials['adminName'] ?? '';
    psw.text = credentials['password'] ?? '';
  }

  @override
  void initState() {
    super.initState();
    _loadAdminCredentials(); // Load admin credentials when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo.jpg'),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      label: const Text(
                        'Enter Admin Name',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      errorText: validateName ? 'Empty Admin Name Field' : null,
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Stack(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            label: const Text(
                              'Enter Admin Password',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            errorText: validatePsw ? 'Empty Admin Password Field' : null,
                          ),
                          controller: psw,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: showPsw,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.all(6.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPsw = !showPsw;
                                });
                              },
                              icon: showPsw
                                  ? const Icon(Icons.remove_red_eye_outlined, size: 30.0,)
                                  : const Icon(Icons.visibility_off_outlined, size: 30.0,),
                            ),
                          ),
                        )
                      ]
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          ToastContext().init(context);
                          setState(() {
                            validateName = name.text.isEmpty;
                            validatePsw = psw.text.isEmpty;
                          });

                          if (!validateName && !validatePsw) {
                            bool check = await db.checkAdminCred(name.text, psw.text);
                            if (check) {
                              // Save the admin credentials in shared preferences
                              _saveAdminCredentials(name.text, psw.text);

                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPhone(name: name.text,)));
                            } else {
                              Toast.show(
                                'Invalid Credentials',
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red,
                                textStyle: const TextStyle(
                                  fontFamily: 'Raleway',
                                ),
                              );
                            }
                          } else {
                            Toast.show(
                              'Empty Fields',
                              duration: 3,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                fontFamily: 'Raleway',
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
