import 'package:flutter/material.dart' show AppBar, BuildContext, Column, CrossAxisAlignment, Divider, EdgeInsets, ElevatedButton, Expanded, FontWeight, InputDecoration, Key, ListView, MaterialApp, OutlineInputBorder, Padding, Scaffold, ScaffoldMessenger, SizedBox, SnackBar, State, StatefulWidget, Text, TextEditingController, TextFormField, TextStyle, ThemeData, Widget;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_wallet/client/base_client.dart';

class diskUtilization extends StatefulWidget {
  const diskUtilization({Key? key}) : super(key: key);

  @override
  State<diskUtilization> createState() => _diskUtilizationState();
}

class _diskUtilizationState extends State<diskUtilization> {

  TextEditingController computerNameController = TextEditingController();
  bool isButtonEnabled = false;
  final String serverUrl = 'http://192.168.56.1:8090';

  void validateInput() {
    if (isButtonEnabled) {
      //"MSI,DESKTOP-UQR19D0","wuauserv,Spooler"
      sendHttpRequest(computerNameController.text);
    }else{
      const snackBar = SnackBar(
        content: Text('Enter the computer and service names'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  var DiskManager = [];
  Future<void> sendHttpRequest(String compterNames) async {
    final url = Uri.parse('$serverUrl/Philips/IBE/DiskUtilization?IP=$compterNames'); // Replace with your desired endpoint
    final response = await http.get(url);
    if (response.statusCode == 200) {
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
      print(jsonData.runtimeType);
      if(jsonData.runtimeType.toString() == "_InternalLinkedHashMap<String, dynamic>"){
        Map<String, dynamic> jsonData = json.decode(jsonString);
        List<DiskAndCPU> remoteComputers = [];
        String computerName="", Disk="", CPU="";
        List allValues = [];
        jsonData.forEach((key, value) {
          print(key.toString()+"   " +value.toString());
          if(key == "ComputerName"){
            computerName = value;
            allValues.add(value.toString());
          }else if( key == "DiskUsage"){
            Disk = value.toString();
            allValues.add(value.toString());
          }
          else if(key =="CPUusage"){
            CPU = value.toString();
            allValues.add(value.toString());
          }
        });
        for(int i =0;i<allValues.length/3;i++){
          remoteComputers.add(DiskAndCPU(allValues[0+i], allValues[1+i], allValues[2+i],));
        }
        DiskManager = remoteComputers;
        DiskManager.forEach((computer) {
          print('Computer name: ${computer.name}');
          print('Disk: ${computer.Disk}');
          print('CPU: ${computer.CPU}');
        });
      }else{
        List<DiskAndCPU> remoteComputer = [];
        String computerName="", Disk="", CPU="";
        List allValues = [];
        for(int i = 0;i<jsonData.length;i++){
          jsonData[i].forEach((key, value) {
            print(key.toString()+"   " +value.toString());
            if(key == "ComputerName"){
              computerName = value;
              allValues.add(value.toString());
            }else if( key == "Disk" || key == "DiskUsage"){
              Disk = value.toString();
              allValues.add(value.toString());
            }
            else if(key =="CPU" || key =="CPUusage"){
              CPU = value.toString();
              allValues.add(value.toString());
            }
          });

        }
        print(allValues);
        for(int i =0;i<allValues.length;i+=3){
          remoteComputer.add(DiskAndCPU(allValues[0+i], allValues[1+i], allValues[2+i],));
        }
        DiskManager = remoteComputer;
        DiskManager.forEach((computer) {
          print('Computer name: ${computer.name}');
          print('Disk: ${computer.Disk}');
          print('CPU: ${computer.CPU}');
        });
      }
      setState(() { });
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
          title: Text('Disk and CPU Utilization'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => {
                  if (computerNameController.text.isNotEmpty )
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
              ElevatedButton(

                onPressed: validateInput,
                child: Text('Validate'),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: DiskManager.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          'Computer name: ${DiskManager[index].name}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),
                        SizedBox(height: 8.0),
                        Text(DiskManager[index].CPU.length>5?'Disk Utilization: ${DiskManager[index].CPU}':
                            'Disk Utilization: ${DiskManager[index].CPU}%',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Text(DiskManager[index].CPU.length>5?'CPU Utilization: ${DiskManager[index].Disk}':
                        'CPU Utilization: ${DiskManager[index].Disk}%',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
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
