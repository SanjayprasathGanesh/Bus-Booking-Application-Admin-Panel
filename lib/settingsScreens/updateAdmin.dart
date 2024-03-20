import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/adminModel.dart';
import 'package:toast/toast.dart';

class UpdateAdmins extends StatefulWidget {
  final String adminId;
  const UpdateAdmins({Key? key, required this.adminId}) : super(key: key);

  @override
  State<UpdateAdmins> createState() => _UpdateAdminsState();
}

class _UpdateAdminsState extends State<UpdateAdmins> {

  TextEditingController adminName = TextEditingController();
  TextEditingController adminPhone = TextEditingController();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController adminPsw = TextEditingController();
  String adminDesg = 'Super Admin';
  DatabaseConnection databaseConnection = DatabaseConnection();

  bool validateName = false, validatePhone = false, validateEmail = false, validatePsw = false;

  getAdminDetails() async{
    DocumentSnapshot documentSnapshot = await databaseConnection.getSpecificAdmin(widget.adminId);
    Map<String, dynamic> map = documentSnapshot.data() as Map<String,dynamic>;
    setState(() {
      adminName.text = map['adminName'];
      adminPhone.text = map['adminPhone'];
      adminEmail.text = map['adminEmail'];
      adminPsw.text = map['adminPsw'];
      adminDesg = map['adminType'];
    });
  }

  @override
  initState(){
    super.initState();
    getAdminDetails();
  }

  selectAdminType(){
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0)
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: adminDesg,
            onChanged: (String? newValue) {
              setState(() {
                adminDesg = newValue!;
              });
            },
            isExpanded: true,
            items: <String>[
              'Super Admin',
              'Sub Admin',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style: const TextStyle(
                  fontFamily: 'Raleway',
                ),),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Admin",style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  label: const Text('Admin Name',style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                  ),),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )
                  ),
                  errorText: validateName ? 'Empty Admin Name Field' : null,
                ),
                controller: adminName,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Admin Phone Number',style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                  ),),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )
                  ),
                  errorText: validatePhone ? 'Empty Admin Phone Number Field' : null,
                ),
                controller: adminPhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Admin Email Id',style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                  ),),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )
                  ),
                  errorText: validateEmail ? 'Empty Admin Email Id Field' : null,
                ),
                controller: adminEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Set Admin Password',style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Raleway',
                  ),),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )
                  ),
                  errorText: validatePsw ? 'Empty Admin Password Field' : null,
                ),
                controller: adminPsw,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 10.0,
              ),
              selectAdminType(),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: (){
                      setState(() {
                        adminName.clear();
                        adminEmail.clear();
                        adminPhone.clear();
                        adminPsw.clear();
                      });
                    },
                    child: const Text('Clear',style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600
                    ),),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: (){
                      ToastContext().init(context);
                      setState(() {
                        validateName = adminName.text.isEmpty;
                        validateEmail = adminEmail.text.isEmpty;
                        validatePhone = adminPhone.text.isEmpty;
                        validatePsw = adminPsw.text.isEmpty;
                      });
                      if(!validateName && !validatePhone && !validatePsw && !validateEmail){
                        AdminModel ad = AdminModel();
                        ad.adminName = adminName.text;
                        ad.adminPhone = adminPhone.text;
                        ad.adminEmail = adminEmail.text;
                        ad.adminType = adminDesg;
                        ad.adminPsw = adminPsw.text;

                        databaseConnection.updateAdmin(widget.adminId,ad);
                        Toast.show(
                          'Admin Updated Successfully',
                          duration: 3,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                          ),
                          gravity: Toast.bottom,
                        );
                        Navigator.pop(context, 1);
                      }
                      else{
                        Toast.show(
                          'Empty Fields',
                          duration: 3,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                          ),
                          gravity: Toast.bottom,
                        );
                      }
                    },
                    child: const Text('Update Admin',style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600
                    ),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
