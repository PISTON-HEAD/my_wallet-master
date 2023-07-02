import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.1.100:8080';
class BaseClients {

  var client = http.Client();
  Future<dynamic> get(String api)async{
    var url = Uri.parse(baseUrl+api);
    var response = await client.get(url);
    if(response.statusCode  == 200){
      return response.body;
    }else{
      //exception
      print("Error");
    }

  }

}

class Computer {
  String name;
  List<Service> services;

  Computer(this.name, this.services);
}

class Service {
  String name;
  String status;

  Service(this.name, this.status);
}

class serviceControl{

  String name;
  String service;
  String status;
  String action;

  serviceControl(this.name,this.service,this.status,this.action);
}
