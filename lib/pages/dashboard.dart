// import 'package:event_management/auth/sign_in.dart';
import 'package:event_management/pages/Profile.dart';
import 'package:event_management/pages/catagoryform.dart';
import 'package:event_management/pages/EventForm.dart';
import 'package:event_management/pages/participantsform.dart';
// import 'package:event_management/pages/Profile.dart';
import 'package:flutter/material.dart';
// import 'package:event_management/Auth_Servics/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _dashboardCard(
              context,
              icon: Icons.category,
              title: 'Categories',
              onTap: () => _go(context, const CategoryPage()),
            ),
            _dashboardCard(
              context,
              icon: Icons.event,
              title: 'Events',
              onTap: () => _go(context, const EventPage()),
            ),
            _dashboardCard(
              context,
              icon: Icons.people,
              title: 'Participants',
              onTap: () => _go(context, const ParticipantsPage()),
            ),
            _dashboardCard(
              context,
              icon: Icons.person,
              title: 'Profile',
              onTap:  
                () => _go(context, const Profilepage())
              
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
