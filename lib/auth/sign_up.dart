import 'package:event_management/Auth_Servics/supabase.dart';
import 'package:event_management/auth/sign_in.dart';
import 'package:event_management/pages/dashboard.dart';
import 'package:flutter/material.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({super.key});

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  final _emailController = TextEditingController();
    final _passwordcontroller = TextEditingController();
    final _Confirmpasswordcontroller  = TextEditingController();
    final authservice =Authservice();
    void signup()async{
      final email = _emailController.text;
      final password = _passwordcontroller.text;
      final confirmpass = _Confirmpasswordcontroller.text;
      if(password!=confirmpass){
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Not match")));
        return;
      }
      try{
        await authservice.signupwithemailandpssword(email, password);
        if (mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SignUp succsesfull")));
        
        }
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
        );
        

      }

      catch(e){
        if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));

        }

      }

    }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
     body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
          Color.fromARGB(255, 60, 255, 0),
          Color.fromARGB(255, 116, 226, 52),
          Color.fromARGB(209, 12, 228, 59)        ]),
        ),
        padding: EdgeInsets.only(top: 50),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          

          children: [
            
              Text("Sign Up" , style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              letterSpacing: 7,
              color: Colors.white
            ),
            ),

            Text("First Create Your Account" , style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            letterSpacing: 5
          ),
          ),
          SizedBox(height: 5),

          Expanded(child: Container(
            
            padding: EdgeInsets.only(top: 100,left: 30,right: 30),
          
              width: double.infinity,

              decoration:
               BoxDecoration(            color:  Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
              ),
              
              child: Column(
               
                              
               children: [
                 
                 TextField(
                  controller: _emailController,
                   
                   
                   decoration: InputDecoration(
                    
                     
                     labelText: "Email",
                     hintText: "Enter Your Email",
                     prefixIcon: Icon(Icons.email),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                              
                     ),
                   ),
                 ),
                 SizedBox(height: 20),
                 TextField(
                  controller: _passwordcontroller,
                   
                   
                   decoration: InputDecoration(
                     
                     labelText: "Password",
                     hintText: "Enter Your Password",
                     prefixIcon: Icon(Icons.password),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                              
                     ),
                   ),
                 ),
                 SizedBox(height: 20),
                 TextField(
                  controller: _Confirmpasswordcontroller,
                              
                   decoration: InputDecoration(
                       
                     
                     labelText: "Confirm Password",
                     hintText: "Enter Your same Password",
                     prefixIcon: Icon(Icons.password),
                     border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                              
                     ),
                   ),
                   obscureText: true,
                 ),
                 SizedBox(height: 25),
                 ElevatedButton(
                 
                   
                   onPressed: () {
                      signup();
                    
                              
                   },
                   style:ElevatedButton.styleFrom(
                     backgroundColor: const Color.fromARGB(255, 0, 43, 236),
                     elevation: 7,
                     foregroundColor:  Color.fromARGB(255, 255, 255, 255),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(25),
                     
                     ),
                     minimumSize: Size(15, 20),
                              
                              
                   ),
                    
                   child: Text("Sign Up",style: TextStyle(
                     color: const Color.fromARGB(255, 255, 255, 255),
                     fontSize: 15,
                              
                   ),
                   ),                 
                 ),
                SizedBox(height: 10),
                Padding(padding:EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  


                  children: [
                    
                    Text("Already have an account?", style: TextStyle(
                    color: Colors.red,
                    
                    ),
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Sign_in(),));     


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(129, 163, 198, 243),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      minimumSize: Size(10, 10),
                      
                    ),
                    
                    child: Text("Login",style: TextStyle(
                    

                    
                    ),
                    ),
                    ),

                    
                   
                   
                  ],
                ),
                
                
                )

                 
                              
                 
                              
                              
               ],
                              
                              )
              

              
              
              
            
            ),
          )
          

          
          

    


          

          

          ],
          
        ),
        
      ),

    );
  }
}