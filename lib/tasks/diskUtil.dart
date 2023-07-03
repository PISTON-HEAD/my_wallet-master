import 'package:flutter/material.dart' show AppBar, BuildContext, Column, CrossAxisAlignment, Divider, EdgeInsets, ElevatedButton, Expanded, FontWeight, InputDecoration, Key, ListView, MaterialApp, OutlineInputBorder, Padding, Scaffold, ScaffoldMessenger, SizedBox, SnackBar, State, StatefulWidget, Text, TextEditingController, TextFormField, TextStyle, ThemeData, Widget;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> sendHttpRequest(String compterNames) async {
    final url = Uri.parse('$serverUrl/Philips/IBE/DiskUtilization?IP=$compterNames'); // Replace with your desired endpoint
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
      print(jsonData);
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
                  itemCount: 0,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Computer name:',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),
                        SizedBox(height: 8.0),
                        Text(
                            'Disk Utilization: ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
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
