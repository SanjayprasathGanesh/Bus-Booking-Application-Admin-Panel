import 'package:redbus_admin/database/databaseConnection.dart';
import 'package:redbus_admin/model/busModel.dart';

class BusService{
  late DatabaseConnection _databaseConnection;

  BusService(){
    _databaseConnection = DatabaseConnection();
  }

  AddBus(BusModel busModel) async{
    return await _databaseConnection.addBus(busModel.busMap());
  }

  ReadBus(String date) async{
    return await _databaseConnection.readBus(date);
  }

  UpdateBus(BusModel busModel, String id) async{
    return await _databaseConnection.updateBus(id, busModel);
  }

  DeleteBus(String id) async{
    return await _databaseConnection.deleteBus(id);
  }

  GetBusDetails(String id) async{
    return await _databaseConnection.getBusDetails(id);
  }
}