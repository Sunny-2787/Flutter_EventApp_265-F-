import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_management/auth/sign_in.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
  
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A11CB), Color(0xff2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE0EAFc), Color(0xffCFDEF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: user == null
            ? const Center(
                child: Text(
                  "No user logged in",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  elevation: 5,
  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: ListTile(
    leading: const Icon(Icons.person, color: Colors.blue),
    title: const Text(
      "Details",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        const Text(
          "Name: Md Static",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 2),
        const Text(
          "ID: Stattic:  12345", 
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(
          "Email: ${user.email ?? "No email"}", 
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    ),
  ),
),


        const SizedBox(height: 30),

      
        ElevatedButton.icon(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Sign_in()),
                (route) => false,
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text("Sign Out"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
