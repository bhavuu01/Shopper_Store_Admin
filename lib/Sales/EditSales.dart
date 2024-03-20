import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperstore/Sales/SalesModel.dart';

class EditSales extends StatefulWidget {

  final SalesModel sales;
  final String image;

  const EditSales({Key? key, required this.sales, required this.image}) : super (key: key);

  @override
  State<EditSales> createState() => _EditSalesState();
}

class _EditSalesState extends State<EditSales> {

  File? selectedImage;
  TextEditingController salesController = TextEditingController();
  bool isLoading = false;


  @override

  void initState() {
    super.initState();
    salesController.text = widget.sales.sales.trim();
  }

  Future<void> _updateSales() async{

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

    DocumentReference salesref = FirebaseFirestore.instance.collection('Sales').doc(widget.sales.id);

    Map<String, dynamic> updatedData = {'sales': salesController.text,};

    if(selectedImage != null){
      String imageUrl = await uploadImageToStorage(selectedImage!);
      updatedData['image'] = imageUrl;
    } try{
      await salesref.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sales updated successfully'),
        backgroundColor: Colors.cyan,
        ),
      ); setState(() {

      });
    } catch (error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update sales'),
        ),
      );
    }
  }

  bool _validateFields() {
    return salesController.text.isNotEmpty;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageref = FirebaseStorage.instance.ref().child('Sales_image/${widget.sales.id}');
    await storageref.putFile(imageFile);
    return await storageref.getDownloadURL();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Sales', style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            // color: Colors.black
          ),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),

              Container(
                width: double.infinity,
                height: 60,
                child: TextFormField(
                  controller: salesController,
                  decoration: const InputDecoration(
                    labelText: 'Sale Name',
                    // labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              selectedImage != null
                  ? Image.file(selectedImage!,height: 200,width: 200,)
                  : Image.network(
                widget.image,
                width: 200,
                height: 200,),

              const SizedBox(height: 20,),

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
                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: const Text('Select Image',style: TextStyle(color: Colors.white, fontSize: 16),),
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
                    await _updateSales();
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
