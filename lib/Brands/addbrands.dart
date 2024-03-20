import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Category/categorymodel.dart';
import '../Category/editcategory.dart';

class AddBrands extends StatefulWidget {
  const AddBrands({super.key});

  @override
  State<AddBrands> createState() => _AddBrandsState();
}

class _AddBrandsState extends State<AddBrands> {

  TextEditingController brand_name = TextEditingController();
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  String? selectedCategory;

  Future<bool> doessubCategoryExist(String subcategoryName) async{
    final querySnapshot = await FirebaseFirestore.instance.collection("Brands")
        .where("brand",isEqualTo:subcategoryName)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addsubCategoryToFirestore() async{
    final subcategory = brand_name.text.trim();
    final category = selectedCategory;

    if(subcategory.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a brand name")),
      );
      return;
    }
    final doesExist = await doessubCategoryExist(subcategory);

    if (doesExist){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Brand already exists")),
      );
    } else{
      setState(() {
        isLoading = true;
      });

      if(selectedImage!= null){
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('Brand_images');
        Reference referenceImageToUpload = referenceDirImage.child(uniquefilename);
        try {
          await referenceImageToUpload.putFile(selectedImage!);
          imageUrl = await referenceImageToUpload.getDownloadURL();
          print("Image URL:$imageUrl");

          FirebaseFirestore.instance.collection("Brands").add({
            'brand': brand_name.text,
            'image': imageUrl,
            'category': category,

          }).then((value) {
            brand_name.clear();
            selectedImage = null;
            selectedCategory = null;
            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Brand Added Successfully"))
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
        title: const Text('Add Brand',style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
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

              CategoryDropdown(
                selectedCategory: selectedCategory,
                onChanged: (value){
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 20,),

              TextFormField(
                controller: brand_name,
                decoration: InputDecoration(
                  labelText: 'Brand Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              selectedImage != null
                  ? Image.file(selectedImage!,height: 200,width: 200,)
                  : Image.asset("asset/images/picture.png",height: 200,width: 200,),



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

                    addsubCategoryToFirestore();
                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[300]),
                  child: isLoading
                      ?const CircularProgressIndicator(color: Colors.white,)
                      :const Text('Add Brand', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ),
              const SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;


  const CategoryDropdown({required this.selectedCategory, required this.onChanged, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData){
            return CircularProgressIndicator();
          }

          final categoryDocs = snapshot.data!.docs;
          List <CategoryModel> categories = [];

          for(var doc in categoryDocs){
            final category = CategoryModel.fromSnapshot(doc);
            categories.add(category);
          }

        return DropdownButtonFormField<String>(
        value: selectedCategory,
        onChanged: onChanged,
        decoration: const InputDecoration(
          labelText: 'Select Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.cyan)
            )
          ),
          items: categories.map((CategoryModel category){
            return DropdownMenuItem<String>(
              value: category.category,
              child: Text(category.category, style: TextStyle(color: Colors.cyan),
              ),
            );
          }).toList(),
            validator: (value){
            if(value == null || value.isEmpty){
              return 'Please select a Category';
              }
             return null;
            },
        );
      }
    );
  }
}


// class BrandsScreen extends StatelessWidget {
//   const BrandsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('Brands').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: const CircularProgressIndicator());
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
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             // child: Text((index + 1).toString()),
//                           ),
//                           const Spacer(),
//                           Text(category.category, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
//                           const Spacer(),
//                           Image.network(
//                               category.image, width: 200, height: 150),
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
//                                 // border: Border.all(color: Colors.blue),
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.push(context, MaterialPageRoute(builder: (context) => EditCategory(category: category,image: category.image,),));
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
//                                 // border: Border.all(color: Colors.blue),
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
//                                               // deleteCategory(category.id);
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
//                                     color: Colors.red)),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }
// }
