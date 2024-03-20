class BusExpModel{
  String? busId;
  int? ttlKm;
  int? ttlLitres;
  int? ttlPrice;
  int? mileage;
  String? driverName;
  int? driverSal;

  bool? isDamaged;
  String? damageName;
  int? damageAmt;
  bool? isServiced;

  bool? isFined;
  String? fineName;
  int? fineAmt;
  bool? isPaid;

  int? ttlSeats;
  int? bookedSeats;
  int? ticPrice;
  int? estPrice; // Estimated Price
  int? ttlBusExp;
  int? resultPrice;
  int? balance;
  String? status;


  busExpMap(){
    var mapping = <String, dynamic>{};
    mapping['busId'] = busId!;
    mapping['ttlKm'] = ttlKm!;
    mapping['ttlLitres'] = ttlLitres!;
    mapping['ttlPrice'] = ttlPrice!;
    mapping['mileage'] = mileage!;
    mapping['driverName'] = driverName!;
    mapping['driverSal'] = driverSal!;
    mapping['isDamaged'] = isDamaged!;
    mapping['damageName'] = damageName!;
    mapping['damageAmt'] = damageAmt!;
    mapping['isServiced'] = isServiced!;
    mapping['fined'] = isFined!;
    mapping['fineName'] = fineName!;
    mapping['fineAmt'] = fineAmt!;
    mapping['isPaid'] = isPaid!;
    mapping['ttlSeats'] = ttlSeats!;
    mapping['bookedSeats'] = bookedSeats!;
    mapping['ticPrice'] = ticPrice!;
    mapping['estPrice'] = estPrice!;
    mapping['ttlBusExp'] = ttlBusExp!;
    mapping['resultPrice'] = resultPrice!;
    mapping['balance'] = balance!;
    mapping['status'] = status!;
    return mapping;
  }
}