import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopperstore/Category/addcategory.dart';
import 'package:shopperstore/Category/categorymodel.dart';
import 'package:shopperstore/Category/editcategory.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _searchText = '';

  void _deleteCategory(String categoryID) {
    FirebaseFirestore.instance
        .collection('Categories')
        .doc(categoryID)
        .delete()
        .then((value) {
      Fluttertoast.showToast(
        msg: 'Category Deleted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed to delete category',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Categories',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyan),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Category ...',
                      hintStyle: TextStyle(color: Colors.cyan),
                      suffixIcon: Icon(Icons.search, color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CategoryList(
                deleteCategory: _deleteCategory,
                searchText: _searchText,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddCategory(),
          ));
        },
        child: const Icon(Icons.add, color: Colors.black, size: 25.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class CategoryList extends StatelessWidget {
  final Function(String) deleteCategory;
  final String searchText;
  const CategoryList({
    Key? key,
    required this.deleteCategory,
    required this.searchText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final categoryDocs = snapshot.data!.docs;
          List<CategoryModel> categories = [];

          for (var doc in categoryDocs) {
            final category = CategoryModel.fromSnapshot(doc);
            categories.add(category);
          }

          List<CategoryModel> filteredCategories = categories.where((category) {
            return category.category.toLowerCase().contains(searchText);
          }).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Text(
                          category.category,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Image.network(category.image,
                            width: 300, height: 200),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCategory(
                                          category: category,
                                          image: category.image,
                                        ),
                                      ));
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.cyan),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Confirm Deletion',
                                        ),
                                        content: const Text(
                                            'Are you sure you want to delete this category?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteCategory(category.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Delete',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
