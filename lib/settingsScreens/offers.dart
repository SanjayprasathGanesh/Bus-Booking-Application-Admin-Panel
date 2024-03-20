import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:toast/toast.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {

  TextEditingController offName = TextEditingController();
  TextEditingController offCode = TextEditingController();
  TextEditingController offFrom = TextEditingController();
  TextEditingController offTo = TextEditingController();
  TextEditingController discountPrice = TextEditingController();

  bool validateName = false, validateCode = false, validateFrom = false, validateTo = false, validatePrice = false;
  DatabaseConnection databaseConnection = DatabaseConnection();

  TextEditingController uOffName = TextEditingController();
  TextEditingController uOffCode = TextEditingController();
  TextEditingController uOffFrom = TextEditingController();
  TextEditingController uOffTo = TextEditingController();
  TextEditingController uDiscountPrice = TextEditingController();

  bool uValidateName = false, uValidateCode = false, uValidateFrom = false, uValidateTo = false, uValidatePrice = false;

  selectFrom() async{
    DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 50))
    );

    if(selected != null){
      setState(() {
        offFrom.text = selected.toString().split(" ")[0];
      });
    }
  }

  selectTo() async{
    DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 60))
    );

    if(selected != null){
      setState(() {
        offTo.text = selected.toString().split(" ")[0];
      });
    }
  }

  updateFrom() async{
    DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 50))
    );

    if(selected != null){
      setState(() {
        uOffFrom.text = selected.toString().split(" ")[0];
      });
    }
  }

  updateTo() async{
    DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 60))
    );

    if(selected != null){
      setState(() {
        uOffTo.text = selected.toString().split(" ")[0];
      });
    }
  }

  addNewOffer(){
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )
        ),
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 800,
            width: double.infinity,
            margin: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Add New Offer',style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),),
                    trailing: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.clear_outlined,color: Colors.black,)
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Offer Name',style: TextStyle(
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
                      // errorText: validateName ? 'Empty Offer Name Field' : null,
                    ),
                    controller: offName,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Offer Code',style: TextStyle(
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
                      // errorText: validateCode ? 'Empty Offer Code Field' : null,
                    ),
                    controller: offCode,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              label: const Text('Enter Offer Start Date',style: TextStyle(
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
                              // errorText: validateFrom ? 'Empty Offer Start Date Field' : null,
                            ),
                            controller: offFrom,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            onTap: (){
                              selectFrom();
                            },
                          ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Enter Offer End Date',style: TextStyle(
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
                            // errorText: validateTo ? 'Empty Offer End Date Field' : null,
                          ),
                          controller: offTo,
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: (){
                            selectTo();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Offer Discount Price',style: TextStyle(
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
                      // errorText: validatePrice ? 'Empty Offer Discount Price' : null,
                    ),
                    controller: discountPrice,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: (){
                          setState(() {
                            offName.clear();
                            offCode.clear();
                            offFrom.clear();
                            offTo.clear();
                            discountPrice.clear();
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
                            validateName = offName.text.isEmpty;
                            validateCode = offCode.text.isEmpty;
                            validateFrom = offFrom.text.isEmpty;
                            validateTo = offTo.text.isEmpty;
                            validatePrice = discountPrice.text.isEmpty;
                          });
                          if(!validateName && !validateCode && !validateFrom && !validateTo && !validatePrice){
                            if(!validateName && !validateCode && !validateFrom && !validateTo && !validatePrice){

                              OfferModel om = OfferModel();
                              om.offerName = offName.text;
                              om.offerCode = offCode.text;
                              om.validFrom = offFrom.text;
                              om.validTo = offTo.text;
                              om.discountPrice = int.parse(discountPrice.text);
                              om.isExpired = false;

                              databaseConnection.addOffer(om);
                              Toast.show(
                                'New Offer Added Successfully',
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
                        child: const Text('Add Offer',style: TextStyle(
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
          );
        }
    );
  }

  updateOffer(OfferModel ofm, String id){
    setState(() {
      uOffName.text = ofm.offerName!;
      uOffCode.text = ofm.offerCode!;
      uOffFrom.text = ofm.validFrom!;
      uOffTo.text = ofm.validTo!;
      uDiscountPrice.text = ofm.discountPrice!.toString();
    });
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )
        ),
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 800,
            width: double.infinity,
            margin: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Update Offer',style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),),
                    trailing: TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.clear_outlined,color: Colors.black,)
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Offer Name',style: TextStyle(
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
                      // errorText: validateName ? 'Empty Offer Name Field' : null,
                    ),
                    controller: uOffName,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Offer Code',style: TextStyle(
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
                      // errorText: validateCode ? 'Empty Offer Code Field' : null,
                    ),
                    controller: uOffCode,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Enter Offer Start Date',style: TextStyle(
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
                            // errorText: validateFrom ? 'Empty Offer Start Date Field' : null,
                          ),
                          controller: uOffFrom,
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: (){
                            updateFrom();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Enter Offer End Date',style: TextStyle(
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
                            // errorText: validateTo ? 'Empty Offer End Date Field' : null,
                          ),
                          controller: uOffTo,
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          onTap: (){
                            updateTo();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: const Text('Enter Offer Discount Price',style: TextStyle(
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
                      // errorText: validatePrice ? 'Empty Offer Discount Price' : null,
                    ),
                    controller: uDiscountPrice,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: (){
                          setState(() {
                            uOffName.clear();
                            uOffCode.clear();
                            uOffFrom.clear();
                            uOffTo.clear();
                            uDiscountPrice.clear();
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
                            uValidateName = uOffName.text.isEmpty;
                            uValidateCode = uOffCode.text.isEmpty;
                            uValidateFrom = uOffFrom.text.isEmpty;
                            uValidateTo = uOffTo.text.isEmpty;
                            uValidatePrice = uDiscountPrice.text.isEmpty;
                          });
                          if(!uValidateName && !uValidateCode && !uValidateFrom && !uValidateTo && !uValidatePrice){
                            if(!uValidateName && !uValidateCode && !uValidateFrom && !uValidateTo && !uValidatePrice){

                              OfferModel om = OfferModel();
                              om.offerName = uOffName.text;
                              om.offerCode = uOffCode.text;
                              om.validFrom = uOffFrom.text;
                              om.validTo = uOffTo.text;
                              om.discountPrice = int.parse(uDiscountPrice.text);
                              om.isExpired = ofm.isExpired!;

                              databaseConnection.updateOffer(id, om);
                              Toast.show(
                                'Offer Updated Successfully',
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
                        child: const Text('Update Offer',style: TextStyle(
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
          );
        }
    );
  }

  List<OfferModel> offerList = <OfferModel>[];
  List<String> offerIds = <String>[];
  bool isLoaded = false;

  getAllOffers() async{
    QuerySnapshot querySnapshot = await databaseConnection.getAllOffers();
    List<OfferModel> tempList = [];
    List<String> tempIds = [];
    for(int i = 0;i < querySnapshot.docs.length;i++){
      Map<String, dynamic> map = querySnapshot.docs[i].data() as Map<String, dynamic>;
      OfferModel offerModel = OfferModel();
      offerModel.offerName = map['offerName'];
      offerModel.offerCode = map['offerCode'];
      offerModel.validFrom = map['validFrom'];
      offerModel.validTo = map['validTo'];
      offerModel.discountPrice = map['discountPrice'];
      offerModel.isExpired = map['isExpired'];
      tempList.add(offerModel);
      tempIds.add(querySnapshot.docs[i].id);
    }

    setState(() {
      offerList = tempList;
      offerIds = tempIds;
      isLoaded = true;
    });
  }

  bool isCopied = false;

  void copyToClipboard(String promoCode) {
    Clipboard.setData(ClipboardData(text: promoCode));
    setState(() {
      isCopied = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOffers();
  }

  @override
  Widget build(BuildContext context) {
    getAllOffers();

    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Offers",
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
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Offer',
          onPressed: (){
            addNewOffer();
            setState(() {
              getAllOffers();
            });
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    if (isLoaded && offerList.isEmpty) {
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
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/noOffers.png'),
                  fit: BoxFit.fitHeight,
                  filterQuality: FilterQuality.high,
                )
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Offer',
          onPressed: (){
            addNewOffer();
            setState(() {
              getAllOffers();
            });
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Offers",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 700,
          margin: const EdgeInsets.all(10.0),
          child: ListView.builder(
              itemCount: offerList.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Valid Between ${offerList[index].validFrom} - ${offerList[index].validTo}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Promo Name: ${offerList[index].offerName}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Promo Code: ${offerList[index].offerCode}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: 'Raleway',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black
                              ),
                              onPressed: (){
                                isCopied ? null : copyToClipboard(offerList[index].offerCode!);
                              },
                              child: Text(isCopied ? 'Copied!' : 'Copy Promo Code'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: (){
                                      updateOffer(offerList[index], offerIds[index]);
                                      getAllOffers();
                                    },
                                    icon: const Icon(Icons.edit_calendar, color: Colors.green,size: 35.0,)
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                IconButton(
                                    onPressed: (){
                                      deleteOffer(context, offerIds[index]);
                                      getAllOffers();
                                    },
                                    icon: const Icon(Icons.delete_outline, color: Colors.red,size: 35.0,)
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Offer',
        onPressed: (){
          addNewOffer();
          setState(() {
            getAllOffers();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  deleteOffer(BuildContext context, String id){
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Do You want to Delete this Offer',
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
                    databaseConnection.deleteOffer(id);
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

class OfferModel{
  String? offerName;
  String? offerCode;
  String? validFrom;
  String? validTo;
  int? discountPrice;
  bool? isExpired;

  offerMap(){
    var map = <String, dynamic>{};
    map['offerName'] = offerName;
    map['offerCode'] = offerCode;
    map['validFrom'] = validFrom;
    map['validTo'] = validTo;
    map['discountPrice'] = discountPrice;
    map['isExpired'] = isExpired;
    return map;
  }
}
