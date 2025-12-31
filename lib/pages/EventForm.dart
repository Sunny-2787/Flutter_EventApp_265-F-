import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _client = Supabase.instance.client;

  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _eventDateCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  List<Map<String, dynamic>> categories = [];
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // ---------------- LOAD CATEGORY ----------------
  Future<void> _loadCategories() async {
    final data = await _client.from('catagory').select('id, Name');
    categories = List<Map<String, dynamic>>.from(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _client.from('events').select(
            'id, name, description, location, event_data, catagory_id, catagory(Name)'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data as List;

          if (events.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final e = events[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e['name'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,letterSpacing: 2),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 23, 115, 191)),
                                onPressed: () {
                                  _showUpdateDialog(e);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () async {
                                  await _client
                                      .from('events')
                                      .delete()
                                      .eq('id', e['id']);
                                  setState(() {});
                                  
                                      ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Event deleted successfully'),
                                                backgroundColor: Color.fromARGB(255, 241, 44, 0),
                                              ),
                                            );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Icon(Icons.event),
                      Text(" Description: ${e['description']}"),
                      const SizedBox(height: 4),
                      Text(" Location: ${e['location']}"),
                      const SizedBox(height: 4),
                      Text(" Event Date: ${e['event_data']}"),
                      const SizedBox(height: 4),
                      Text(
                        " Category: ${e['catagory']['Name']}",
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
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
    _nameCtrl.clear();
    _descriptionCtrl.clear();
    _locationCtrl.clear();
    _eventDateCtrl.clear();
    selectedCategoryId = null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Event'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: _descriptionCtrl,
                decoration:
                    const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _locationCtrl,
                decoration:
                    const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _eventDateCtrl,
                decoration:
                    const InputDecoration(labelText: 'Event Date'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration:
                    const InputDecoration(labelText: 'Category'),
                items: categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c['id'].toString(),
                    child: Text(c['Name']),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategoryId = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (selectedCategoryId != null) {
                await _client.from('events').insert({
                  'name': _nameCtrl.text,
                  'description': _descriptionCtrl.text,
                  'location': _locationCtrl.text,
                  'event_data': _eventDateCtrl.text,
                  'catagory_id': selectedCategoryId,
                });
                Navigator.pop(context);
                setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Event added successfully'),
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

  void _showUpdateDialog(Map event) {
    _nameCtrl.text = event['name'];
    _descriptionCtrl.text = event['description'];
    _locationCtrl.text = event['location'];
    _eventDateCtrl.text = event['event_data'];
    selectedCategoryId = event['catagory_id']?.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Event'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: _descriptionCtrl,
                decoration:
                    const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _locationCtrl,
                decoration:
                    const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _eventDateCtrl,
                decoration:
                    const InputDecoration(labelText: 'Event Date'),
          
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration:
                    const InputDecoration(labelText: 'Category'),
                items: categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c['id'].toString(),
                    child: Text(c['Name']),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategoryId = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
ElevatedButton(
  onPressed: () async {
    await _client.from('events').update({
      'name': _nameCtrl.text,
      'description': _descriptionCtrl.text,
      'location': _locationCtrl.text,
      'event_data': _eventDateCtrl.text,
      'catagory_id': int.parse(selectedCategoryId!), 
    }).eq('id', event['id']);

    Navigator.pop(context);
    setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event deletd successfully'),
        backgroundColor: Color.fromARGB(255, 3, 137, 246),
      ),
    );
  },
  child: const Text('Update'),
),

        ],
      ),
    );
  }
}
