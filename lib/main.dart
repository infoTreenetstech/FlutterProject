import 'dart:convert';
import 'dart:js';

import 'package:first_app/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _designation = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Define your API endpoint URL
      // final String apiUrl = ApiConstants.baseUrl+"/"; // Replace with your API URL
     
      final Map<String, dynamic> data = {
        'firstName': _firstName.text,
        'lastName': _lastName.text,
        'department': _designation.text,
      };

      // Convert the data to JSON
      final String jsonBody = json.encode(data);

      // Send the POST request
      String apiUrl = "${ApiConstants.baseUrl}/";
      Uri? parsedUri = Uri.tryParse(apiUrl);

      if (parsedUri != null) {
        final response = await http.post(
          parsedUri,
          headers: {
            'Content-Type': 'application/json', // Set the content type to JSON
          },
          body: jsonBody,
        );
        if (response.statusCode == 200) {
          Navigator.push(context as BuildContext, MaterialPageRoute(builder: (context) =>MyForm()));
        } else {
          // Handle error or failure response from the API
          print('Failed to send data. Status code:');
        } // Handle the response as needed
      } else {
        // Handle the case where the URL is invalid
        print("Invalid URL: $apiUrl");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Data Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter First Name';
                  }
                  // firstName.value;
                  return null;
                },
              ),
              TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Last Name';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: _designation,
                  decoration: InputDecoration(labelText: 'Designation'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Designation';
                    }
                    return null;
                  }),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
