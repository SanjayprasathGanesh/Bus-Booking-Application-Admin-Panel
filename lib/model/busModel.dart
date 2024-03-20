class BusModel{
  String? busNo;
  String? busName;
  int? ttlSeats;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? from;
  String? to;
  String? routes;
  String? boarding;
  String? dropping;
  int? price;
  String? type;
  String? bookedSeats;
  String? month;
  String? driverName;
  String? driverNo;

  busMap(){
    var mapping = Map<String, dynamic>();
    mapping['busNo'] = busNo!;
    mapping['busName'] = busName!;
    mapping['ttlSeats'] = ttlSeats!;
    mapping['startDate'] = startDate!;
    mapping['endDate'] = endDate!;
    mapping['startTime'] = startTime!;
    mapping['endTime'] = endTime!;
    mapping['from'] = from!;
    mapping['to'] = to!;
    mapping['routes'] = routes!;
    mapping['boarding'] = boarding!;
    mapping['dropping'] = dropping!;
    mapping['price'] = price!;
    mapping['type'] = type!;
    mapping['bookedSeats'] = bookedSeats!;
    mapping['month'] = month!;
    mapping['driverName'] = driverName!;
    mapping['driverNo'] = driverNo!;
    return mapping;
  }
}