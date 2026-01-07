import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_management/Crud/participants.dart';

class ParticipantsPage extends StatefulWidget {
  const ParticipantsPage({super.key});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  final participantsdb _db = participantsdb();
  final _client = Supabase.instance.client;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  List<Map<String, dynamic>> events = [];
  String? selectedEventId;

  void _refresh() => setState(() {});

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final data = await _client.from('events').select('id, name,event_data');
    events = List<Map<String, dynamic>>.from(data);
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _fetchParticipants() async {
    final data =
        await _client.from('participants').select('id, name, email, event_id');
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Widget build(BuildContext context) {

    Map<String, String> eventMap = {for (var e in events) e['id'].toString(): e['name']};

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

    
      appBar: AppBar(
        title: const Text('Participants'),
        elevation: 0,
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

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        backgroundColor:  Color.fromARGB(255, 51, 109, 247),
      ),

      body: FutureBuilder(
        future: _fetchParticipants(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final participants = snapshot.data as List;

          if (participants.isEmpty) {
            return const Center(child: Text('No participants found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final p = participants[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade200,
                    child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Email: ${p['email']}'),
                      const SizedBox(height: 2),
                      Text('Event Name: ${eventMap[p['event_id'].toString()]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(p, eventMap),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _db.deleteparticipant(p['id']);
                          _refresh();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Participant deleted successfully'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(_nameCtrl, 'Name'),
          const SizedBox(height: 10),
          _buildTextField(_emailCtrl, 'Email', keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedEventId,
            decoration: const InputDecoration(labelText: 'Event', border: OutlineInputBorder()),
            items: events.map((e) {
              return DropdownMenuItem<String>(
                value: e['id'].toString(),
                child: Text(e['name']),
              );
            }).toList(),
            onChanged: (value) => selectedEventId = value,
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    _clearFields();
    selectedEventId = null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Add Participant'),
        content: _form(),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (selectedEventId != null) {
                await _db.insertparticipant(_nameCtrl.text, _emailCtrl.text, selectedEventId!);
                Navigator.pop(context);
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Participant added successfully'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map p, Map<String, String> eventMap) {
    _nameCtrl.text = p['name'];
    _emailCtrl.text = p['email'];
    selectedEventId = p['event_id'].toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Edit Participant'),
        content: _form(),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (selectedEventId != null) {
                await _db.updateparticipant(p['id'], _nameCtrl.text, _emailCtrl.text, selectedEventId!);
                Navigator.pop(context);
                _refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Participant updated successfully'), backgroundColor: Colors.blueAccent),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _clearFields() {
    _nameCtrl.clear();
    _emailCtrl.clear();
    selectedEventId = null;
  }
}
