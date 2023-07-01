import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_wallet/client/base_client.dart';
import 'dart:convert';
import 'package:my_wallet/tasks/ServiceCheck.dart';

class requestSender extends StatefulWidget {
  const requestSender({Key? key}) : super(key: key);

  @override
  State<requestSender> createState() => _requestSenderState();
}

class _requestSenderState extends State<requestSender> {

  final String serverUrl = 'http://192.168.56.1:8090'; // Replace with your server URL

  // Future<void> sendHttpRequest(String compterNames,String serviceNames) async {
  //   final url = Uri.parse('$serverUrl/Philips/IBE/HealthCheck?IP=$compterNames&Services=$serviceNames'); // Replace with your desired endpoint
  //
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     print('Response body: ${response.body}');
  //     String input =response.body.toString();
  //     // Remove newlines and whitespace
  //     String JsonEncoded = "";
  //     for(var i = 1; i<input.length-1;i++){
  //       if(input[i] == "\\" && input[i+1] == "n"){
  //         i+=1;
  //       }
  //       else if(input[i]=="\\") {
  //
  //       }
  //       else{
  //         JsonEncoded+=input[i];
  //       }
  //     }
  //     String jsonString =JsonEncoded;
  //         //'{"MSI": ["@{ServiceName=wuauserv; Status=Running}","@{ServiceName=Spooler; Status=Running}"],"Dell": ["@{ServiceName=wuauserv; Status=Running}","@{ServiceName=Spooler; Status=Running}"]}';
  //
  //     Map<String, dynamic> jsonData = json.decode(jsonString);
  //
  //     List<Computer> computers = [];
  //
  //     jsonData.forEach((computerName, services) {
  //       List<Service> parsedServices = [];
  //
  //       services.forEach((serviceString) {
  //         String serviceName = serviceString.split(';')[0].split('=')[1].trim();
  //         String serviceStatus = serviceString.split(';')[1].split('=')[1].trim();
  //
  //         parsedServices.add(Service(serviceName, serviceStatus));
  //       });
  //
  //       computers.add(Computer(computerName, parsedServices));
  //     });
  //
  //     print('Number of computers: ${computers.length}');
  //     print('');
  //
  //     computers.forEach((computer) {
  //       print('Computer name: ${computer.name}');
  //       computer.services.forEach((service) {
  //         print('Service name: ${service.name}');
  //         print('Service status: ${service.status.substring(0,service.status.length-1)}');
  //         print('');
  //       });
  //     });
  //
  //
  // } else {
  //     print('Request failed with status code: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Control Center'),
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(Icons.storage, 'Disk Utilization'),
                    _buildIconButton(Icons.check, 'Service Check'),
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(Icons.settings, 'Service Control'),
                    _buildIconButton(Icons.monitor, 'Service Monitor'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  Widget _buildIconButton(IconData icon, String label) {
    return Container(
      width: 160.0,
      height: 160.0,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: MaterialButton(
        onPressed: (){
        if(label == "Service Check"){
          Navigator.push(context, MaterialPageRoute( builder: (context) =>const serviceChecker()));

        }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.white,
            ),
            SizedBox(height: 16.0),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // Container buildButton(BuildContext context, String name, Color color, String imgPath) {
  //   return Container(
  //               padding:const EdgeInsets.symmetric(vertical: 5),
  //               width: MediaQuery.of(context).size.width/2.3,
  //               height: MediaQuery.of(context).size.width / 2.5,
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.white24),
  //                   borderRadius: BorderRadius.circular(12),
  //                   color:color
  //               ),
  //               child: MaterialButton(
  //                 onPressed: (){
  //                   if(name == "Disk Utilization"){}else if(name == "Service Check"){
  //                     Navigator.push(context, MaterialPageRoute( builder: (context) =>const serviceChecker()));
  //                   }
  //
  //                 },
  //                 child: Column(
  //                   children: [
  //                     Text(name,
  //                         style: const TextStyle(
  //                             fontWeight: FontWeight.w400,
  //                             color: Colors.white,
  //                             fontSize: 18),
  //                     ),
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/2.3,
  //                       height: MediaQuery.of(context).size.width / 3.8,
  //                       margin: EdgeInsets.symmetric(vertical: 3),
  //                       decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                           image: AssetImage(imgPath),
  //                           //colorFilter: ColorFilter.mode(Colors.grey,BlendMode.exclusion)
  //                         )
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  // }

