import 'package:supabase_flutter/supabase_flutter.dart';
class Authservice{
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<AuthResponse>signinwithemailandpassword(
    String email,
    String password,
  )async{
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password);
  }

  Future<AuthResponse>signupwithemailandpssword(
    String email,
    String password,
  )async{
    return await _supabase.auth.signUp(
      email: email,
      password: password);
  }
  Future<void>signOut()async{
    await _supabase.auth.signOut();
  }
  String? getCurrentUserEmail(){
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

}

