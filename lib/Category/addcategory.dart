import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperstore/Category/categorymodel.dart';


class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  TextEditingController category_name = TextEditingController();
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  String? selectedCategory;

  Future<bool> doesCategoryExist(String categoryName) async{
    final querySnapshot = await FirebaseFirestore.instance.collection("Categories")
        .where("category",isEqualTo:categoryName)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addCategoryToFirestore() async{
    final category = category_name.text.trim();

    if(category.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a category name")),
      );
      return;
    }
    final doesExist = await doesCategoryExist(category);

    if (doesExist){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Category already exist")),
      );
    } else{
      setState(() {
        isLoading = true;
      });
      if(selectedImage!= null){
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('Category_images');
        Reference referenceImageToUpload = referenceDirImage.child(uniquefilename);
        try {
          await referenceImageToUpload.putFile(selectedImage!);
          imageUrl = await referenceImageToUpload.getDownloadURL();
          print("Image URL:$imageUrl");

          FirebaseFirestore.instance.collection("Categories").add({
            'category': category_name.text,
            'image': imageUrl,
          }).then((value) {
            category_name.clear();
            selectedImage = null;
            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Category Added Successfully"))
            );
          });
        } catch (error){
          print("Error uploading image: $error");
        }
      } else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an image"))
        );
          }
        }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add Category',style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: category_name,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Colors.cyan),
                  )
                ),
              ),
              const SizedBox(height: 20,),
              selectedImage != null
                  ? Image.file(selectedImage!,height: 200,width: 200,)
                  : Image.asset("asset/images/nophoto.png",height: 160,width: 200,),



              const SizedBox(height: 20),
              // Button for selecting an image
              Container(
                width: double.infinity,
                child: ElevatedButton (
                  onPressed: () async {
                    ImagePicker imagepicker = ImagePicker();
                    XFile? file = await imagepicker.pickImage(source: ImageSource.gallery);
                    if (file == null)
                      return;
                    selectedImage = File(file.path);
                    setState(() {});
                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[300]),
                  child: const Text('Select Image', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    addCategoryToFirestore();
                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[300]),
                  child: isLoading
                      ?const CircularProgressIndicator()
                      :const Text('Add Category', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ),
              const SizedBox(height: 20,),

              // CategoryDropdown(
              //   selectedCategory: selectedCategory,
              //   onChanged: (value){
              //     setState(() {
              //       selectedCategory = value;
              //     });
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}

// class CategoryDropdown extends StatelessWidget {
//   final String? selectedCategory;
//   final ValueChanged<String?> onChanged;
//
//
//   const CategoryDropdown({required this.selectedCategory, required this.onChanged, Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
//         builder: (context, snapshot){
//           if (!snapshot.hasData){
//             return const CircularProgressIndicator();
//           }
//
//           final categoryDocs = snapshot.data!.docs;
//           List <CategoryModel> categories = [];
//
//           for(var doc in categoryDocs){
//             final category = CategoryModel.fromSnapshot(doc);
//             categories.add(category);
//           }
//
//           return DropdownButtonFormField<String>(
//             value: selectedCategory,
//             onChanged: onChanged,
//             decoration: const InputDecoration(
//               labelText: 'Select a Category',
//               labelStyle: TextStyle(color: Colors.cyan),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(3)),
//               ),
//             ),
//             items: categories.map((CategoryModel category){
//               return DropdownMenuItem<String>(
//                 value: category.category,
//                 child: Text(category.category, style: TextStyle(color: Colors.black),
//                 ),
//               );
//             }).toList(),
//             validator: (value){
//               if(value == null || value.isEmpty){
//                 return 'Please select a Category';
//               }
//               return null;
//             },
//           );
//         }
//     );
//   }
// }

// class CategoryList extends StatelessWidget {
//
//   const CategoryList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//           final categoryDocs = snapshot.data!.docs;
//           List<CategoryModel> categories = [];
//
//           for (var doc in categoryDocs) {
//             final category = CategoryModel.fromSnapshot(doc);
//             categories.add(category);
//           }
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20, vertical: 10),
//                 child: Card(
//                   elevation: 5,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 10),
//                             child: Text((index + 1).toString()),
//                           ),
//                           const Spacer(),
//                           Text(category.category),
//                           const Spacer(),
//                           Image.network(
//                               category.image, width: 100, height: 100),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(right: 80),
//                             child: Container(
//                               width: 70,
//                               height: 35,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.blue),
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//
//                                 },
//                                 child: const Text(
//                                   'Edit',
//                                   style: TextStyle(fontSize: 12,
//                                       color: Colors.cyan),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 20),
//                             child: Container(
//                               width: 70,
//                               height: 35,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.blue),
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: const Text('Confirm Deletion',),
//                                         content: const Text(
//                                             'Are you sure you want to delete this category?'),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               // Dismiss the dialog
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text('Cancel'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text('Yes'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: const Text('Delete', style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.cyan)),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                  ),
//             ),
//           );
//         },
//      );
//    });
//   }


