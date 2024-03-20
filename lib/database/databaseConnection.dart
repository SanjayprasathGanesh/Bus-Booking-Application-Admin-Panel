import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redbus_admin/model/busExpModel.dart';
import 'package:redbus_admin/model/busModel.dart';
import 'package:redbus_admin/model/driverModel.dart';
import 'package:redbus_admin/model/loginActModel.dart';

import '../model/adminModel.dart';
import '../settingsScreens/offers.dart';

class DatabaseConnection{
  Future<void> addBus(Map<String, dynamic> busMap) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .doc()
        .set(busMap);
  }

  Future<QuerySnapshot> readBus(String date) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .where("start_date", isEqualTo: date)
        .get();
  }

  Future<void> updateBus(String id, BusModel busModel) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .doc(id)
        .update({
          'boarding': busModel.boarding,
          'busName': busModel.busName,
          'busNo': busModel.busNo,
          'driverName': busModel.driverName,
          'driverNo': busModel.driverNo,
          'endDate': busModel.endDate,
          'from': busModel.from,
          'price': busModel.price,
          'routes': busModel.routes,
          'startDate': busModel.startDate,
          'startTime': busModel.startTime,
          'to': busModel.to,
          'ttlSeats': busModel.ttlSeats,
          'type': busModel.type,
    });
  }

  Future<void> deleteBus(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .doc(id)
        .delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBusDetails(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .doc(id)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSpecificBusRoute(String from, String to, String month) async {

    return await FirebaseFirestore
        .instance
        .collection('bus')
        .where('from', isEqualTo: from)
        .where('to', isEqualTo: to)
        .where('month', isEqualTo: month)
        .get();
  }


  Future<QuerySnapshot> getBookings(String id) async{

    return await FirebaseFirestore
        .instance
        .collection('bookings')
        .where('busId', isEqualTo: id)
        .where('status', isEqualTo: 'Confirmed')
        .get();
  }

  Future<QuerySnapshot> getCancelledBookings(String id) async{

    return await FirebaseFirestore
        .instance
        .collection('bookings')
        .where('busId', isEqualTo: id)
        .where('status', isEqualTo: 'Cancelled')
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBusForExpCalc(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .doc(id)
        .get();
  }

  //For Bus Expense Collection
  Future<void> addBusExp(BusExpModel busExpModel) async{
    return await FirebaseFirestore
        .instance
        .collection('bus Expense')
        .doc()
        .set(busExpModel.busExpMap());
  }

  Future<void> updateBusExp(BusExpModel busExpModel, String id) async{
    return await FirebaseFirestore
        .instance
        .collection('bus Expense')
        .doc(id)
        .update({
          'ttlKm': busExpModel.ttlKm,
          'ttlLitres': busExpModel.ttlLitres,
          'ttlPrice': busExpModel.ttlPrice,
          'driverName': busExpModel.driverName,
          'driverSal': busExpModel.driverSal,
          'driverSal': busExpModel.driverSal,
          'isDamaged': busExpModel.isDamaged,
          'damageName': busExpModel.damageName,
          'damageAmt': busExpModel.damageAmt,
          'isServiced': busExpModel.isServiced,
          'isFined': busExpModel.isFined,
          'fineName': busExpModel.fineName,
          'fineAmt': busExpModel.fineAmt,
          'isPaid': busExpModel.isPaid,
          'ttlSeats': busExpModel.ttlSeats,
          'bookedSeats': busExpModel.bookedSeats,
          'ticPrice': busExpModel.ticPrice,
          'estPrice': busExpModel.estPrice,
          'ttlBusExp': busExpModel.ttlBusExp,
          'resultPrice': busExpModel.resultPrice,
          'balance': busExpModel.balance,
          'status': busExpModel.status,
        });
  }

  Future<QuerySnapshot> getBusAnalytics(String id) async{

    return await FirebaseFirestore
        .instance
        .collection('bus Expense')
        .where('busId', isEqualTo: id)
        .get();
  }

  Future<QuerySnapshot> getBusFromTo(String month) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .where('month', isEqualTo: month)
        .get();
  }

  Future<QuerySnapshot> getSpecificRouteCount(String month, String from,String to) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .where('from', isEqualTo: from)
        .where('to', isEqualTo: to)
        .where('month', isEqualTo: month)
        .get();
  }

  Future<QuerySnapshot> getSpecificBusConfirmedCount(String busId) async{
    return await FirebaseFirestore
        .instance
        .collection('bookings')
        .where('busId', isEqualTo: busId)
        .where('status', isEqualTo: 'Confirmed')
        .get();
  }

  Future<QuerySnapshot> getSpecificBusCancelledCount(String busId) async{
    return await FirebaseFirestore
        .instance
        .collection('bookings')
        .where('busId', isEqualTo: busId)
        .where('status', isEqualTo: 'Cancelled')
        .get();
  }

  Future<void> addAdmin(AdminModel adminModel) async{
    return await FirebaseFirestore
        .instance
        .collection('admins')
        .doc()
        .set(adminModel.adminMap());
  }

  Future<QuerySnapshot> getAllAdmin() async{
    return await FirebaseFirestore
        .instance
        .collection('admins')
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSpecificAdmin(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('admins')
        .doc(id)
        .get();
  }

  Future<void> updateAdmin(String id, AdminModel adminModel) async{
    return await FirebaseFirestore
        .instance
        .collection('admins')
        .doc(id)
        .set({
          'adminName': adminModel.adminName,
          'adminEmail': adminModel.adminEmail,
          'adminPhone': adminModel.adminPhone,
          'adminPsw': adminModel.adminPsw,
          'adminType': adminModel.adminType,
        });
  }

  Future<void> deleteAdmin(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('admins')
        .doc(id)
        .delete();
  }

  Future<void> addDriver(DriverModel driverModel) async{
    return await FirebaseFirestore
        .instance
        .collection('drivers')
        .doc()
        .set(driverModel.driverMap());
  }

  Future<QuerySnapshot> getAllDrivers() async{
    return await FirebaseFirestore
        .instance
        .collection('drivers')
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSpecificDriver(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('drivers')
        .doc(id)
        .get();
  }

  Future<void> updateDriver(String id, DriverModel driverModel) async{
    return await FirebaseFirestore
        .instance
        .collection('drivers')
        .doc(id)
        .set({
          'driverName': driverModel.driverName,
          'driverPhone': driverModel.driverPhone,
          'driverDob': driverModel.driverDob,
          'driverAge': driverModel.driverAge,
          'driverType': driverModel.driverType,
          'driverAddress': driverModel.driverAddress,
          'driverLicenseId': driverModel.driverLicenceId,
          'driverAadharNumber': driverModel.driverAadharNumber,
          'driverImg': driverModel.driverImg,
        });
  }

  Future<void> deleteDriver(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('drivers')
        .doc(id)
        .delete();
  }

  Future<bool> checkDriverPhoneExist(String phone) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('drivers')
        .where('driverPhone', isEqualTo: phone)
        .get();

    if(querySnapshot.docs.isEmpty){
      return true;
    }
    return false;
  }

  Future<bool> checkDriverAadharExist(String aadhar) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('drivers')
        .where('driverAadharNumber', isEqualTo: aadhar)
        .get();

    if(querySnapshot.docs.isEmpty){
      return true;
    }
    return false;
  }

  Future<bool> checkDriverLicenseExist(String license) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('drivers')
        .where('driverLicenseId', isEqualTo: license)
        .get();

    if(querySnapshot.docs.isEmpty){
      return true;
    }
    return false;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllContactUs() async{
    return await FirebaseFirestore
        .instance
        .collection('user contact forms')
        .get();
  }

  Future<void> updateContactReply(String id, bool isReplied) async{
    return await FirebaseFirestore
        .instance
        .collection('user contact forms')
        .doc(id)
        .update({
          'isReplied': isReplied,
        });
  }

  Future<void> addOffer(OfferModel offerModel) async{
    return await FirebaseFirestore
        .instance
        .collection('offers')
        .doc()
        .set(offerModel.offerMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllOffers() async{
    return await FirebaseFirestore
        .instance
        .collection('offers')
        .get();
  }

  Future<void> updateOffer(String id, OfferModel offerModel) async{
    return await FirebaseFirestore
        .instance
        .collection('offers')
        .doc(id)
        .update({
          'offerName': offerModel.offerName,
          'offerCode': offerModel.offerCode,
          'validFrom': offerModel.validFrom,
          'validTo': offerModel.validTo,
          'discountPrice': offerModel.discountPrice,
          'isExpired': offerModel.isExpired,
        });
  }

  Future<void> deleteOffer(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('offers')
        .doc(id)
        .delete();
  }
  
  Future<QuerySnapshot<Map<String, dynamic>>> getAllRent() async{
    return await FirebaseFirestore
        .instance
        .collection('bus rent')
        .get();
  }

  Future<void> updateBusRentReply(String id, bool isAssigned) async{
    return await FirebaseFirestore
        .instance
        .collection('bus rent')
        .doc(id)
        .update({
          'isAssigned': isAssigned,
    });
  }

  Future<bool> checkAdminCred(String name, String psw) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('admins')
        .where('adminName', isEqualTo: name)
        .where('adminPsw', isEqualTo: psw)
        .get();

    if(querySnapshot.docs.isNotEmpty && querySnapshot.size == 1){
      return true;
    }
    return false;
  }

  Future<String> getAdminPhone(String name) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('admins')
        .where('adminName', isEqualTo: name)
        .get();

    if(querySnapshot.docs.isNotEmpty && querySnapshot.size == 1){
      Map<String, dynamic> map =  querySnapshot.docs[0].data() as Map<String, dynamic>;
      return map['adminPhone'];
    }
    return 'Not Found';
  }

  Future<String> getAdminType(String name, String phone) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('admins')
        .where('adminName', isEqualTo: name)
        .where('adminPhone', isEqualTo: phone)
        .get();

    if(querySnapshot.docs.isNotEmpty && querySnapshot.size == 1){
      Map<String, dynamic> map =  querySnapshot.docs[0].data() as Map<String, dynamic>;
      return map['adminType'];
    }
    return 'Not Found';
  }

  Future<bool> checkAdminNameExist(String name) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('admins')
        .where('adminName', isEqualTo: name)
        .get();

    if(querySnapshot.docs.isEmpty){
      return true;
    }
    return false;
  }

  Future<bool> checkAdminPhoneExist(String phone) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('admins')
        .where('adminPhone', isEqualTo: phone)
        .get();

    if(querySnapshot.docs.isEmpty){
      return true;
    }
    return false;
  }

  Future<bool> checkAdminEmailExist(String email) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore
        .instance
        .collection('admins')
        .where('adminEmail', isEqualTo: email)
        .get();

    if(querySnapshot.docs.isEmpty){
      return true;
    }
    return false;
  }

  Future<void> addLoginActivity(LoginActivityModel loginActivityModel) async{
    return await FirebaseFirestore
        .instance
        .collection('login Activity')
        .doc()
        .set(loginActivityModel.actMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLoginActivity() async{
    return await FirebaseFirestore
        .instance
        .collection('login Activity')
        .get();
  }
  
  Future<DocumentSnapshot<Map<String, dynamic>>> getBoardingAndDropping(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .doc(id)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBoardingAndDroppingCount(String id) async{
    return await FirebaseFirestore
        .instance
        .collection('bookings')
        .where('busId', isEqualTo: id)
        .get();
  }

  Future<QuerySnapshot> getOperatorsCount() async{
    return await FirebaseFirestore
        .instance
        .collection('bus')
        .get();
  }

  Future<QuerySnapshot> getDriversCount() async{
    return await FirebaseFirestore
        .instance
        .collection('drivers')
        .get();
  }


}