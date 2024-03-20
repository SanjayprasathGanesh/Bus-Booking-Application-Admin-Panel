import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/busExpModel.dart';
import 'package:redbus_admin/model/busModel.dart';
import 'package:toast/toast.dart';
import 'package:fl_chart/fl_chart.dart';

class BusAnalytics extends StatefulWidget {
  final String busId;
  const BusAnalytics({Key? key, required this.busId}) : super(key: key);

  @override
  State<BusAnalytics> createState() => _BusAnalyticsState();
}

class _BusAnalyticsState extends State<BusAnalytics> {

  BusExpModel busExp = BusExpModel();
  DatabaseConnection databaseConnection = DatabaseConnection();

  TextEditingController ttlKm = TextEditingController();
  TextEditingController ttlLitre = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController mileage = TextEditingController();
  TextEditingController damagesName = TextEditingController();
  TextEditingController damagesPrice = TextEditingController();
  TextEditingController fineName = TextEditingController();
  TextEditingController finePrice = TextEditingController();
  TextEditingController driverName = TextEditingController();
  TextEditingController dSalary = TextEditingController();

  bool validateKM = false, validateLitre = false, validatePrice = false, validateMileage = false,
      validateDName = false, validateDPrice = false, validateFName = false, validateFPrice = false,
      validateDSalary = false;

  bool isDamaged = false, isFined = false, isServiced = false, isPaid = false, isAlreadyFilled = false;
  bool isExpanded = false, isEnabled = false;

  String docId = '';

  @override
  initState(){
    super.initState();
    getBusDetails();
    getAnalyticsDetails();

    getAllBoardingAndDropping();
    getAllBoardingDroppingCount();
  }

  int ttlSeats = 0, bookedSeats = 0, ticPrice = 0;
  int estPrice = 0,resPrice = 0,ttlExp = 0,balance = 0;
  String status = '', date = '';

  getBusDetails() async{
    DocumentSnapshot ds = await databaseConnection.getBusForExpCalc(widget.busId);
    Map<String, dynamic> busMap = ds.data() as Map<String, dynamic>;
    setState(() {
      if(!isAlreadyFilled){
        driverName.text = busMap?['driverName'];
        ttlSeats = busMap?['ttlSeats'];
        String bSeats = busMap?['bookedSeats'];
        List<String> bSeatsList = bSeats.replaceAll(',,', ',').replaceAll('[', '').replaceAll(']', '').replaceAll(RegExp(r'[^0-9,]'), '').split(',');
        bookedSeats = bSeatsList.length;
        ticPrice = busMap?['price'];
        date = busMap?['startDate'];
      }
    });
  }

  getAnalyticsDetails() async{
    QuerySnapshot qs = await databaseConnection.getBusAnalytics(widget.busId);

    List<QueryDocumentSnapshot<Object?>> anaList = qs.docs!;
    Map<String, dynamic> anaMap = anaList[0].data() as Map<String, dynamic>;

    setState(() {
      docId = anaList[0].id;
      ttlSeats = anaMap['ttlSeats'];
      bookedSeats = anaMap['bookedSeats'];
      estPrice = anaMap['estPrice'];
      resPrice = anaMap['resultPrice'];
      ttlExp = anaMap['ttlBusExp'];
      balance = anaMap['balance'];
      status = anaMap['status'];
      isAlreadyFilled = anaMap.isNotEmpty;

      if(isAlreadyFilled){
        ttlKm.text = anaMap['ttlKm'].toString();
        ttlLitre.text = anaMap['ttlLitres'].toString();
        price.text = anaMap['ttlPrice'].toString();
        mileage.text = anaMap['mileage'].toString();
        driverName.text = anaMap['driverName'];
        dSalary.text = anaMap['driverSal'].toString();
        isDamaged = anaMap['isDamaged'];
        damagesName.text = anaMap['damageName'];
        damagesPrice.text = anaMap['damageAmt'].toString();
        isServiced = anaMap['isServiced'];
        isFined = anaMap['fined'];
        fineName.text = anaMap['fineName'].toString();
        finePrice.text = anaMap['fineAmt'].toString();
        isPaid = anaMap['isPaid'];
      }
    });
  }

  getDamagedDetails(){
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
              color: Colors.blue,
              width: 3.0
          )
      ),
      width: double.infinity,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              label: const Text('Damaged Details',style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorText: validateDName ? 'Empty Damaged Name Field' : null,
            ),
            controller: damagesName,
            keyboardType: TextInputType.text,
            maxLines: 3,
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: InputDecoration(
              label: const Text('Quoted Price For Damage',style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorText: validateDPrice ? 'Empty Damaged Price Field' : null,
            ),
            controller: damagesPrice,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              const Text('Damage Serviced : ',style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold
              ),),
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isServiced = !isServiced;
                      });
                    },
                    icon: Icon(isServiced ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                  ),
                  const Text('Yes',style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold
                  ),),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isServiced = !isServiced;
                      });
                    },
                    icon: Icon(!isServiced ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                  ),
                  const Text('No',style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  getFineDetails(){
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
              color: Colors.blue,
              width: 3.0
          )
      ),
      width: double.infinity,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              label: const Text('Fine Details',style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorText: validateFName ? 'Empty Fined Name Field' : null,
            ),
            controller: fineName,
            keyboardType: TextInputType.text,
            maxLines: 3,
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: InputDecoration(
              label: const Text('Fine Price',style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorText: validateFPrice ? 'Empty Fined Price Field' : null,
            ),
            controller: finePrice,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              const Text('Is Fine Paid : ',style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),),
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isPaid = !isPaid;
                      });
                    },
                    icon: Icon(isPaid ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                  ),
                  const Text('Yes',style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  ),),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        isPaid = !isPaid;
                      });
                    },
                    icon: Icon(!isPaid ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                  ),
                  const Text('No',style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  getBusExp(){
    DateTime givenDate = DateTime.parse(date);
    DateTime currentDate = DateTime.now();
    isEnabled = givenDate.isBefore(currentDate);
    if(isEnabled){
      return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: Colors.blue,
                width: 3.0
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 4.0,
            ),
            const Text('Please fill the Bus Expense Details',style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15.0,
                fontWeight: FontWeight.bold
            ),),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Total Kilometre',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                      ),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: validateKM ? 'Empty Total Kilometre Field' : null,
                    ),
                    controller: ttlKm,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Total Litres',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                      ),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: validateLitre ? 'Empty Total Litres Field' : null,
                    ),
                    controller: ttlLitre,
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Total Price',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                      ),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: validatePrice ? 'Empty Total Price Field' : null,
                    ),
                    controller: price,
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    /*onChanged: (String? value){
                    setState(() {
                      mileage.text = '${int.parse(value!)}'
                    });
                  },*/
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Text('Mileage Got',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                      ),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: validateMileage ? 'Empty Mileage Field' : null,
                    ),
                    controller: mileage,
                    readOnly: true,
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Text('Driver Name',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                      ),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    controller: driverName,
                    readOnly: true,
                    // keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      label: const Text('Driver Salary',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                      ),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: validateDSalary ? 'Empty Driver Salary Field' : null,
                    ),
                    controller: dSalary,
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                const Text('Any Damages: ',style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() {
                          isDamaged = !isDamaged;
                        });
                      },
                      icon: Icon(isDamaged ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                    ),
                    const Text('Yes',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          isDamaged = !isDamaged;
                        });
                      },
                      icon: Icon(!isDamaged ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                    ),
                    const Text('No',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
            isDamaged ? getDamagedDetails() : const SizedBox(),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                const Text('Any Fines: ',style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() {
                          isFined = !isFined;
                        });
                      },
                      icon: Icon(isFined ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                    ),
                    const Text('Yes',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          isFined = !isFined;
                        });
                      },
                      icon: Icon(!isFined ? Icons.circle : Icons.circle_outlined, color: Colors.blue,),
                    ),
                    const Text('No',style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            isFined ? getFineDetails() : const SizedBox(),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: (){
                setState(() {
                  validateKM = ttlKm.text.isEmpty;
                  validateLitre = ttlLitre.text.isEmpty;
                  validatePrice = price.text.isEmpty;
                  // validateMileage = mileage.text.isEmpty;
                  validateDSalary = dSalary.text.isEmpty;

                  if(isDamaged){
                    validateDName = damagesName.text.isEmpty;
                    validateDPrice = damagesPrice.text.isEmpty;
                  }

                  if(isFined){
                    validateFName = fineName.text.isEmpty;
                    validateFPrice = finePrice.text.isEmpty;
                  }
                });

                //Update
                print(isAlreadyFilled);
                if(isAlreadyFilled){
                  if(!validateKM && !validateLitre && !validatePrice){

                    busExp.busId = widget.busId;
                    busExp.ttlKm = int.parse(ttlKm.text);
                    busExp.ttlLitres = int.parse(ttlLitre.text);
                    busExp.ttlPrice = int.parse(price.text);
                    busExp.mileage = (int.parse(ttlLitre.text) / int.parse(price.text)).round();
                    busExp.driverName = driverName.text;
                    busExp.driverSal = int.parse(dSalary.text);

                    busExp.isDamaged = isDamaged;
                    busExp.isFined = isFined;
                    if(isDamaged && !validateDName && !validateDPrice){

                      busExp.damageName = damagesName.text;
                      busExp.damageAmt = int.parse(damagesPrice.text);
                      busExp.isServiced = isServiced;

                      if(isFined && !validateFName && !validateFPrice){

                        busExp.fineName = fineName.text;
                        busExp.fineAmt = int.parse(finePrice.text);
                        busExp.isPaid = isPaid;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + int.parse(damagesPrice.text) + int.parse(finePrice.text));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.updateBusExp(busExp, docId);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Added',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else if(!isFined){
                        busExp.fineName = 'NA';
                        busExp.fineAmt = 0;
                        busExp.isPaid = false;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + (isDamaged ? int.parse(damagesPrice.text) : 0) + ( isFined ? int.parse(finePrice.text) : 0));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.updateBusExp(busExp, docId);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Added',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else{
                        if(validateFName && !validateFPrice){
                          Toast.show(
                              'Empty Fine Name Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else if(!validateFName && validateFPrice){
                          Toast.show(
                              'Empty Fine Price Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else{
                          Toast.show(
                              'Empty on Both Fine Details Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                      }
                    }
                    else if(!isDamaged){
                      busExp.damageName = 'NA';
                      busExp.damageAmt = 0;
                      busExp.isServiced = false;

                      if(isFined && !validateFName && !validateFPrice){
                        busExp.fineName = fineName.text;
                        busExp.fineAmt = int.parse(finePrice.text);
                        busExp.isPaid = isPaid;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + int.parse(damagesPrice.text) + int.parse(finePrice.text));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.updateBusExp(busExp, docId);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Updated',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else if(!isFined){
                        busExp.fineName = 'NA';
                        busExp.fineAmt = 0;
                        busExp.isPaid = false;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + int.parse(damagesPrice.text) + int.parse(finePrice.text));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.updateBusExp(busExp, docId);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Updated',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else{
                        if(validateFName && !validateFPrice){
                          Toast.show(
                              'Empty Fine Name Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else if(!validateFName && validateFPrice){
                          Toast.show(
                              'Empty Fine Price Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else{
                          Toast.show(
                              'Empty on Both Fine Details Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                      }
                    }
                    else{
                      if(validateDName && !validateDPrice){
                        Toast.show(
                            'Empty Damaged Name Field',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else if(!validateDName && validateDPrice){
                        Toast.show(
                            'Empty Damaged Price Field',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else{
                        Toast.show(
                            'Empty on Both Damaged Details Field',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                    }
                  }
                }
                else{
                  if(!validateKM && !validateLitre && !validatePrice){

                    busExp.busId = widget.busId;
                    busExp.ttlKm = int.parse(ttlKm.text);
                    busExp.ttlLitres = int.parse(ttlLitre.text);
                    busExp.ttlPrice = int.parse(price.text);
                    busExp.mileage = (int.parse(ttlLitre.text) / int.parse(price.text)).round();
                    busExp.driverName = driverName.text;
                    busExp.driverSal = int.parse(dSalary.text);

                    busExp.isDamaged = isDamaged;
                    busExp.isFined = isFined;
                    if(isDamaged && !validateDName && !validateDPrice){

                      busExp.damageName = damagesName.text;
                      busExp.damageAmt = int.parse(damagesPrice.text);
                      busExp.isServiced = isServiced;

                      if(isFined && !validateFName && !validateFPrice){

                        busExp.fineName = fineName.text;
                        busExp.fineAmt = int.parse(finePrice.text);
                        busExp.isPaid = isPaid;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + int.parse(damagesPrice.text) + int.parse(finePrice.text));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.addBusExp(busExp);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Added',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else if(!isFined){
                        busExp.fineName = 'NA';
                        busExp.fineAmt = 0;
                        busExp.isPaid = false;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + (isDamaged ? int.parse(damagesPrice.text) : 0) + ( isFined ? int.parse(finePrice.text) : 0));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.addBusExp(busExp);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Added',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else{
                        if(validateFName && !validateFPrice){
                          Toast.show(
                              'Empty Fine Name Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else if(!validateFName && validateFPrice){
                          Toast.show(
                              'Empty Fine Price Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else{
                          Toast.show(
                              'Empty on Both Fine Details Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                      }
                    }
                    else if(!isDamaged){
                      busExp.damageName = 'NA';
                      busExp.damageAmt = 0;
                      busExp.isServiced = false;

                      if(isFined && !validateFName && !validateFPrice){
                        busExp.fineName = fineName.text;
                        busExp.fineAmt = int.parse(finePrice.text);
                        busExp.isPaid = isPaid;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + int.parse(damagesPrice.text) + int.parse(finePrice.text));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.addBusExp(busExp);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Added',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else if(!isFined){
                        busExp.fineName = 'NA';
                        busExp.fineAmt = 0;
                        busExp.isPaid = false;

                        busExp.ttlSeats = ttlSeats;
                        busExp.bookedSeats = bookedSeats;
                        busExp.ticPrice = ticPrice;
                        busExp.estPrice = ticPrice * ttlSeats;
                        busExp.resultPrice = ticPrice * bookedSeats;
                        busExp.ttlBusExp = busExp.ttlPrice! + busExp.fineAmt! + busExp.damageAmt! + busExp.driverSal!;

                        int petrolPricePerSeat = (busExp.ttlPrice! / bookedSeats).round();
                        int totalRevenue = bookedSeats * petrolPricePerSeat;
                        int totalExpenses = (int.parse(dSalary.text) + int.parse(damagesPrice.text) + int.parse(finePrice.text));
                        int profitOrLoss = totalRevenue - totalExpenses;

                        busExp.balance = profitOrLoss;

                        if (profitOrLoss > 0) {
                          busExp.status = 'Profit';
                        }
                        else if (profitOrLoss < 0) {
                          busExp.status = 'Loss';
                        }
                        else {
                          busExp.status = 'Balanced';
                        }

                        databaseConnection.addBusExp(busExp);
                        getAnalyticsDetails();

                        Toast.show(
                            'Bus Expense Field Added',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else{
                        if(validateFName && !validateFPrice){
                          Toast.show(
                              'Empty Fine Name Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else if(!validateFName && validateFPrice){
                          Toast.show(
                              'Empty Fine Price Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                        else{
                          Toast.show(
                              'Empty on Both Fine Details Field',
                              duration: 2,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                              )
                          );
                        }
                      }
                    }
                    else{
                      if(validateDName && !validateDPrice){
                        Toast.show(
                            'Empty Damaged Name Field',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else if(!validateDName && validateDPrice){
                        Toast.show(
                            'Empty Damaged Price Field',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                      else{
                        Toast.show(
                            'Empty on Both Damaged Details Field',
                            duration: 2,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            )
                        );
                      }
                    }
                  }
                }
              },
              child: Row(
                children: [
                  !isAlreadyFilled ? const Text('Save',style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  ),) : SizedBox(),
                  isAlreadyFilled ? const Text('Update',style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                  ),) : SizedBox(),
                ],
              ),
            )
          ],
        ),
      );
    }
    else{
      return Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.blue,
              width: 3.0
            )
          ),
          child: const Text("You can only be able to fill the Bus Expenses only when the trip gets Completed",style: TextStyle(
              fontSize: 18.0,
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway'
          ),),
      );
    }

  }

  getExpAnalytics(){
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.blue,
          width: 3.0
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ttl Seats: $ttlSeats',style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14.0,
                fontWeight: FontWeight.bold
              ),),
              Text('Booked Seats: $bookedSeats',style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14.0,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated Price: ${ticPrice*ttlSeats}',style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),),
              Text('Result Price: ${ticPrice*bookedSeats}',style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text('Total Bus Expenses: ${isAlreadyFilled ? ttlExp : 'Not Filled'}',style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 14.0,
              fontWeight: FontWeight.bold
          ),),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Balance: ${isAlreadyFilled ? balance : 'Not Filled'}',style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14.0,
                  color: balance > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(
                width: 10.0,
              ),
              Text('Status: $status',style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16.0,
                  color: status == 'Profit' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold
              ),),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  List<String> boardingList = <String>[];
  List<String> droppingList = <String>[];
  List<int> boardingCount = <int>[];
  List<int> droppingCount = <int>[];

  Map<String, int> boardingMap = Map<String, int>();
  Map<String, int> droppingMap = Map<String, int>();

  getAllBoardingAndDropping() async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await databaseConnection.getBoardingAndDropping(widget.busId);

    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    String boarding = map['boarding'];
    String dropping = map['dropping'];

    setState(() {
      boardingList = boarding.split(',');
      droppingList = dropping.split(',');
    });
  }

  getAllBoardingDroppingCount() async{
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await databaseConnection.getBoardingAndDroppingCount(widget.busId);
    List<int> tempBoarding = <int>[];
    List<int> tempDropping = <int>[];

    for(int j = 0;j < boardingList.length;j++){
      int count = 0;
      for(int i = 0;i < querySnapshot.size;i++){
        Map<String, dynamic> map = querySnapshot.docs[i].data();
        String boarding = map['boarding'];
        String status = map['status'];

        if(boarding == boardingList.elementAt(j) && status == 'Confirmed'){
          count++;
        }

        tempBoarding.add(count);
      }

      setState(() {
        boardingCount = tempBoarding;
        boardingMap[boardingList.elementAt(j)] = count;
      });
    }

    for(int j = 0;j < droppingList.length;j++){
      int count = 0;
      for(int i = 0;i < querySnapshot.size;i++){
        Map<String, dynamic> map = querySnapshot.docs[i].data();
        String dropping = map['dropping'];
        String status = map['status'];

        if(dropping == droppingList.elementAt(j) && status == 'Confirmed'){
          count++;
        }

        tempDropping.add(count);
      }

      setState(() {
        droppingCount = tempDropping;
        droppingMap[droppingList.elementAt(j)] = count;
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics",style:
        TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Text("Bus Expense",style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Raleway'
              ),),
              trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(!isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up_outlined),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: isExpanded ? 380 : 1.0,
              height: isExpanded ? 500.0 : 1.0,
              color: const Color(0xFFa2d2ff),
              curve: Curves.fastOutSlowIn,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isExpanded ? getBusExp() : const SizedBox(),
                  ],
                ),
              ),
            ),
            getExpAnalytics(),
            const SizedBox(height: 10.0,),
            const Text('Passenger Boarding Preference Percentage',style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 16.0
            ),textAlign: TextAlign.center,),
            const SizedBox(height: 10.0,),
            Center(
              child: Container(
                height: 300,
                width: 300,
                child: PieChart(
                  PieChartData(
                    sections: [
                      for(int i = 0;i < boardingMap.length;i++)
                        PieChartSectionData(
                            color: generateRandomColor(),
                            value: boardingMap.values.elementAt(i).toDouble(),
                            radius: 80,
                            title: boardingMap.keys.elementAt(i),
                            titleStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                            )
                        ),
                    ]
                  )
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            const Text('Passenger Dropping Preference Percentage',style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0,),
            Center(
              child: Container(
                height: 300,
                width: 300,
                child: PieChart(
                    PieChartData(
                        sections: [
                          for(int i = 0;i < droppingMap.length;i++)
                            PieChartSectionData(
                                color: generateRandomColor(),
                                value: droppingMap.values.elementAt(i).toDouble(),
                                radius: 80,
                                title: droppingMap.keys.elementAt(i),
                                titleStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                )
                            ),
                        ]
                    )
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }

  Color generateRandomColor() {
    Random random = Random();
    int r = random.nextInt(128) + 128; // Generates a random value between 0 and 255 for red
    int g = random.nextInt(128) + 128; // Generates a random value between 128 and 255 for green (lighter tones)
    int b = random.nextInt(128) + 128;  // Generates a random value between 0 and 255 for blue
    return Color.fromARGB(255, r, g, b); // Creates a color from the random values
  }
}

