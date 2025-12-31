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

  // ---------------- LOAD EVENTS ----------------
  Future<void> _loadEvents() async {
    final data = await _client.from('events').select('id, name,event_data');
    events = List<Map<String, dynamic>>.from(data);
    setState(() {});
  }

  // ---------------- FETCH PARTICIPANTS ----------------
  Future<List<Map<String, dynamic>>> _fetchParticipants() async {
    final data = await _client.from('participants').select('id, name, email, event_id');
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Widget build(BuildContext context) {
    // Map event_id → event name
    Map<String, String> eventMap = {
      for (var e in events)
       e['id'].toString(): e['name'],
       
    };

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 155, 161, 195),

      appBar: AppBar(title: const Text('Participants'),
      backgroundColor: const Color.fromARGB(255, 140, 95, 212),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 4, 212, 49),
      ),
      body:
       FutureBuilder(
        future: _fetchParticipants(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final participants = snapshot.data as List;

          if (participants.isEmpty) {
            return const Center(child: Text('No participants found'));
          }

          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final p = participants[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Text('${index + 1}'),
                  title: Text('Name: ${p ['name']}'),
                  subtitle: Text(
                    'E-mail: ${p['email']}\nEvent: ${eventMap[p['event_id'].toString()]}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(p, eventMap),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _db.deleteparticipant(p['id']);
                          _refresh();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Participant delete successfully'),
                                  backgroundColor: Color.fromARGB(255, 253, 2, 2),
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

  void _showAddDialog() {
    _clearFields();
    selectedEventId = null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Participant'),
        content: _form(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedEventId != null) {
                await _db.insertparticipant(
                  _nameCtrl.text,
                  _emailCtrl.text,
                  selectedEventId!,
                );

                Navigator.pop(context);
                _refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Participant added successfully'),
                          backgroundColor: Colors.green,
                        ),
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
        title: const Text('Edit Participant'),
        content: _form(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedEventId != null) {
                await _db.updateparticipant(
                  p['id'],
                  _nameCtrl.text,
                  _emailCtrl.text,
                  selectedEventId!,
                );
                Navigator.pop(context);
                _refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Participant Update successfully'),
        backgroundColor: Color.fromARGB(255, 0, 193, 251),
      ),
    );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // ---------------- FORM ----------------
  Widget _form() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedEventId,
            decoration: const InputDecoration(labelText: 'Event'),
            items: events.map((e) {
              return DropdownMenuItem<String>(
                value: e['id'].toString(),
                child: Text(e['name']),
              );
            }).toList(),
            onChanged: (value) {
              selectedEventId = value;
            },
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    _nameCtrl.clear();
    _emailCtrl.clear();
    selectedEventId = null;
  }
}
