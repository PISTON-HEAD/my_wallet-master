import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../client/base_client.dart';
class serviceController extends StatefulWidget {
  const serviceController({Key? key}) : super(key: key);

  @override
  State<serviceController> createState() => _serviceControllerState();
}

class _serviceControllerState extends State<serviceController> {
  TextEditingController computerNameController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  bool isButtonEnabled = false;
  final String serverUrl = 'http://192.168.56.1:8090'; // Replace with your server URL

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
  var controlManager = [];
  Future<void> sendHttpRequest(String compterNames,String serviceNames) async {
    final url = Uri.parse('$serverUrl/Philips/IBE/ServiceControl?IP=$compterNames&Services=$serviceNames'); // Replace with your desired endpoint

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      String input =response.body.toString();
      // Remove newlines and whitespace
      String JsonEncoded = "";
      for(var i = 1; i<input.length-1;i++){
        if(input[i] == "\\" && input[i+1] == "n"){
          i+=1;
        }
        else if(input[i]=="\\") {

        }
        else{
          JsonEncoded+=input[i];
        }
      }
      String jsonString =JsonEncoded;
      var jsonData = json.decode(jsonString);
      if(jsonData.runtimeType.toString() == "_InternalLinkedHashMap<String, dynamic>"){
        Map<String, dynamic> jsonData = json.decode(jsonString);
        List<serviceControl> computers = [];
        String computerName="", ServiceName="", Status="",Action="";
        List allValues = [];
        jsonData.forEach((key, value) {
          print(key.toString()+"   " +value);
          if(key == "ComputerName"){
            computerName = value;
            allValues.add(value);
          }else if( key == "ServiceName"){
            ServiceName = value;
            allValues.add(value);
          }
          else if(key =="Status"){
            Status = value;
            allValues.add(value);
          }else if(key == "Action"){
            Action = value;
            allValues.add(value);
          }
        });
        for(int i =0;i<allValues.length/4;i++){
          computers.add(serviceControl(allValues[0+i], allValues[1+i], allValues[2+i], allValues[3+i]));
        }

        controlManager = computers;
        controlManager.forEach((computer) {
          print('Computer name: ${computer.name}');
          print('Computer name: ${computer.service}');
          print('Computer name: ${computer.status}');
          print('Computer name: ${computer.action}');
        });
        setState(() { });
      }else{
        print(jsonData);

        List<serviceControl> computers = [];
        String computerName="", ServiceName="", Status="",Action="";
        List allValues = [];
        for(int i = 0;i<jsonData.length;i++){
          jsonData[i].forEach((key, value) {
            print(key.toString()+"   " +value);
            if(key == "ComputerName"){
              computerName = value;
              allValues.add(value);
            }else if( key == "ServiceName"){
              ServiceName = value;
              allValues.add(value);
            }
            else if(key =="Status"){
              Status = value;
              allValues.add(value);
            }else if(key == "Action"){
              Action = value;
              allValues.add(value);
            }
          });

        }
        print(allValues);
        for(int i =0;i<allValues.length;i+=4){
          computers.add(serviceControl(allValues[i], allValues[i+1], allValues[i+2], allValues[i+3]));
        }
        controlManager = computers;
        controlManager.forEach((computer) {
          print('Computer name: ${computer.name}');
          print('Service name: ${computer.service}');
          print('Status: ${computer.status}');
          print('Action: ${computer.action}');
        });
        setState(() { });
      }
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }








  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Service Control Management'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
                onChanged: (value) => {
                  if (computerNameController.text.isNotEmpty &&
                      serviceNameController.text.isNotEmpty)
                    {
                      isButtonEnabled = true,
                      print(isButtonEnabled),
                    }
                },
                controller: serviceNameController,
                decoration: InputDecoration(
                  labelText: 'Enter service name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(

                onPressed: validateInput,
                child: Text('Validate'),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: controlManager.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Computer name: ${controlManager[index].name}'),
                        SizedBox(height: 8.0),
                        Text(
                            'Service Name: ${controlManager[index].service}'),
                        SizedBox(height: 8.0),
                        Text('Status: ${controlManager[index].status}'),
                        SizedBox(height: 8.0),
                        Text('Action: ${controlManager[index].action}'),
                        SizedBox(height: 16.0),
                        Divider(thickness: 1.5,),
                        SizedBox(height: 16.0),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

