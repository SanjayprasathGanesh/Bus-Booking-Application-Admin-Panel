import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redbus_admin/model/busModel.dart';
import 'package:redbus_admin/services/busService.dart';
import 'package:toast/toast.dart';

class UpdateBus extends StatefulWidget {
  String? id;
  UpdateBus({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateBus> createState() => _UpdateBusState();
}

class _UpdateBusState extends State<UpdateBus> {

  String selectedFrom = 'Coimbatore', selectedTo = 'Chennai',selectedType = 'Non AC-Semi Sleeper';

  BusService busService = BusService();

  String month = '';
  List<String> months = ['','January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];


  TextEditingController busNo = TextEditingController();
  TextEditingController busName = TextEditingController();
  TextEditingController ttlSeats = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController routes = TextEditingController();
  TextEditingController boarding = TextEditingController();
  TextEditingController dropping = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController driverName = TextEditingController();
  TextEditingController driverNo = TextEditingController();
  String bookedSeats = '';

  bool validateBusNo = false, validateBusName = false, validateSeats = false, validateStartDate = false, validateEndDate = false,
      validateStartTime = false, validateEndTime = false, validateDropping = false,
      validateFrom = false, validateTotalSeats = false, validateRoutes = false, validateBoarding = false, validatePrice = false,
      validateType = false, validateDriverName = false, validateDriverNo = false;

  @override
  initState(){
    super.initState();
    setBusDetails();
  }

  setBusDetails() async{
    DocumentSnapshot documentSnapshot = await busService.GetBusDetails(widget.id!);
    Map<String, dynamic> bus = documentSnapshot.data() as Map<String, dynamic>;
    setState(() {
      busNo.text = bus?['busNo'];
      busName.text = bus?['busName'];
      ttlSeats.text = bus!['ttlSeats'].toString();
      startDate.text = bus?['startDate'];
      endDate.text = bus?['endDate'];
      startTime.text = bus?['startTime'];
      endTime.text = bus?['endTime'];
      selectedFrom = bus?['from'];
      selectedTo = bus?['to'];
      routes.text = bus?['routes'];
      boarding.text = bus?['boarding'];
      dropping.text = bus?['dropping'];
      price.text = bus!['price'].toString();
      selectedType = bus?['type'];
      driverName.text = bus?['driverName'];
      driverNo.text = bus?['driverNo'];
      bookedSeats = bus?['bookedSeats'];
      month = bus?['month'];
    });
  }

  selectFromDate() async{
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 4)),
    );

    if(selected != null){
      setState(() {
        startDate.text = selected.toString().split(" ")[0];
        month = '${months[selected.month]},${selected.year}';
      });
    }
  }

  selectFromTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        int hr = picked.hour;
        int min = picked.minute;
        String s = "$hr : $min";
        startTime.text = s;
      });
    }
  }

  selectToTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        int hr = picked.hour;
        int min = picked.minute;
        String s = "$hr : $min";
        endTime.text = s;
      });
    }
  }

  selectToDate() async{
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 4)),
    );

    if(selected != null){
      setState(() {
        endDate.text = selected.toString().split(" ")[0];
      });
    }
  }

  selectFromLoc(){
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
            value: selectedFrom,
            onChanged: (String? newValue) {
              setState(() {
                selectedFrom = newValue!;
              });
            },
            isExpanded: true,
            items: <String>[
              'Coimbatore',
              'Chennai',
              'Bangalore',
              'Tenkasi',
              'Tirunelveli',
              'Kochi',
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

  selectToLoc(){
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
            value: selectedTo,
            onChanged: (String? newValue) {
              setState(() {
                selectedTo = newValue!;
              });
            },
            isExpanded: true,
            items: <String>[
              'Chennai',
              'Bangalore',
              'Tenkasi',
              'Tirunelveli',
              'Kochi',
              'Coimbatore',
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

  selectBusType(){
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
            value: selectedType,
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            isExpanded: true,
            items: <String>[
              'Non AC-Semi Sleeper',
              'AC-Semi Sleeper',
              'Non AC-Sleeper',
              'AC-Sleeper',
              'Non-AC Seater cum Sleeper',
              'AC Seater cum Sleeper',
              'AC-Seater Volvo Multi Axle',
              'AC-Sleeper Benz',
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
        title: const Text("Update Bus",style:
        TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway'
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter Bus Number',style: TextStyle(
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
                  errorText: validateBusNo ? 'Empty Bus Number Field' : null,
                ),
                controller: busNo,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter Bus Name',style: TextStyle(
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
                  errorText: validateBusName ? 'Empty Bus Name Field' : null,
                ),
                controller: busName,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter Total Seats',style: TextStyle(
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
                  errorText: validateTotalSeats ? 'Empty Total Seats Field' : null,
                ),
                controller: ttlSeats,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('Select the Start Date',style: TextStyle(
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
                        errorText: validateStartDate ? 'Empty Start Date Field' : null,
                      ),
                      controller: startDate,
                      readOnly: true,
                      onTap: (){
                        selectFromDate();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('Select the Start Time',style: TextStyle(
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
                        errorText: validateStartTime ? 'Empty Start Time Field' : null,
                      ),
                      controller: startTime,
                      readOnly: true,
                      onTap: (){
                        selectFromTime(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('Select the End Date',style: TextStyle(
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
                        errorText: validateEndDate ? 'Empty End Date Field' : null,
                      ),
                      controller: endDate,
                      readOnly: true,
                      onTap: (){
                        selectToDate();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('Select the End Time',style: TextStyle(
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
                        errorText: validateEndTime ? 'Empty End Time Field' : null,
                      ),
                      controller: endTime,
                      readOnly: true,
                      onTap: (){
                        selectToTime(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Select Your Start Location',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              const SizedBox(
                height: 5.0,
              ),
              selectFromLoc(),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Select Your To Location',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              const SizedBox(
                height: 5.0,
              ),
              selectToLoc(),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter the Routes',style: TextStyle(
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
                  errorText: validateRoutes ? 'Empty Routes Field' : null,
                ),
                controller: routes,
                keyboardType: TextInputType.text,
                maxLines: 4,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter the Boarding Points',style: TextStyle(
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
                  errorText: validateBoarding ? 'Empty Boarding Point Field' : null,
                ),
                controller: boarding,
                keyboardType: TextInputType.text,
                maxLines: 4,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter the Dropping Points',style: TextStyle(
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
                  errorText: validateDropping ? 'Empty Dropping Point Field' : null,
                ),
                controller: dropping,
                keyboardType: TextInputType.text,
                maxLines: 4,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter the Ticket Price',style: TextStyle(
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
                  errorText: validatePrice ? 'Empty Ticket Price Field' : null,
                ),
                controller: price,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Select the Bus Type',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                fontSize: 15.0,
              ),),
              const SizedBox(
                height: 5.0,
              ),
              selectBusType(),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter the Driver Name',style: TextStyle(
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
                  errorText: validateDriverName ? 'Empty Driver Name Field' : null,
                ),
                controller: driverName,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text('Enter the Driver Phone Number',style: TextStyle(
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
                  errorText: validateDriverNo ? 'Empty Driver Phone Number Field' : null,
                ),
                controller: driverNo,
                keyboardType: TextInputType.phone,
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
                          busNo.clear();
                          busName.clear();
                          ttlSeats.clear();
                          startDate.clear();
                          startTime.clear();
                          endTime.clear();
                          endDate.clear();
                          from.clear();
                          to.clear();
                          routes.clear();
                          boarding.clear();
                          dropping.clear();
                          price.clear();
                          type.clear();
                          driverName.clear();
                          driverNo.clear();
                        });
                      },
                      child: const Text('Clear',style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gabarito',
                        // fontWeight: FontWeight.bold,
                      ),)
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async{
                        ToastContext().init(context);
                        setState(() {
                          validateBusNo = busNo.text.isEmpty;
                          validateBusName = busName.text.isEmpty;
                          validateTotalSeats = ttlSeats.text.isEmpty;
                          validateStartDate = startDate.text.isEmpty;
                          validateEndDate = endDate.text.isEmpty;
                          validateStartTime = startTime.text.isEmpty;
                          validateEndTime = endTime.text.isEmpty;
                          validateFrom = selectedFrom.isEmpty;
                          validateRoutes = routes.text.isEmpty;
                          validateBoarding = boarding.text.isEmpty;
                          validateDropping = dropping.text.isEmpty;
                          validatePrice = price.text.isEmpty;
                          validateType = selectedType.isEmpty;
                          validateDriverName = driverName.text.isEmpty;
                          validateDriverNo = driverNo.text.isEmpty;
                        });
                        if(!validateBusNo && !validateBusName && !validateTotalSeats && !validateStartDate && !validateEndDate && !validateStartTime && !validateEndTime && !validateFrom && !validateRoutes && !validateBoarding && !validateDropping && !validatePrice && !validateType && !validateDriverName && !validateDriverNo){
                          if(selectedFrom != selectedTo){
                            var busModel = BusModel();
                            busModel.busNo = busNo.text;
                            busModel.busName = busName.text;
                            busModel.ttlSeats = int.parse(ttlSeats.text);
                            busModel.startDate = startDate.text;
                            busModel.endDate = endDate.text;
                            busModel.startTime = startTime.text;
                            busModel.endTime = endTime.text;
                            busModel.from = selectedFrom;
                            busModel.to = selectedTo;
                            busModel.routes = routes.text.toString();
                            busModel.boarding = boarding.text;
                            busModel.dropping = dropping.text;
                            busModel.price = int.parse(price.text);
                            busModel.type = selectedType;
                            busModel.bookedSeats = bookedSeats;
                            busModel.month = month;
                            busModel.driverName = driverName.text;
                            busModel.driverNo = driverNo.text;

                            var result = await busService.UpdateBus(busModel, widget.id!);

                            if(result == null){
                              Toast.show(
                                'Bus Updated Successfully',
                                duration: 3,
                                backgroundColor: Colors.green,
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                ),
                                gravity: Toast.bottom,
                              );
                              Navigator.pop(context);
                            }
                            else{
                              Toast.show(
                                'OOPS, bus Not Updated',
                                duration: 3,
                                backgroundColor: Colors.red,
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Raleway',
                                ),
                                gravity: Toast.bottom,
                              );
                            }
                          }
                          else{
                            Toast.show(
                              'From and To Location are same!!',
                              duration: 3,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
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
                              color: Colors.black,
                              fontFamily: 'Raleway',
                            ),
                            gravity: Toast.bottom,
                          );
                        }
                      },
                      child: const Text('Update',style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gabarito',
                        // fontWeight: FontWeight.bold,
                      ),)
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
