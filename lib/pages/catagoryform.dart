import 'package:flutter/material.dart';
import 'package:event_management/Crud/catagory.dart';
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final catagorydb _db = catagorydb();
  final TextEditingController _controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body:
      Container(
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
          Color.fromARGB(255, 255, 253, 253),
          Color.fromARGB(255, 214, 204, 195),
          Color.fromARGB(209, 138, 129, 122)        ]),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter category name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        await _db.insertCatagory(_controller.text);
                        _controller.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Catagory added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
        
            Expanded(
              child: StreamBuilder(
                stream: _db.catagory.stream(primaryKey: ['id']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  final categories = snapshot.data!;
        
                  if (categories.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }
        
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final item = categories[index];
        
                      return ListTile(
                       leading: Text('${index+1}'),
                        title: Text(item['Name']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(item['id'], item['Name']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _db.deletcatagory(item['id']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Catagory Deleted successfully'),
                                      backgroundColor: Color.fromARGB(255, 208, 58, 13),
                                    ),
                                  );
                              },

                              

                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String id, String oldName) {
    final editController = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _db.updatacatagory(id, editController.text);
              Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catagory Updated successfully'),
        backgroundColor: Color.fromARGB(255, 47, 69, 212),
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
