
import 'package:event_management/Auth_Servics/supabase.dart';
import 'package:event_management/auth/sign_up.dart';
// import 'package:event_management/pages/catagoryform.dart';
import 'package:event_management/pages/dashboard.dart';
import 'package:flutter/material.dart';



class Sign_in extends StatefulWidget {
  const Sign_in({super.key});

  @override
  State<Sign_in> createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
    final _emailController = TextEditingController();
    final _passwordcontroller = TextEditingController();
     final authservice = Authservice();
     void login()async{
      final email  = _emailController.text;
      final password  = _passwordcontroller.text;

      try{
        await authservice.signinwithemailandpassword(email, password);
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfull")));
        }
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
        );
        

      }catch(e){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error : $e")));
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
          Color.fromARGB(255, 255, 60, 0),
          Color.fromARGB(255, 226, 133, 52),
          Color.fromARGB(209, 228, 105, 12)        ]),
        ),
        padding: EdgeInsets.only(top: 50),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          

          children: [
            
              Text("Login" , style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              letterSpacing: 7,
              color: Colors.white
            ),
            ),

            Text("Welcome Back" , style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            letterSpacing: 5
          ),
          ),
          SizedBox(height: 30),

          Expanded(child: Container(
            
            padding: EdgeInsets.all(100),
          
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
                   obscureText: true,
                 ),
                 SizedBox(height: 25),
                 ElevatedButton(
                 
                   
                   onPressed: () {
                      login();
                              
                   },
                   style:ElevatedButton.styleFrom(
                     backgroundColor: const Color.fromARGB(172, 50, 177, 54),
                     elevation: 7,
                     foregroundColor:  Color.fromARGB(255, 255, 255, 255),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(50),
                     
                     ),
                     minimumSize: Size(20, 20),
                              
                              
                   ),
                    
                   child: Text("Login",style: TextStyle(
                     color: Colors.black,
                     fontSize: 20,
                              
                   ),
                   ),                 
                 ),
                SizedBox(height: 50),
                Padding(padding:EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  


                  children: [
                    
                    Text("Don't have an account?", style: TextStyle(
                    color: Colors.red,
                    
                    ),
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Sign_Up(),));     


                    },
                    style: ElevatedButton.styleFrom(
                       minimumSize: Size(10, 10),
                      
                      backgroundColor: const Color.fromARGB(255, 247, 243, 243)
                    ),
                    
                    child: Text("Sign Up",style: TextStyle(
                      fontSize: 10
                      

                    
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



            // Text("Sign In",textAlign:TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 255, 255, 255)),),