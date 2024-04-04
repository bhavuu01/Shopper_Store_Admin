import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperstore/Category/categorymodel.dart';
import 'package:shopperstore/Category/editcategory.dart';

import 'BrandModel.dart';

class EditBrand extends StatefulWidget {

  final BrandModel brand;
  final String image;

  const EditBrand({Key? key, required this.brand, required this.image}) : super(key: key);

  @override
  State<EditBrand> createState() => _EditBrandState();
}

class _EditBrandState extends State<EditBrand> {

  File? selectedImage;
  TextEditingController brandController = TextEditingController();
  bool isLoading = false;

  @override

  void initState() {
    super.initState();
    brandController.text = widget.brand.brand.trim();
  }

  Future<void> _updateBrand() async{

    if (!_validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    DocumentReference brandref = FirebaseFirestore.instance.collection('Brands').doc(widget.brand.id);
    Map<String, dynamic> updatedData = {'brand' : brandController.text
    };
    if(selectedImage != null) {
      String imageUrl = await uploadImageToUpload(selectedImage!);
      updatedData['image'] = imageUrl;
    }
      try{
      await brandref.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Brand added successfully'),
      backgroundColor: Colors.cyan,
        )
      );
      setState(() {

      });
      } catch(error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update brands'),
        )
      );
    }
}
  bool _validateFields() {
    return brandController.text.isNotEmpty;
  }
Future<String> uploadImageToUpload(File imageFile) async{
    Reference storageref = FirebaseStorage.instance.ref().child('Brand_images/${widget.brand.id}');
    await storageref.putFile(imageFile);
    return await storageref.getDownloadURL();
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Brand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.white),),
        backgroundColor: Colors.cyan,
        elevation: 20,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              
              Container(
                child: TextFormField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: 'Brand Name',
                    // labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan)
                    )
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              
              selectedImage != null
                ? Image.file(selectedImage!, height: 200, width: 200,)
                : Image.network(
                widget.image,
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20,),

              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  ImagePicker imagepicker = ImagePicker();
                  XFile? file = await imagepicker.pickImage(source: ImageSource.gallery);
                  if (file == null)
                    return;
                  selectedImage = File(file.path);
                  setState(() {

                  });
                }, style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan),
                child: const Text('Select Image', style: TextStyle(color: Colors.white, fontSize: 15),)),
              ),
              const SizedBox(height: 20,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  setState(() {
                    isLoading = true;
                  });
                 await _updateBrand();
                 setState(() {
                   isLoading = false;
                 });
                }, style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan
                ),
                  child: isLoading
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : const Text('Save',style: TextStyle(color: Colors.white,),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
