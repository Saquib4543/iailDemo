import 'package:damagedetection1/otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Damage detection',
      theme: ThemeData(
        primaryColor: Color(0xFF00008B),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFF00008B, {
            50: Color(0xFFE6E6FA),
            100: Color(0xFFCDCDFF),
            200: Color(0xFFB4B4FF),
            300: Color(0xFF9A9AFF),
            400: Color(0xFF8080FF),
            500: Color(0xFF6666FF),
            600: Color(0xFF4C4CFF),
            700: Color(0xFF3333FF),
            800: Color(0xFF1A1AFF),
            900: Color(0xFF00008B),
          }),
          accentColor: Colors.yellow,
          brightness: Brightness.light,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 70),

              Text(
                'Please Enter your phone number',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    // Circular border
                    borderSide: BorderSide(
                        color: Colors.blue[900]!, width: 2), // Dark blue border
                  ),
                  prefix: Text("+91  "), // +91 Prefix
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              FloatingActionButton.extended(
                label: Text('Enter', style: TextStyle(color: Colors.blue[900])),
                backgroundColor: Colors.yellow,
                onPressed: () {
                  Get.to(otpenter());
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue[900]!, width: 2.0), // Dark blue border
                  borderRadius: BorderRadius.circular(30.0), // Rounded border
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}