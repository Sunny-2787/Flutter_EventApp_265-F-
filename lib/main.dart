import 'dart:async';


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:event_management/auth/sign_in.dart';.
import 'package:event_management/Auth_Servics/Auth_gate.dart';


void main()async {
  await Supabase.initialize(url: "https://amxencxaoqtpqkfeazca.supabase.co",anonKey: "sb_publishable_F7JCUz4FctEBO-yYPhiHDA_xDrIWETh");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: splashscreen(),
      
      
    );
  }
}




class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState()

  
  {
    super.initState();
    
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context,
      MaterialPageRoute(
        builder: (context)=> AuthGate(),
      ),
      );
    });

  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,





      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("images/logo.jpeg" ,
            width: 150,
         ),
        ),
        SizedBox(height: 20),
        Text("Event Management",style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0) , fontSize: 20 , fontWeight: FontWeight.bold,letterSpacing: 1.2) ,),
        SizedBox(height: 8),

        Text("Connect . Reserve . Celebrate",style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0) , fontSize: 14 ,) ,),
        SizedBox(height: 40),
        const CircularProgressIndicator(color: Color.fromARGB(255, 2, 116, 23),),

        ], 
      ),
      
    );
  }
}
