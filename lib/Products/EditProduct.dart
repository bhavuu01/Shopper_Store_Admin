import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperstore/Products/ProductModel.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;
  final String images;
//
//   final ProductModel product;
//   final String images;
//   // final String category;
  // final String brand;
  // final String productName;
  // final String productPrice;
  // final String color;
  // final String productDescription;
  // final String product1;
  // final String product2;
  // final String product3;
  // final String product4;
  // final String title1;
  // final String title2;
  // final String title3;
  // final String title4;
  // final String discount;
  // final String newPrice;
  //

  //   required this.product,
  //   required this.images,
  //   // required this.category,
  //   // required this.brand,
  //   required this.productName,
  //   required this.productPrice,
  //   required this.color,
  //   required this.productDescription,
  //   required this.product1,
  //   required this.product2,
  //   required this.product3,
  //   required this.product4,
  //   required this.title1,
  //   required this.title2,
  //   required this.title3,
  //   required this.title4,
  //   required this.discount,
  //   required this.newPrice,
  EditProduct({Key? key,required this.product, required this.images,
  }) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  String? selectCategory;
  String? selectBrand;
  String? selectedCategory;
  List<File>? selectedImage;
  String? selectedBrand;
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController title1Controller = TextEditingController();
  final TextEditingController product1Controller = TextEditingController();
  final TextEditingController title2Controller = TextEditingController();
  final TextEditingController product2Controller = TextEditingController();
  final TextEditingController title3Controller = TextEditingController();
  final TextEditingController product3Controller = TextEditingController();
  final TextEditingController title4Controller = TextEditingController();
  final TextEditingController product4Controller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController newpriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  bool isLoading = false;

  @override

  void initState() {
    super.initState();
    selectCategory = widget.product.category.toString();
    selectedBrand = widget.product.brand.toString();
    productNameController.text = widget.product.productName.toString();
    priceController.text = widget.product.productPrice.toString();
    colorController.text = widget.product.color.toString();
    title1Controller.text = widget.product.title1.toString();
    product1Controller.text = widget.product.product1.toString();
    title2Controller.text = widget.product.title2.toString();
    product2Controller.text = widget.product.product2.toString();
    title3Controller.text = widget.product.title3.toString();
    product3Controller.text = widget.product.product3.toString();
    title4Controller.text = widget.product.title4.toString();
    product4Controller.text = widget.product.product4.toString();
    descriptionController.text = widget.product.productDescription.toString();
    newpriceController.text = widget.product.newPrice.toString();
    discountController.text = widget.product.discount.toString();
    final color = colorController.text.trim();

  }

  Future<void> _updateProduct() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference productRef = FirebaseFirestore.instance.collection('Products').doc(widget.product.id);

    List<String> imageUrls = [];

    if (selectedImage != null) {
      for (File imageFile in selectedImage!) {
        String imageUrl = await uploadImageToStorage(imageFile);
        imageUrls.add(imageUrl);
      }
    }

    Map<String, dynamic> updatedData = {
      'productName': productNameController.text,
      'price': priceController.text,
      'discount': discountController.text,
      'productNewPrice': newpriceController.text,
      'productColor': colorController.text,
      'productTitleDetail1': title1Controller.text,
      'productTitleDetail2': title2Controller.text,
      'productTitleDetail3': title3Controller.text,
      'productTitleDetail4': title4Controller.text,
      'productTitle1': product1Controller.text,
      'productTitle2': product2Controller.text,
      'productTitle3': product3Controller.text,
      'productTitle4': product4Controller.text,
      'productDescription': descriptionController.text,
      if (imageUrls.isNotEmpty) 'images': imageUrls,
    };

    try {
      await productRef.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Edited Successfully'),
          backgroundColor: Colors.cyan,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update product'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<String> uploadImageToStorage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('Product_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product',style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),

              if (selectedImage != null && selectedImage!.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImage!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200, // Set a fixed width for each image
                          child: Image.file(selectedImage![index], height: 200, width: 200),
                        ),
                      );
                    },
                  ),
                )
              else
                Image.network(
                  widget.images,
                  width: 200,
                  height: 200,
                ),


              const SizedBox(height: 20,),

              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  ImagePicker imagepicker = ImagePicker();
                 List<XFile>? files = await imagepicker.pickMultiImage();
                  if(files == null)
                    return;
                  selectedImage = files.map((file) => File(file.path)).toList();
                  setState(() {

                  });

                }, child: const Text('Select Images', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                  ),
                 ),
                ),
              ),

              SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: discountController,
                  decoration: InputDecoration(
                    labelText: 'Discount',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: newpriceController,
                  decoration: InputDecoration(
                    labelText: 'New Price',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: colorController,
                  decoration: InputDecoration(
                    labelText: 'Edit Color',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),




              Container(
                child: TextFormField(
                  controller: title1Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 1',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                child: TextFormField(
                  controller: product1Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 1',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: title2Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 2',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: product2Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 2',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: title3Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 3',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: product3Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 3',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: title4Controller,
                  decoration: InputDecoration(
                    labelText: 'Title 4',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: product4Controller,
                  decoration: InputDecoration(
                    labelText: 'Product 4',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Edit Description',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),


              const SizedBox(height: 20,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  setState(() {
                    isLoading = true;
                  });
                  await _updateProduct();
                  setState(() {
                    isLoading = false;
                  });
                 }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: isLoading
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text('Save',style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
