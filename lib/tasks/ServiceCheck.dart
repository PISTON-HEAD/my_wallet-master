import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_wallet/client/base_client.dart';
import 'dart:convert';

class serviceChecker extends StatefulWidget {
  const serviceChecker({Key? key}) : super(key: key);

  @override
  State<serviceChecker> createState() => _serviceCheckerState();
}

class _serviceCheckerState extends State<serviceChecker> {
  TextEditingController computerNameController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  bool isButtonEnabled = false;

  final String serverUrl =
      'http://192.168.56.1:8090'; // Replace with your server URL
  var myComputers = [];
  Future<void> sendHttpRequest(String compterNames, String serviceNames) async {
    final url = Uri.parse(
        '$serverUrl/Philips/IBE/HealthCheck?IP=$compterNames&Services=$serviceNames'); // Replace with your desired endpoint

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      String input = response.body.toString();
      // Remove newlines and whitespace
      String JsonEncoded = "";
      for (var i = 1; i < input.length - 1; i++) {
        if (input[i] == "\\" && input[i + 1] == "n") {
          i += 1;
        } else if (input[i] == "\\") {
        } else {
          JsonEncoded += input[i];
        }
      }
      String jsonString = JsonEncoded;
      //'{"MSI": ["@{ServiceName=wuauserv; Status=Running}","@{ServiceName=Spooler; Status=Running}"],"Dell": ["@{ServiceName=wuauserv; Status=Running}","@{ServiceName=Spooler; Status=Running}"]}';

      Map<String, dynamic> jsonData = json.decode(jsonString);

      List<Computer> computers = [];

      jsonData.forEach((computerName, services) {
        List<Service> parsedServices = [];

        services.forEach((serviceString) {
          String serviceName = serviceString.split(';')[0].split('=')[1].trim();
          String serviceStatus =
              serviceString.split(';')[1].split('=')[1].trim();

          parsedServices.add(Service(serviceName, serviceStatus));
        });

        computers.add(Computer(computerName, parsedServices));
      });

      print('Number of computers: ${computers.length}');
      print('');
       myComputers = computers;
      computers.forEach((computer) {
        print('Computer name: ${computer.name}');
        computer.services.forEach((service) {
          print('Service name: ${service.name}');
          print(
              'Service status: ${service.status.substring(0, service.status.length - 1)}');
          print('');
        });
      });
      setState(() { });
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    computerNameController.dispose();
    serviceNameController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  void validateInput() {
    if (isButtonEnabled) {
      //"MSI,DESKTOP-UQR19D0","wuauserv,Spooler"
      sendHttpRequest(computerNameController.text, serviceNameController.text);
    }else{
      const snackBar = SnackBar(
        content: Text('Enter the computer and service names'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Service Check Manager'),
        ),
        body:Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onChanged: (value) => {
                    if (computerNameController.text.isNotEmpty &&
                        serviceNameController.text.isNotEmpty)
                      {
                        isButtonEnabled = true,
                        print(isButtonEnabled),
                      }
                  },
                  controller: computerNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter computer name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: serviceNameController,
                  onChanged: (value) => {
                    if (computerNameController.text.isNotEmpty &&
                        serviceNameController.text.isNotEmpty)
                      {
                        isButtonEnabled = true,
                        print(isButtonEnabled),
                      }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter service name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: validateInput,
                  child: Text('Get Information'),
                ),
                SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: myComputers.length,
                  itemBuilder: (context, outerIndex) {
                    return ListTile(
                      title: Text(
                        'Computer name: ${myComputers[outerIndex].name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: myComputers[outerIndex].services.length,
                        itemBuilder: (context, innerIndex) {
                          return ListTile(
                            title: Text(
                              'Service name: ${myComputers[outerIndex].services[innerIndex].name}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {},
                            subtitle: Text(
                              'Service Status: ${myComputers[outerIndex].services[innerIndex].status.toString().substring(0, myComputers[outerIndex].services[innerIndex].status.toString().length - 1)}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
