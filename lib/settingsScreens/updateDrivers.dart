import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/driverModel.dart';
import 'package:toast/toast.dart';

class UpdateDrivers extends StatefulWidget {
  final String driverId;
  const UpdateDrivers({Key? key, required this.driverId}) : super(key: key);

  @override
  State<UpdateDrivers> createState() => _UpdateDriversState();
}

class _UpdateDriversState extends State<UpdateDrivers> {

  TextEditingController driverName = TextEditingController();
  TextEditingController driverPhone = TextEditingController();
  TextEditingController driverDOB = TextEditingController();
  TextEditingController driverAge = TextEditingController();
  TextEditingController driverLicenseId = TextEditingController();
  TextEditingController driverAadharNumber = TextEditingController();
  TextEditingController driverAddress = TextEditingController();
  String driverType = 'Permanent', driverImg = '';

  DatabaseConnection databaseConnection = DatabaseConnection();

  bool validateName = false, validatePhone = false, validateDOB = false, validateAge = false, validateAddress = false, validateAadhar = false, validateLicense = false;

  getDriverDetails() async{
    DocumentSnapshot documentSnapshot = await databaseConnection.getSpecificDriver(widget.driverId);
    Map<String, dynamic> map = documentSnapshot.data() as Map<String,dynamic>;
    setState(() {
      driverName.text = map['driverName'];
      driverPhone.text = map['driverPhone'];
      driverAddress.text = map['driverAddress'];
      driverDOB.text = map['driverDob'];
      driverAge.text = map['driverAge'].toString();
      driverType = map['driverType'];
      driverLicenseId.text = map['driverLicenseId'];
      driverAadharNumber.text = map['driverAadharNumber'];
      driverImg = map['driverImg'];
    });
  }

  selectDriverType(){
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
            value: driverType,
            onChanged: (String? newValue) {
              setState(() {
                driverType = newValue!;
              });
            },
            isExpanded: true,
            items: <String>[
              'Permanent',
              'Temporary',
              'Acting',
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

  selectDOB() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year-20),
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year-20),
    );

    if(selected != null){
      setState(() {
        driverDOB.text = selected.toString().split(" ")[0];
        driverAge.text = DateTime.now().difference(selected).toString();
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverDetails();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Drivers",style: TextStyle(
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
                  label: const Text('Driver Name',style: TextStyle(
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
                  errorText: validateName ? 'Empty Driver Name Field' : null,
                ),
                controller: driverName,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Driver Phone Number',style: TextStyle(
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
                  errorText: validatePhone ? 'Empty Driver Phone Number Field' : null,
                ),
                controller: driverPhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Driver Address',style: TextStyle(
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
                  errorText: validateAddress ? 'Empty Driver Address Field' : null,
                ),
                controller: driverAddress,
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Driver DOB',style: TextStyle(
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
                  errorText: validateDOB ? 'Empty Driver DOB Field' : null,
                ),
                controller: driverDOB,
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: (){
                  selectDOB();
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Driver Age',style: TextStyle(
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
                  errorText: validateAge ? 'Empty Driver Age Field' : null,
                ),
                controller: driverAge,
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              const SizedBox(
                height: 10.0,
              ),
              selectDriverType(),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Driver License ID',style: TextStyle(
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
                  errorText: validateLicense ? 'Empty Driver License Number Field' : null,
                ),
                controller: driverLicenseId,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Driver Aadhar Card Number',style: TextStyle(
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
                  errorText: validateAadhar ? 'Empty Driver Aadhar card Number Field' : null,
                ),
                controller: driverAadharNumber,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
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
                      backgroundColor: Colors.red,
                    ),
                    onPressed: (){
                      setState(() {
                        driverName.clear();
                        driverPhone.clear();
                        driverAadharNumber.clear();
                        driverLicenseId.clear();
                        driverDOB.clear();
                        driverAddress.clear();
                        driverType = 'Permanent';
                        driverAge.clear();
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
                        validateName = driverName.text.isEmpty;
                        validateAddress = driverAddress.text.isEmpty;
                        validatePhone = driverPhone.text.isEmpty;
                        validateDOB = driverDOB.text.isEmpty;
                        validateAge = driverAge.text.isEmpty;
                        validateAadhar = driverAadharNumber.text.isEmpty;
                        validateLicense = driverLicenseId.text.isEmpty;
                      });
                      if(!validateName && !validatePhone && !validateAddress && !validateDOB && !validateAge && !validateAadhar && !validateLicense){
                        if(!validateName && !validatePhone && !validateAddress && !validateDOB && !validateAge && !validateAadhar && !validateLicense){
                          DriverModel dm = DriverModel();
                          dm.driverName = driverName.text;
                          dm.driverPhone = driverPhone.text;
                          dm.driverAddress = driverAddress.text;
                          dm.driverDob = driverDOB.text;
                          dm.driverAge = int.parse(driverAge.text);
                          dm.driverAadharNumber = driverAadharNumber.text;
                          dm.driverLicenceId = driverLicenseId.text;
                          dm.driverType = driverType;
                          dm.driverImg = '-';

                          databaseConnection.updateDriver(widget.driverId,dm);
                          Toast.show(
                            'Driver Updated Successfully',
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
                            'Incorrect Values in some Fields',
                            duration: 3,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                            ),
                            gravity: Toast.bottom,
                          );
                        }
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
                    child: const Text('Update Driver',style: TextStyle(
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
