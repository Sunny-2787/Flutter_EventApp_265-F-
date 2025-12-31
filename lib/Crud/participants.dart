import 'package:supabase_flutter/supabase_flutter.dart';

class participantsdb {

  final participants = Supabase.instance.client.from('participants');

  Future<void> insertparticipant(String name,String email, dynamic eventId
  ) async {
    await participants.insert({
      'name': name,
      'email': email,
      'event_id': eventId
    });
  }

  Future<void> updateparticipant(dynamic participantId,String name,String email,dynamic eventId) async {
    await participants.update({
      'name': name,
      'email': email,
      'event_id': eventId
    }).eq('id', participantId);
  }

  Future<void> deleteparticipant(dynamic participantId) async {
    await participants.delete().eq('id', participantId);
  }
}
