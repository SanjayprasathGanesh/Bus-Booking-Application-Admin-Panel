import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/adminModel.dart';
import 'package:redbus_admin/settingsScreens/addAdmin.dart';
import 'package:redbus_admin/settingsScreens/updateAdmin.dart';
import 'package:toast/toast.dart';

class Admins extends StatefulWidget {
  const Admins({Key? key}) : super(key: key);

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  DatabaseConnection databaseConnection = DatabaseConnection();
  List<AdminModel> adminList = [];
  List<String> adminIds = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getAdminDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAdminDetails() async {
    try {
      QuerySnapshot querySnapshot = await databaseConnection.getAllAdmin();
      if (mounted) {
        List<AdminModel> tempList = [];
        List<String> tempIds = [];

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
          var ad = AdminModel();
          ad.adminName = map['adminName'];
          ad.adminEmail = map['adminEmail'];
          ad.adminPhone = map['adminPhone'];
          ad.adminType = map['adminType'];
          ad.adminPsw = map['adminPsw'];
          tempList.add(ad);
          tempIds.add(querySnapshot.docs[i].id);
        }

        setState(() {
          adminList = tempList;
          adminIds = tempIds;
          isLoaded = true;
        });
      }
    } catch (e) {
      print("Error fetching admin details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Admins",
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admins",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 750,
            child: adminList.isEmpty
                ? const Center(
                    child: Text(
                    "No Admins, Please add Admin",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                      ),
                    ),
                  )
                  : getAdmins(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Admin',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdmins())).then((data) {
            if (data != null) {
              getAdminDetails();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget getAdmins() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 200) / 2;
    final double itemWidth = size.width / 2;
    return GridView.builder(
      itemCount: adminList.length,
      controller: ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 40.0,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 5,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 40.0,
                  child: Icon(Icons.person,color: Colors.blue,size: 40.0,),
                ),
                const SizedBox(height: 5.0,),
                Text(
                  '${adminList[index].adminName}', style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway',
                  ),
                ),
                const SizedBox(height: 8.0,),
                Text(
                  '${adminList[index].adminType}', style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontFamily: 'Raleway',
                  ),
                ),
                const SizedBox(height: 8.0,),
                Text(
                  '${adminList[index].adminPhone}', style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway',
                  ),
                ),
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAdmins(adminId: adminIds[index]))).then((value){
                            if(value != null){
                              getAdminDetails();
                            }
                          });
                        },
                        icon: const Icon(Icons.edit_location_alt_outlined,color: Colors.green,size: 30.0,)
                    ),
                    const SizedBox(width: 10.0,),
                    IconButton(
                        onPressed: (){
                          ToastContext().init(context);
                          if(adminList[index].adminType != 'Super Admin'){
                            deleteAdmin(context, adminIds[index]);
                          }
                          else{
                            Toast.show(
                              'Super Admin cannot be Deleted',
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
                        icon: const Icon(Icons.delete_outline,color: Colors.red,size: 30.0,)
                    )
                  ],
                )
              ],
            )
          ),
        );
      },
    );
  }

  deleteAdmin(BuildContext context, String id){
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Do You want to Delete this Admin',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red),
                  onPressed: (){
                    databaseConnection.deleteAdmin(id);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(

                      backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        }
    );
  }
}
