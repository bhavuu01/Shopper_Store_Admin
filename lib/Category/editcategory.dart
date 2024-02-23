import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperstore/Category/categorymodel.dart';


class EditCategory extends StatefulWidget {
  final CategoryModel category;
  final String image;

  EditCategory({Key? key, required this.category, required this.image}) : super (key:key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  File? selectedImage;
  TextEditingController categoryController = TextEditingController();
  bool isLoading = false;

  @override

  void initState() {
    super.initState();
    categoryController.text = widget.category.category;
  }

  Future<void> _updateCategory() async{
    DocumentReference categoryref = FirebaseFirestore.instance.collection('Categories').doc(widget.category.id);

    Map<String, dynamic> updatedData = {'category': categoryController.text,
  };
    if(selectedImage != null){
      String imageUrl = await uploadImageToStorage(selectedImage!);
      updatedData['image'] = imageUrl;
    }
    try{
      await categoryref.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category Updated Successfully'),
      backgroundColor: Colors.cyan,
      )
     );
      setState(() {

      });
    } catch(error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update category'),
      )
     );
    }
 }

 Future<String> uploadImageToStorage(File imageFile) async{
    Reference storageref = FirebaseStorage.instance.ref().child('Categories_image/${widget.category.id}');
    await storageref.putFile(imageFile);
    return await storageref.getDownloadURL();
 }
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Edit Category', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,color:
            Colors.white),
       ),
       backgroundColor: Colors.cyan,
       // elevation: 20,
     ),

     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(10),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             SizedBox(height: 20,),
             Container(
               width: double.infinity,
               height: 60,
               child: TextFormField(
                 controller: categoryController,
                 decoration: const InputDecoration(
                   labelText: 'Category Name',
                   labelStyle: TextStyle(color: Colors.black),
                   border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(10)),
                     borderSide: BorderSide(color: Colors.cyan)
                   )
                 ),
               ),
             ),
             const SizedBox(height: 30,),

             selectedImage != null
                 ? Image.file(selectedImage!,height: 200,width: 200,)
                 : Image.network(
               widget.image,
               width: 200,
               height: 200,),

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
                 },
                 child: const Text('Select Image',style: TextStyle(color: Colors.black, fontSize: 16),),
               ),
             ),
             const SizedBox(height: 20,),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: () async {
                   setState(() {
                     isLoading = true;
                   });
                  await _updateCategory();
                  setState(() {
                    isLoading = false;
                  });
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.cyan,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(70),
                   ),
                 ),
                 child: isLoading
                    ? const CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                 )
                    : const Text(
                        'Save',
                           style: TextStyle(fontSize: 16,color: Colors.white),
                 ),
               ),
             )
           ],
         ),
       ),
     ),
   );
 }
}

