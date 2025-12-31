import 'package:supabase_flutter/supabase_flutter.dart';

class catagorydb{
  final catagory = Supabase.instance.client.from('catagory');
  Future<void>insertCatagory(String name )async{
    await catagory.insert({"Name":name});
  }
  Future<void>updatacatagory(dynamic catagoryId , String name)async{
    await catagory.update({"Name" : name}).eq('id',catagoryId );
  }
  Future<void>deletcatagory(dynamic catagoryId)async{
    await catagory.delete().eq('id',catagoryId );
  }

}