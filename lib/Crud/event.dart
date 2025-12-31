import 'package:supabase_flutter/supabase_flutter.dart';

class eventdb {

  final event = Supabase.instance.client.from('events');

 
  Future<void> insertevent(
    String name,
    String description,
    String location,
    DateTime eventDate,
    String catagoryId
) 
  async {
    await event.insert({
      'name': name,
      'description': description,
      'location': location,
      'event_data': eventDate,
      'catagory_id': catagoryId
    });
  }

  Future<void> updateevent(
    dynamic eventId,
    String name,
    String description,
    String location,
    DateTime eventDate,
    String catagoryId
  ) async {
    await event.update({
      'name': name,
      'description': description,
      'location': location,
      'event_data': eventDate,
      'catagory_id': catagoryId
    }).eq('id', eventId);
  }

  Future<void> deletcatagory(dynamic eventId) async {
    await event.delete().eq('id', eventId);
  }
}
